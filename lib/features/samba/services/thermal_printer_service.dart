import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';
import 'package:intl/intl.dart';

/// Hasil dari permintaan permission Bluetooth
enum BluetoothPermissionResult { granted, denied, permanentlyDenied }

class ThermalPrinterService {
  /// Meminta izin Bluetooth (BLUETOOTH_CONNECT dan BLUETOOTH_SCAN)
  /// Mengembalikan [BluetoothPermissionResult]
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

  /// Sambungkan ke printer berdasarkan MAC address
  static Future<bool> connect(String macAddress) async {
    try {
      return await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
    } catch (_) {
      return false;
    }
  }

  /// Putuskan koneksi printer
  static Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (_) {}
  }

  /// Cetak bukti transaksi
  static Future<bool> printTransactionReceipt(
    TransactionData tx, {
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    try {
      final connected = await isConnected();
      if (!connected) return false;

      final bytes = await _buildReceiptBytes(tx, paperSize: paperSize);
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (_) {
      return false;
    }
  }

  static Future<List<int>> _buildReceiptBytes(
    TransactionData tx, {
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);
    final List<int> bytes = [];

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // ── Header ──────────────────────────────────────────
    bytes.addAll(generator.reset());
    bytes.addAll(generator.setGlobalFont(PosFontType.fontA));

    bytes.addAll(
      generator.text(
        'KOPERASI BANGUNARTA',
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
        'BUKTI TRANSAKSI',
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );

    bytes.addAll(generator.hr(ch: '-'));

    // ── Jenis Transaksi & Nominal ────────────────────────
    bytes.addAll(
      generator.text(
        'Setoran Tunai',
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );

    bytes.addAll(
      generator.text(
        formatter.format(tx.nominal),
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 0,
      ),
    );

    bytes.addAll(
      generator.text(
        tx.status,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 1,
      ),
    );

    bytes.addAll(generator.hr(ch: '-'));

    // ── Informasi Transaksi ──────────────────────────────
    bytes.addAll(
      generator.text(
        'INFORMASI TRANSAKSI',
        styles: PosStyles(bold: true),
        linesAfter: 0,
      ),
    );

    bytes.addAll(_buildRow(generator, 'No. Dokumen', tx.kode));
    bytes.addAll(_buildRow(generator, 'Waktu', tx.waktu));

    bytes.addAll(generator.emptyLines(1));
    bytes.addAll(generator.hr(ch: '-'));

    // ── Data Nasabah ─────────────────────────────────────
    bytes.addAll(
      generator.text(
        'DATA NASABAH',
        styles: PosStyles(bold: true),
        linesAfter: 0,
      ),
    );

    bytes.addAll(_buildRow(generator, 'No. Rekening', tx.nomorRekening));
    bytes.addAll(_buildRow(generator, 'Nama', tx.namaLengkap));

    if (tx.namaPenyetor != null && tx.namaPenyetor!.isNotEmpty) {
      bytes.addAll(_buildRow(generator, 'Penyetor', tx.namaPenyetor!));
    }

    bytes.addAll(generator.emptyLines(1));
    bytes.addAll(generator.hr(ch: '-'));

    // ── Keterangan ───────────────────────────────────────
    bytes.addAll(
      generator.text(
        'KETERANGAN',
        styles: PosStyles(bold: true),
        linesAfter: 0,
      ),
    );

    if (tx.deskripsi.isNotEmpty) {
      bytes.addAll(_buildRow(generator, 'Deskripsi', tx.deskripsi));
    }

    bytes.addAll(_buildRow(generator, 'Kantor', tx.kantorPetugas));
    bytes.addAll(_buildRow(generator, 'Petugas', tx.namaPetugas));

    bytes.addAll(generator.emptyLines(1));
    bytes.addAll(generator.hr(ch: '='));

    // ── Footer ───────────────────────────────────────────
    bytes.addAll(
      generator.text(
        'Terima kasih telah menggunakan',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    bytes.addAll(
      generator.text(
        'layanan kami.',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    bytes.addAll(
      generator.text(
        'Simpan bukti ini dengan baik.',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 1,
      ),
    );

    bytes.addAll(generator.feed(3));

    return bytes;
  }

  /// Helper untuk baris label: value (otomatis wrap jika panjang)
  static List<int> _buildRow(Generator generator, String label, String value) {
    if (value.length <= 16) {
      return generator.row([
        PosColumn(
          text: label,
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: ': $value',
          width: 6,
          styles: const PosStyles(align: PosAlign.left),
        ),
      ]);
    } else {
      final List<int> result = [];
      result.addAll(
        generator.text(
          '$label :',
          styles: const PosStyles(align: PosAlign.left),
          linesAfter: 0,
        ),
      );
      result.addAll(
        generator.text(
          value,
          styles: const PosStyles(align: PosAlign.left),
          linesAfter: 0,
        ),
      );
      return result;
    }
  }
}
