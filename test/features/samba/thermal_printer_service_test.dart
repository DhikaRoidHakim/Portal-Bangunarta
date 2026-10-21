import 'package:bangunarta_portal/features/samba/services/thermal_printer_service.dart';
import 'package:bangunarta_portal/models/samba/cetak_simpanan_model.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter_test/flutter_test.dart';

const _tx = CetakSimpananData(
  id: 1,
  kode: 'TRX-001',
  nomorRekening: '102.03.0045',
  namaLengkap: 'BUDI SANTOSO',
  nominal: 50000,
  saldoAwal: 100000,
  saldoAkhir: 150000,
  deskripsi: 'Setoran',
  status: 'sukses',
  cetak: 0,
  kantorPetugas: 'Pusat',
  namaPetugas: 'Kolektor',
  jenisTransaksi: 'setor',
  waktu: '21-10-2026 10:00',
);

const _spacingZero = [0x1B, 0x33, 0x00];
const _spacingDefault = [0x1B, 0x32];

List<int> _strip(List<int> chunk, {required bool first, required bool last}) {
  var body = chunk;
  if (!first) {
    expect(body.sublist(0, 2), _spacingDefault);
    body = body.sublist(2);
  }
  if (!last) {
    expect(body.sublist(body.length - 3), _spacingZero);
    body = body.sublist(0, body.length - 3);
  }
  return body;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThermalPrinterService.packChunks', () {
    test('satu chunk tanpa penanda line spacing bila muat', () {
      final chunks = ThermalPrinterService.packChunks([
        [1, 2, 10],
        [3, 10],
      ], maxChunkBytes: 10);

      expect(chunks, [
        [1, 2, 10, 3, 10],
      ]);
    });

    test('tidak pernah memotong segmen dan urutan byte tetap', () {
      final segments = [for (var i = 0; i < 20; i++) List<int>.filled(7, i)];

      final chunks = ThermalPrinterService.packChunks(
        segments,
        maxChunkBytes: 16,
      );

      expect(chunks.length, greaterThan(1));
      final bodies = [
        for (var i = 0; i < chunks.length; i++)
          _strip(chunks[i], first: i == 0, last: i == chunks.length - 1),
      ];

      for (final body in bodies) {
        expect(body.length, lessThanOrEqualTo(16));
        expect(body.length % 7, 0, reason: 'segmen terpotong');
      }
      expect(bodies.expand((b) => b).toList(), segments.expand((s) => s));
    });

    test('segmen lebih besar dari batas tetap dikirim utuh', () {
      final big = List<int>.filled(40, 9);
      final chunks = ThermalPrinterService.packChunks([
        [1],
        big,
        [2],
      ], maxChunkBytes: 16);

      expect(chunks.length, 3);
      expect(_strip(chunks[1], first: false, last: false), big);
    });
  });

  group('ThermalPrinterService.printTransactionReceipt', () {
    final writes = <List<int>>[];
    var connected = true;
    var failOnWrite = 0;

    setUp(() {
      writes.clear();
      connected = true;
      failOnWrite = 0;
      ThermalPrinterService.connectionChecker = () async => connected;
      ThermalPrinterService.bytesWriter = (bytes) async {
        writes.add(bytes);
        return writes.length != failOnWrite;
      };
    });

    tearDown(() {
      ThermalPrinterService.connectionChecker =
          ThermalPrinterService.isConnected;
      ThermalPrinterService.bytesWriter = PrintBluetoothThermal.writeBytes;
    });

    test('mengirim struk utuh dalam beberapa chunk kecil', () async {
      final ok = await ThermalPrinterService.printTransactionReceipt(_tx);

      expect(ok, isTrue);
      expect(writes.length, greaterThan(1));
      for (final chunk in writes) {
        expect(chunk.length, lessThanOrEqualTo(512 + 5));
      }
      final text = String.fromCharCodes(writes.expand((c) => c));
      expect(text, contains('BPR BANGUNARTA'));
      expect(text, contains('BUDI SANTOSO'));
      expect(text, contains('Terima kasih atas perhatian Anda.'));
    });

    test(
      'gagal tanpa mengirim apa pun bila printer tidak tersambung',
      () async {
        connected = false;

        expect(
          await ThermalPrinterService.printTransactionReceipt(_tx),
          isFalse,
        );
        expect(writes, isEmpty);
      },
    );

    test('berhenti dan gagal bila satu chunk gagal terkirim', () async {
      failOnWrite = 2;

      expect(await ThermalPrinterService.printTransactionReceipt(_tx), isFalse);
      expect(writes.length, 2);
    });
  });
}
