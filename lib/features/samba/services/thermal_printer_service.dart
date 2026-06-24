import 'dart:typed_data';
import 'package:bangunarta_portal/models/samba/cetak_simpanan_model.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';
import 'package:intl/intl.dart';

/// Hasil dari permintaan permission Bluetooth
enum BluetoothPermissionResult { granted, denied, permanentlyDenied }

class ThermalPrinterService {
  static Future<BluetoothPermissionResult> requestBluetoothPermission() async {
    final statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();

    final connectStatus = statuses[Permission.bluetoothConnect]!;
    final scanStatus = statuses[Permission.bluetoothScan]!;

    if (connectStatus.isGranted && scanStatus.isGranted) {
      return BluetoothPermissionResult.granted;
    }

    if (connectStatus.isPermanentlyDenied || scanStatus.isPermanentlyDenied) {
      return BluetoothPermissionResult.permanentlyDenied;
    }

    return BluetoothPermissionResult.denied;
  }

  /// Cek apakah Bluetooth aktif
  static Future<bool> isBluetoothEnabled() async {
    try {
      return await PrintBluetoothThermal.bluetoothEnabled;
    } catch (_) {
      return false;
    }
  }

  /// Cek apakah permission Bluetooth sudah diberikan (tanpa request)
  static Future<bool> isPermissionGranted() async {
    try {
      return await PrintBluetoothThermal.isPermissionBluetoothGranted;
    } catch (_) {
      return false;
    }
  }

  /// Ambil daftar Bluetooth yang sudah dipasangkan
  static Future<List<BluetoothInfo>> getPairedDevices() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (_) {
      return [];
    }
  }

  /// Cek status koneksi printer
  static Future<bool> isConnected() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> connect(
    String macAddress, {
    int maxAttempts = 3,
    Duration initialDelay = const Duration(milliseconds: 600),
    Duration timeout = const Duration(seconds: 8),
  }) async {
    try {
      final alreadyConnected = await PrintBluetoothThermal.connectionStatus;
      if (alreadyConnected) {
        await disconnect();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (_) {}

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final result = await PrintBluetoothThermal.connect(
          macPrinterAddress: macAddress,
        ).timeout(timeout);

        if (result) return true;

        if (attempt < maxAttempts) {
          await Future.delayed(initialDelay * attempt);
        }
      } catch (_) {
        if (attempt < maxAttempts) {
          await Future.delayed(initialDelay * attempt);
        }
      }
    }

    return false;
  }

  static Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (_) {}
  }

  static Future<bool> printTransactionReceipt(
    CetakSimpananData tx, {
    PaperSize paperSize = PaperSize.mm58,
    String? macAddress,
    int maxRetries = 2,
  }) async {
    try {
      final bytes = await _buildReceiptBytes(tx, paperSize: paperSize);
      return await _printWithRetry(
        bytes: bytes,
        macAddress: macAddress,
        maxRetries: maxRetries,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _printWithRetry({
    required List<int> bytes,
    String? macAddress,
    int maxRetries = 2,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final connected = await isConnected();
        if (!connected) {
          if (macAddress == null || macAddress.isEmpty) return false;
          final reconnected = await connect(macAddress);
          if (!reconnected) {
            if (attempt < maxRetries) {
              await Future.delayed(const Duration(seconds: 2));
            }
            continue;
          }
        }

        final success = await PrintBluetoothThermal.writeBytes(bytes);
        if (success) return true;
        if (attempt < maxRetries) {
          await Future.delayed(const Duration(seconds: 2));
        }
      } catch (_) {
        if (attempt < maxRetries) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
    return false;
  }

  static Future<List<int>> _buildReceiptBytes(
    CetakSimpananData tx, {
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);
    final List<int> bytes = [];

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // ── Header ──────────────────────────────────────────
    bytes.addAll(generator.reset());
    bytes.addAll(generator.setGlobalFont(PosFontType.fontA));

    // ── Logo ─────────────────────────────────────────────
    try {
      final ByteData logoData = await rootBundle.load(
        'assets/images/logo_polos.png',
      );
      final Uint8List logoRawBytes = logoData.buffer.asUint8List();
      img.Image? logoImage = img.decodeImage(logoRawBytes);
      if (logoImage != null) {
        // Jika PNG punya alpha (transparan), composite di atas background putih
        if (logoImage.numChannels == 4) {
          final bg = img.Image(
            width: logoImage.width,
            height: logoImage.height,
            numChannels: 3,
          );
          img.fill(bg, color: img.ColorRgb8(255, 255, 255));
          logoImage = img.compositeImage(bg, logoImage);
        }
        // Resize dan convert ke grayscale (wajib untuk ESC/POS)
        final resized = img.copyResize(logoImage, width: 150);
        final grayscale = img.grayscale(resized);
        bytes.addAll(generator.imageRaster(grayscale, align: PosAlign.center));
      }
    } catch (e) {
      // ignore logo error, lanjut cetak teks
    }
    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.text(
        'BPR BANGUNARTA',
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size1,
        ),
        linesAfter: 0,
      ),
    );

    bytes.addAll(
      generator.text(
        'Jl. H. Iksan No. 89 Mulyasari, ',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes.addAll(generator.reset());
    bytes.addAll(
      generator.text(
        'Pamanukan',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes.addAll(generator.reset());
    bytes.addAll(
      generator.text(
        'Telepon: (0260) 550500',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes.addAll(generator.reset());
    bytes.addAll(
      generator.text(
        'www.bprbangunarta.co.id',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes.addAll(generator.hr(ch: '-'));

    // ── Tanggal & No. Referensi ──────────────────────────
    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Tanggal',
          width: 4,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: tx.waktu,
          width: 8,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );
    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'No. Referensi',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: tx.kode,
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    bytes.addAll(generator.hr(ch: '-'));

    // ── Nama Nasabah & Nomor Rekening ────────────────────
    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.text(
        tx.namaLengkap,
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );

    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.text(
        tx.nomorRekening,
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );

    bytes.addAll(generator.hr(ch: '-'));

    // ── Header Tabel ─────────────────────────────────────
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Keterangan',
          width: 6,
          styles: const PosStyles(align: PosAlign.left, bold: true),
        ),
        PosColumn(
          text: 'Nominal',
          width: 6,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]),
    );

    bytes.addAll(generator.hr(ch: '-'));

    // ── Jumlah Setoran ───────────────────────────────────
    bytes.addAll(generator.reset());
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Saldo Tabungan',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: formatter.format(tx.saldoAwal),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Jumlah Setoran',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: formatter.format(tx.nominal),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    // ── Biaya Admin ──────────────────────────────────────
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Biaya Admin',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: 'Rp0',
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    bytes.addAll(generator.hr(ch: '-'));
    // ── Saldo Akhir ──────────────────────────────────────

    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'Saldo Akhir',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: formatter.format(tx.saldoAkhir),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    bytes.addAll(generator.hr(ch: '-'));

    // ── Footer ───────────────────────────────────────────
    bytes.addAll(
      generator.text(
        'Apabila terjadi ketidaksesuaian, harap segera menghubungi kami, untuk penyelesaian.',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    bytes.addAll(generator.reset());

    bytes.addAll(
      generator.text(
        'Terima kasih atas perhatian Anda.',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    bytes.addAll(generator.feed(3));

    return bytes;
  }
}
