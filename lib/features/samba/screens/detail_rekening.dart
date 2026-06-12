import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/samba/providers/samba_provider.dart';
import 'package:bangunarta_portal/models/samba/detail_simpanan_model.dart';

class DetailRekeningScreen extends ConsumerWidget {
  final String nomorRekening;

  const DetailRekeningScreen({super.key, required this.nomorRekening});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(detailSimpananProvider(nomorRekening));

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/logo_polos.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text(
              'BPR BANGUNARTA',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              color: AppTheme.primaryColor,
              onPressed: () {},
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppTheme.inputBorder, height: 1.0),
        ),
      ),
      body: detailAsync.when(
        data: (detail) {
          final data = detail.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DATA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Detail Rekening',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.inputBorder),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppTheme.textSecondary,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabeledTextField(
                        label: 'Nomor CIF',
                        initialValue: data.nomorCif,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Nomor Rekening',
                        initialValue: data.nomorRekening,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Nama Lengkap',
                        initialValue: data.namaLengkap,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Produk Simpanan',
                        initialValue: data.produkSimpanan,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Alamat KTP',
                        initialValue: data.alamatKtp,
                        maxLines: 3,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Nomor HP',
                        initialValue: data.nomorHp ?? '-',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Tujuan Pembukaan',
                        initialValue: data.tujuanPembukaan ?? '-',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Nama Ahli Waris',
                        initialValue: data.namaAhliWaris ?? '-',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Status Ahli Waris',
                        initialValue: data.statusAhliWaris ?? '-',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Kontak Ahli Waris',
                        initialValue: data.kontakAhliWaris ?? '-',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledTextField(
                        label: 'Nama Kolektor',
                        initialValue: data.namaKolektor,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(detailSimpananProvider(nomorRekening));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    String? initialValue,
    String? hintText,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          readOnly: readOnly,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF334155),
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines > 1 ? 14 : 12,
            ),
            filled: true,
            fillColor: readOnly
                ? const Color(0xFFF8FAFC)
                : AppTheme.surfaceWhite,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.inputBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF006CE3),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
