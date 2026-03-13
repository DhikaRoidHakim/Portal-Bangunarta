import 'package:flutter/material.dart';

import 'package:bangunarta_portal/core/theme/theme.dart';

class RekeningScreen extends StatelessWidget {
  const RekeningScreen({super.key});

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
                    'Rekening',
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
                _buildRekeningItem(context, 'A YOMA AMANDA PUTRI', '01.101.015905'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildRekeningItem(context, 'ABDUL GHANI', '01.101.016162'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildRekeningItem(context, 'ADI KUSTANDI', '01.101.016566'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildRekeningItem(context, 'AGUS NURDIN', '01.101.016032'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildRekeningItem(context, 'AISAH', '01.101.015891'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildRekeningItem(context, 'ALI BAKRI', '01.101.015996'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildRekeningItem(context, 'ANIFA', '01.101.016277'),
                const Divider(
                  color: AppTheme.inputBorder,
                  height: 1,
                  thickness: 1,
                ),
                _buildRekeningItem(
                  context,
                  'ARDIANSAH BURHANNUDIN',
                  '01.101.015820',
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

  Widget _buildRekeningItem(BuildContext context, String name, String number, {bool isLast = false}) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/samba/rekening');
      },
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
                Icons.person_outline,
                color: AppTheme.textSecondary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
