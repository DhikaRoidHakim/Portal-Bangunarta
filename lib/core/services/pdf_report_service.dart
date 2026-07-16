import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

class PdfReportService {
  Future<Uint8List> generateTablePdf({
    required String reportTitle,
    required List<String> headers,
    required List<List<String>> rows,
    String? summaryText,
    Map<int, pw.TableColumnWidth>? columnWidths,
    Map<int, pw.Alignment>? cellAlignments,
    String fontAssetPath = "assets/fonts/Roboto-Regular.ttf",
    String logoAssetPath = "assets/images/logo_polos.png",
    String companyName = "PT BPR BANGUNARTA",
    String appName = "Bangunarta One",
  }) async {
    final fontData = await rootBundle.load(fontAssetPath);
    final ttf = pw.Font.ttf(fontData);

    final logoData = await rootBundle.load(logoAssetPath);
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final pdf = pw.Document(theme: pw.ThemeData.withFont(base: ttf));

    final primaryColor = PdfColor.fromHex('#092966');
    final secondaryColor = PdfColor.fromHex('#1976D2');
    final greyColor = PdfColor.fromHex('#F7F8FB');
    final textSecondaryColor = PdfColor.fromHex('#8A98A8');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => [
          _buildHeader(
            logoImage: logoImage,
            reportTitle: reportTitle,
            companyName: companyName,
            appName: appName,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            textSecondaryColor: textSecondaryColor,
          ),
          pw.SizedBox(height: 8),
          pw.Divider(thickness: 1.5, color: primaryColor),
          pw.SizedBox(height: 15),
          if (summaryText != null) ...[
            pw.Text(
              summaryText,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
            pw.SizedBox(height: 10),
          ],
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: rows,
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
            headerDecoration: pw.BoxDecoration(color: primaryColor),
            cellPadding: const pw.EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 4,
            ),
            cellStyle: const pw.TextStyle(fontSize: 8),
            oddRowDecoration: pw.BoxDecoration(color: greyColor),
            cellAlignments: cellAlignments ?? const {},
            columnWidths: columnWidths ?? const {},
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 15),
          child: pw.Text(
            "Halaman ${context.pageNumber} dari ${context.pagesCount}",
            style: pw.TextStyle(fontSize: 8, color: textSecondaryColor),
          ),
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader({
    required pw.MemoryImage logoImage,
    required String reportTitle,
    required String companyName,
    required String appName,
    required PdfColor primaryColor,
    required PdfColor secondaryColor,
    required PdfColor textSecondaryColor,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(logoImage, width: 45, height: 45),
            pw.SizedBox(width: 12),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  companyName,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                pw.Text(
                  appName,
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                pw.Text(
                  reportTitle,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              "TANGGAL CETAK",
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: textSecondaryColor,
              ),
            ),
            pw.Text(
              DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
              style: pw.TextStyle(fontSize: 10, color: primaryColor),
            ),
          ],
        ),
      ],
    );
  }
}
