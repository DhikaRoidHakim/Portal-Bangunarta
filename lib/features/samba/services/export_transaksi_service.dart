import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:bangunarta_portal/core/services/core_services.dart';
import 'package:bangunarta_portal/models/samba/list_transaksi_model.dart';
import 'package:bangunarta_portal/core/utils/global_util.dart';

class ExportTransaksiService {
  final PdfReportService _reportService = PdfReportService();
  final PdfStorageService _storageService = PdfStorageService();

  Future<Uint8List> generatePdf(List<SambaTransactionModel> transaksiList) {
    return _reportService.generateTablePdf(
      reportTitle: "Laporan Daftar Transaksi Samba",
      summaryText: "Total Transaksi: ${transaksiList.length}",
      headers: [
        "No.",
        "Nomor Transaksi",
        "No. Rekening",
        "Nama",
        "Jumlah",
        "Deskripsi",
        "Status",
      ],
      rows: List<List<String>>.generate(transaksiList.length, (index) {
        final item = transaksiList[index];
        return [
          (index + 1).toString(),
          item.kode,
          item.nomorRekening,
          item.namaLengkap,
          toRupiah(item.nominal.toString()),
          item.deskripsi,
          item.status,
        ];
      }),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerLeft,
        6: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FixedColumnWidth(85),
        2: const pw.FixedColumnWidth(80),
        3: const pw.FixedColumnWidth(110),
        4: const pw.FixedColumnWidth(80),
        5: const pw.FixedColumnWidth(90),
        6: const pw.FixedColumnWidth(55),
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
