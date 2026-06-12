import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/samba/providers/samba_provider.dart';
import 'package:bangunarta_portal/features/samba/widgets/samba_skeletons.dart';

Widget buildStatCard({
  required String title,
  required String value,
  required IconData icon,
  required Color iconBackgroundColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    decoration: BoxDecoration(
      color: AppTheme.surfaceWhite,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppTheme.textPrimary.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: iconBackgroundColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.surfaceWhite, size: 24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildBerandaBody() {
  return Consumer(
    builder: (context, ref, child) {
      final simpananState = ref.watch(sambaSimpananNotifierProvider);
      final transaksiState = ref.watch(sambaTransaksiNotifierProvider);

      // Show skeleton while data is loading
      final isLoading = simpananState.isLoading || transaksiState.isLoading;
      if (isLoading && !simpananState.hasValue && !transaksiState.hasValue) {
        return const BerandaSkeleton();
      }

      final dateString = DateTime.now().toString().split(' ')[0];

      final accountsCount = simpananState.maybeWhen(
        data: (s) => s.total.toString(),
        orElse: () => '0',
      );

      final totalTxCount = transaksiState.maybeWhen(
        data: (t) => t.items.length.toString(),
        orElse: () => '0',
      );

      final successTxCount = transaksiState.maybeWhen(
        data: (t) => t.items
            .where((item) => item.status != 'Belum Diotorisasi')
            .length
            .toString(),
        orElse: () => '0',
      );

      final pendingTxCount = transaksiState.maybeWhen(
        data: (t) => t.items
            .where((item) => item.status == 'Belum Diotorisasi')
            .length
            .toString(),
        orElse: () => '0',
      );

      final latestTx = transaksiState.maybeWhen(
        data: (t) => t.items.isNotEmpty ? t.items.first : null,
        orElse: () => null,
      );

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
                      'DASHBOARD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Saving Mobile App',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.surfaceWhite,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateString,
                        style: const TextStyle(
                          color: AppTheme.surfaceWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    title: 'Account',
                    value: accountsCount,
                    icon: Icons.people_outline,
                    iconBackgroundColor: const Color(0xFF7F8C9D), // grey
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStatCard(
                    title: 'Transaction',
                    value: totalTxCount,
                    icon: Icons.receipt_long_outlined,
                    iconBackgroundColor: AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    title: 'Success',
                    value: successTxCount,
                    icon: Icons.check_circle_outline,
                    iconBackgroundColor: const Color(0xFF28A745), // green
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStatCard(
                    title: 'Pending',
                    value: pendingTxCount,
                    icon: Icons.schedule_outlined,
                    iconBackgroundColor: const Color(0xFFF59E0B), // orange
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                  const Text(
                    'Transaksi Terakhir',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (latestTx != null) ...[
                    Builder(
                      builder: (context) {
                        final isPending =
                            latestTx.status == 'Belum Diotorisasi';
                        return InkWell(
                          onTap: () {
                            context.push(
                              '/samba/transaksi',
                              extra: latestTx.id,
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: isPending
                                        ? const Color(0xFFFEF3C7)
                                        : const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.receipt_long_outlined,
                                      color: isPending
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF15803D),
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        latestTx.deskripsi,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'sebesar Rp ${latestTx.nominal}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        latestTx.waktu,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textLightBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppTheme.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(
                              alpha: 0.06,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.receipt_long_outlined,
                              color: AppTheme.primaryColor,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Mohon maaf',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tidak ditemukan data yang cocok.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
