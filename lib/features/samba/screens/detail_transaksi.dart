import 'dart:math' show pi;

import 'package:bangunarta_portal/core/utils/global_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/samba/providers/samba_provider.dart';
import 'package:bangunarta_portal/features/samba/widgets/printer_selection_sheet.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';
import 'package:intl/intl.dart';

class DetailTransaksiScreen extends ConsumerWidget {
  final int transactionId;

  const DetailTransaksiScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      detailSimpananTransactionProvider(transactionId),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FA),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: detailAsync.when(
        data: (detail) => _buildContent(context, detail.data),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => _buildErrorState(context, ref, error),
      ),
      bottomNavigationBar: detailAsync.whenOrNull(
        data: (detail) =>
            _buildBottomBar(context, ref, detail.data.id, detail.data.cetak),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransactionData tx) {
    final isPending = tx.status == 'Belum Diotorisasi';
    final isDebit =
        tx.jenisTransaksi.toLowerCase().contains('debit') ||
        tx.jenisTransaksi.toLowerCase().contains('tarik');

    final statusColor = isPending
        ? const Color(0xFFD97706)
        : const Color(0xFF15803D);
    final statusBg = isPending
        ? const Color(0xFFFEF3C7)
        : const Color(0xFFDCFCE7);

    // final formatter = NumberFormat.currency(
    //   locale: 'id_ID',
    //   symbol: 'Rp ',
    //   decimalDigits: 0,
    // );
    // final nominalFormatted = formatter.format(tx.nominal);
    final nominalFormatted = toRupiah(tx.nominal.toString());

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Hero Header ──
          _HeroHeader(
            nominal: nominalFormatted,
            jenisTransaksi: "Setoran Tunai",
            status: tx.status,
            statusColor: statusColor,
            statusBg: statusBg,
            isPending: isPending,
            isDebit: isDebit,
          ),

          // ── Receipt Body ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              children: [
                // Receipt Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Kode & Nomor Rekening
                      _buildSection(
                        title: 'Informasi Transaksi',
                        icon: Icons.receipt_long_rounded,
                        iconColor: AppTheme.primaryColor,
                        children: [
                          _buildInfoRow(
                            label: 'Kode / Dokumen',
                            value: tx.kode,
                            icon: Icons.tag_rounded,
                            onCopy: tx.kode,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            label: 'Jenis Transaksi',
                            value: "Setoran Tunai",
                            icon: Icons.swap_horiz_rounded,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            label: 'Waktu Transaksi',
                            value: tx.waktu,
                            icon: Icons.access_time_rounded,
                          ),
                        ],
                      ),

                      _buildSectionDivider(),

                      // Informasi Nasabah
                      _buildSection(
                        title: 'Data Nasabah',
                        icon: Icons.person_rounded,
                        iconColor: const Color(0xFF6366F1),
                        children: [
                          _buildInfoRow(
                            label: 'Nomor Rekening',
                            value: tx.nomorRekening,
                            icon: Icons.credit_card_rounded,
                            onCopy: tx.nomorRekening,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            label: 'Nama Lengkap',
                            value: tx.namaLengkap,
                            icon: Icons.badge_rounded,
                          ),
                          if (tx.namaPenyetor != null &&
                              tx.namaPenyetor!.isNotEmpty) ...[
                            _buildDivider(),
                            _buildInfoRow(
                              label: 'Nama Penyetor',
                              value: tx.namaPenyetor!,
                              icon: Icons.person_add_alt_1_rounded,
                            ),
                          ],
                        ],
                      ),
                      _buildSectionDivider(),

                      // Keterangan
                      _buildSection(
                        title: 'Keterangan',
                        icon: Icons.notes_rounded,
                        iconColor: const Color(0xFF0EA5E9),
                        children: [
                          _buildInfoRow(
                            label: 'Deskripsi',
                            value: tx.deskripsi.isNotEmpty ? tx.deskripsi : '-',
                            icon: Icons.info_outline_rounded,
                            isMultiLine: true,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            label: 'Kantor Petugas',
                            value: tx.kantorPetugas,
                            icon: Icons.store_mall_directory_rounded,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            label: 'Nama Petugas',
                            value: tx.namaPetugas,
                            icon: Icons.manage_accounts_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    String? onCopy,
    bool isMultiLine = false,
  }) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: isMultiLine
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary.withValues(alpha: 0.8),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onCopy != null)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: onCopy));
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        duration: const Duration(seconds: 2),
                        content: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFDCFCE7),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCFCE7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Color(0xFF16A34A),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Berhasil disalin',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 15,
                      color: AppTheme.primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, thickness: 0.8, color: const Color(0xFFF1F5F9)),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(
          40,
          (i) => Expanded(
            child: Container(
              height: 1.5,
              color: i.isEven ? Colors.transparent : const Color(0xFFE2E8F0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Colors.redAccent,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gagal Memuat Data',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString().replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(
                  detailSimpananTransactionProvider(transactionId),
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
    int txId,
    int cetak,
  ) {
    final isBlocked = cetak >= 2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isBlocked)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Resi telah dicetak 2x, tidak bisa mencetak lagi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: isBlocked
                    ? null
                    : const LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                color: isBlocked ? const Color(0xFFCBD5E1) : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isBlocked
                    ? []
                    : [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isBlocked
                      ? () => _showBlockedSnackbar(context)
                      : () => _showPrinterSheet(context, ref, txId),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isBlocked
                              ? Icons.print_disabled_rounded
                              : Icons.print_rounded,
                          color: isBlocked
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Cetak Bukti Transaksi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isBlocked
                                ? Colors.white.withValues(alpha: 0.7)
                                : Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.print_disabled_rounded,
                color: Color(0xFFDC2626),
                size: 22,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Resi telah dicetak 2x, tidak bisa mencetak lagi',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB91C1C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPrinterSheet(
    BuildContext context,
    WidgetRef ref,
    int txId,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PrinterSelectionSheet(transactionId: txId),
    );

    // Refresh data detail transaksi setelah sheet ditutup
    // agar counter cetak terbaru diambil dari server dan
    // tombol cetak otomatis di-disable jika sudah mencapai batas.
    ref.invalidate(detailSimpananTransactionProvider(transactionId));
  }
}

// ── Hero Header Widget ──────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final String nominal;
  final String jenisTransaksi;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final bool isPending;
  final bool isDebit;

  const _HeroHeader({
    required this.nominal,
    required this.jenisTransaksi,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.isPending,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Background gradient panel
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 52),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, Color(0xFF1565C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Jenis Transaksi chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDebit
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      jenisTransaksi,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Nominal
              Text(
                nominal,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPending
                            ? const Color(0xFFFDE68A)
                            : const Color(0xFF86EFAC),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.95),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        // Curved bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: const Size(double.infinity, 40),
            painter: _CurveClipper(),
          ),
        ),
      ],
    );
  }
}

class _CurveClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF1F5FA);
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.6)
      ..quadraticBezierTo(size.width / 2, 0, size.width, size.height * 0.6)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurveClipper oldDelegate) => false;
}
