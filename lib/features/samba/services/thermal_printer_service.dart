import 'package:bangunarta_portal/models/samba/cetak_simpanan_model.dart';
import 'package:flutter/widgets.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';
import 'package:intl/intl.dart';

enum BluetoothPermissionResult { granted, denied, permanentlyDenied }

class ThermalPrinterService {
  static bool _isConnecting = false;

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

  static Future<bool> isBluetoothEnabled() async {
    try {
      return await PrintBluetoothThermal.bluetoothEnabled;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isPermissionGranted() async {
    try {
      return await PrintBluetoothThermal.isPermissionBluetoothGranted;
    } catch (_) {
      return false;
    }
  }

  static Future<List<BluetoothInfo>> getPairedDevices() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (_) {
      return [];
    }
  }

  static Future<bool> isConnected() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> connect(
    String macAddress, {
    int maxAttempts = 2,
    Duration initialDelay = const Duration(milliseconds: 500),
    Duration timeout = const Duration(seconds: 6),
  }) async {
    if (_isConnecting) {
      return false;
    }
    _isConnecting = true;

    try {
      await disconnect();
      await Future.delayed(const Duration(milliseconds: 250));

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
    } finally {
      _isConnecting = false;
    }
  }

  static Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect.timeout(
        const Duration(seconds: 2),
      );
    } catch (_) {}
  }

  // ── Pengiriman data ─────────────────────────────────────
  //
  // Plugin print_bluetooth_thermal (Android) memproses `writeBytes` di main
  // thread, menulis ke socket secara blocking, dan SELALU menambahkan "\n" di
  // depan setiap pemanggilan. Karena itu satu payload besar membuat UI macet /
  // timeout, sedangkan chunk yang dipotong sembarang menyisipkan "\n" di tengah
  // perintah ESC/POS (posisi `ESC $`, align `ESC a`, data raster `GS v 0`)
  // sehingga teks bergeser dari tengah atau gambar rusak.
  //
  // Solusinya: struk disusun sebagai segmen utuh (satu perintah/baris lengkap),
  // dipaketkan menjadi chunk kecil hanya di batas segmen, lalu "\n" sisipan
  // plugin dinetralkan dengan line spacing 0 di batas chunk.

  /// Ukuran maksimum satu kali kirim. Kecil supaya main thread Android tidak
  /// lama terblokir dan buffer printer murah tidak overflow.
  static const int _maxChunkBytes = 512;

  /// Jeda antar chunk agar printer sempat memproses buffer-nya.
  static const Duration _chunkInterval = Duration(milliseconds: 60);

  /// Batas waktu satu chunk. Jika terlampaui, cetak dianggap gagal.
  static const Duration _chunkTimeout = Duration(seconds: 5);

  /// Jeda setelah chunk terakhir supaya buffer Bluetooth OS benar-benar
  /// terkirim sebelum pemanggil memutus koneksi (penyebab struk terpotong).
  static const Duration _drainDelay = Duration(milliseconds: 800);

  /// ESC 3 0 — line spacing 0, supaya "\n" sisipan plugin tidak menambah baris.
  static const List<int> _lineSpacingZero = [0x1B, 0x33, 0x00];

  /// ESC 2 — kembalikan line spacing default.
  static const List<int> _lineSpacingDefault = [0x1B, 0x32];

  /// Transport pengiriman; dapat diganti di test (plugin memakai jalur
  /// berbeda saat test berjalan di host Windows).
  @visibleForTesting
  static Future<bool> Function(List<int> bytes) bytesWriter =
      PrintBluetoothThermal.writeBytes;

  @visibleForTesting
  static Future<bool> Function() connectionChecker = isConnected;

  static bool _isPrinting = false;
  static Future<CapabilityProfile>? _profileFuture;

  /// Memuat profil printer lebih awal (di-cache) supaya saat cetak
  /// tidak perlu menunggu parsing aset.
  static Future<void> warmUp() async {
    try {
      await _getProfile();
    } catch (e) {
      // Akan dimuat ulang saat cetak.
      debugPrint('[ThermalPrinter] warm up gagal: $e');
    }
  }

  /// Mengirim resi ke printer yang sudah tersambung.
  ///
  /// Koneksi dikelola oleh pemanggil supaya kegagalan write tidak memicu
  /// proses connect ulang yang panjang. Pemanggil juga bertanggung jawab
  /// memanggil [disconnect] setelah proses selesai.
  ///
  /// Tidak ada retry otomatis: chunk yang timeout bisa saja tetap tercetak,
  /// sehingga mengirim ulang berisiko menghasilkan struk ganda.
  static Future<bool> printTransactionReceipt(
    CetakSimpananData tx, {
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    if (_isPrinting) return false;
    _isPrinting = true;

    try {
      final segments = await _buildReceiptSegments(tx, paperSize: paperSize);
      return await _writeChunks(packChunks(segments));
    } catch (e, stack) {
      debugPrint('[ThermalPrinter] print error: $e\n$stack');
      return false;
    } finally {
      _isPrinting = false;
    }
  }

  /// Menggabungkan segmen menjadi chunk ≤ [_maxChunkBytes] tanpa pernah
  /// memotong satu segmen.
  @visibleForTesting
  static List<List<int>> packChunks(
    List<List<int>> segments, {
    int maxChunkBytes = _maxChunkBytes,
  }) {
    final chunks = <List<int>>[];
    var current = <int>[];

    for (final segment in segments) {
      if (current.isNotEmpty &&
          current.length + segment.length > maxChunkBytes) {
        chunks.add(current);
        current = <int>[];
      }
      current.addAll(segment);
    }
    if (current.isNotEmpty) chunks.add(current);

    final lastIndex = chunks.length - 1;
    return [
      for (var i = 0; i <= lastIndex; i++)
        [
          if (i > 0) ..._lineSpacingDefault,
          ...chunks[i],
          if (i < lastIndex) ..._lineSpacingZero,
        ],
    ];
  }

  static Future<bool> _writeChunks(List<List<int>> chunks) async {
    if (!await connectionChecker()) return false;

    for (var i = 0; i < chunks.length; i++) {
      bool success;
      try {
        success = await bytesWriter(
          chunks[i],
        ).timeout(_chunkTimeout, onTimeout: () => false);
      } catch (_) {
        success = false;
      }

      if (!success) {
        debugPrint(
          '[ThermalPrinter] gagal mengirim chunk ${i + 1}/${chunks.length}',
        );
        return false;
      }

      if (i < chunks.length - 1) await Future.delayed(_chunkInterval);
    }

    await Future.delayed(_drainDelay);
    return true;
  }

  static Future<CapabilityProfile> _getProfile() {
    return _profileFuture ??= CapabilityProfile.load().catchError((Object e) {
      _profileFuture = null;
      throw e;
    });
  }

  /// Menyusun struk sebagai daftar segmen. Setiap segmen adalah perintah
  /// ESC/POS utuh yang berakhir di batas baris, sehingga aman menjadi batas
  /// chunk. Hanya segmen inisialisasi yang tidak diakhiri baris baru, dan ia
  /// selalu berada di awal chunk pertama.
  static Future<List<List<int>>> _buildReceiptSegments(
    CetakSimpananData tx, {
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await _getProfile();
    final generator = Generator(paperSize, profile);
    final List<List<int>> segments = [];

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // ── Header ──────────────────────────────────────────
    // Reset (ESC @) cukup sekali di awal. Generator melacak style aktif
    // sehingga align/bold/ukuran dikirim ulang hanya saat berubah.
    segments.add([
      ...generator.reset(),
      ...generator.setGlobalFont(PosFontType.fontA),
    ]);

    segments.add(
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

    segments.add(
      generator.text(
        'Jl. H. Iksan No. 89 Mulyasari, ',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    segments.add(
      generator.text(
        'Pamanukan',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    segments.add(
      generator.text(
        'Telepon: (0260) 550500',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    segments.add(
      generator.text(
        'www.bprbangunarta.co.id',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    segments.add(generator.hr(ch: '-'));

    segments.add(
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

    segments.add(
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

    segments.add(generator.hr(ch: '-'));

    // ── Nama Nasabah & Nomor Rekening ────────────────────

    segments.add(
      generator.text(
        tx.namaLengkap,
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );

    segments.add(
      generator.text(
        tx.nomorRekening,
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );

    segments.add(generator.hr(ch: '-'));

    // ── Header Tabel ─────────────────────────────────────
    segments.add(
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

    segments.add(generator.hr(ch: '-'));

    // ── Jumlah Setoran ───────────────────────────────────
    segments.add(
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

    segments.add(
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
    segments.add(
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

    segments.add(generator.hr(ch: '-'));

    // ── Saldo Akhir ──────────────────────────────────────
    segments.add(
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

    segments.add(generator.hr(ch: '-'));

    // ── Footer ───────────────────────────────────────────
    segments.add(
      generator.text(
        'Apabila terjadi ketidaksesuaian, harap segera menghubungi kami, untuk penyelesaian.',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    segments.add(
      generator.text(
        'Terima kasih atas perhatian Anda.',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    segments.add(generator.feed(3));

    return segments;
  }
}

/// Observer untuk memastikan koneksi printer dilepas saat app
/// masuk background atau ditutup, supaya socket tidak "nyangkut"
/// dan mengganggu sesi print berikutnya.
///
/// Cara pakai — daftarkan di initState halaman yang membuka koneksi printer:
///
/// ```dart
/// late final PrinterLifecycleObserver _printerObserver;
///
/// @override
/// void initState() {
///   super.initState();
///   _printerObserver = PrinterLifecycleObserver();
///   WidgetsBinding.instance.addObserver(_printerObserver);
/// }
///
/// @override
/// void dispose() {
///   WidgetsBinding.instance.removeObserver(_printerObserver);
///   ThermalPrinterService.disconnect();
///   super.dispose();
/// }
/// ```
class PrinterLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ThermalPrinterService.disconnect();
    }
  }
}
