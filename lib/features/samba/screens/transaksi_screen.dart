import 'package:flutter/material.dart';

import 'package:bangunarta_portal/core/theme/theme.dart';

class TransaksiScreen extends StatelessWidget {
  const TransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.inputBorder),
                ),
                child: IconButton(
                  icon: const Icon(Icons.file_download_outlined),
                  color: AppTheme.textSecondary,
                  onPressed: () {},
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
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.inputBorder),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: const TextStyle(
                              color: AppTheme.textLightBlue,
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppTheme.inputBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.inputBorder),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          color: AppTheme.textSecondary,
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildTransactionItem(context, 'Setoran Tab An. NYAI ROKAYAH via SA...', '124,000'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildTransactionItem(context, 'Setoran Tab An. TUNI WIDIAH via SAMBA', '59,000'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildTransactionItem(context, 'Setoran Tab An. KASMINI via SAMBA', '30,000'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildTransactionItem(
                  context,
                  'Setoran Tab An. CARWATI via SAMBA',
                  '59,000',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, String description, String amount, {bool isLast = false}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/samba/transaksi');
      },
      child: Container(
        color: const Color(0xFFFEF7E9), // Light cream/yellowish background match from image
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.inputBorder),
              ),
              child: const Center(
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: '$description\n'),
                    const TextSpan(text: 'sebesar '),
                    TextSpan(
                      text: amount,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary, // Match color but bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
