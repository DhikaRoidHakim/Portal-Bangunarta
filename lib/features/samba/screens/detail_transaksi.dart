import 'package:flutter/material.dart';

import 'package:bangunarta_portal/core/theme/theme.dart';

class DetailTransaksiScreen extends StatelessWidget {
  const DetailTransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false, // Menghilangkan back button bawaan
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
      body: SingleChildScrollView(
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
                      'Transaksi',
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
                    label: 'Rekening',
                    initialValue: '1.100.2.2',
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    label: 'Name Lengkap',
                    initialValue: 'NANA SUMARNA',
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    label: 'Alamat Lengkap',
                    initialValue:
                        "DUSUN PARMASARI RT 03 RW 10\nPAMANUKAN PAMANUKAN SUBANG",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: AppTheme.inputBorder,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'DEPOSIT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: AppTheme.inputBorder,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _buildLabeledTextField(
                    label: 'Saldo Sebelumnya',
                    initialValue: '20,000',
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    label: 'Jumlah Setoran',
                    initialValue: '23,000',
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    label: 'Saldo Akhir',
                    initialValue: '43,000',
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    label: 'Dokumen',
                    initialValue: 'SMB661-RH4U3X',
                  ),
                  const SizedBox(height: 16),
                  _buildLabeledTextField(
                    label: 'Waktu',
                    initialValue: '2026-03-13 13:12:48',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          boxShadow: [
            BoxShadow(
              color: AppTheme.textPrimary.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006CE3), // A vibrant blue
              foregroundColor: AppTheme.surfaceWhite,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.print_outlined, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Cetak',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50), // Standard dark text
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
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
              vertical: maxLines > 1 ? 14 : 12, // Tighter vertical padding
            ),
            filled: true,
            fillColor: AppTheme.surfaceWhite,
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
