import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:bangunarta_portal/core/services/core_services.dart';
import 'package:bangunarta_portal/models/samba/list_simpanan_model.dart';

class ExportKelolaanService {
  final PdfReportService _reportService = PdfReportService();
  final PdfStorageService _storageService = PdfStorageService();

  Future<Uint8List> generatePdfKelolaan(List<SimpananModel> simpanan) {
    return _reportService.generateTablePdf(
      reportTitle: "Laporan Daftar Kelolaan samba",
      summaryText: "Total Transaksi ${simpanan.length}",
      headers: ["No", "Nama Lengkap", "Nomor CIF", "Nomor Rekening"],
      rows: List<List<String>>.generate(simpanan.length, (index) {
        final item = simpanan[index];
        return [
          (index + 1).toString(),
          item.namaLengkap,
          item.nomorCif,
          item.nomorRekening,
        ];
      }),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.centerLeft,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(40),
        1: const pw.FixedColumnWidth(160),
        2: const pw.FixedColumnWidth(100),
        3: const pw.FixedColumnWidth(140),
      },
    );
  }

  Future<bool> savePdfToDownloads(
    BuildContext context,
    Uint8List pdfBytes,
    String fileName,
  ) {
    return _storageService.saveToDownloads(
      context: context,
      bytes: pdfBytes,
      fileName: fileName,
    );
  }
}
