import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/samba/providers/samba_provider.dart';
import 'package:bangunarta_portal/features/samba/widgets/samba_skeletons.dart';
import 'package:bangunarta_portal/core/utils/global_util.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// String _toRupiah(String value) {
//   final number = num.tryParse(value) ?? 0;
//   return NumberFormat.currency(
//     locale: 'id_ID',
//     symbol: 'Rp ',
//     decimalDigits: 0,
//   ).format(number);
// }

Widget buildStatCard({
  required String title,
  required String value,
  required IconData icon,
  required Color iconBackgroundColor,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    decoration: BoxDecoration(
      color: AppTheme.surfaceWhite,
      borderRadius: BorderRadius.circular(16.r),
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
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: iconBackgroundColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.surfaceWhite, size: 24.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
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
        data: (t) => t.summary.isNotEmpty
            ? toRupiah(t.summary.first.success)
            : toRupiah('0'),
        orElse: () => toRupiah('0'),
      );

      final pendingTxCount = transaksiState.maybeWhen(
        data: (t) => t.summary.isNotEmpty
            ? toRupiah(t.summary.first.pending)
            : toRupiah('0'),
        orElse: () => toRupiah('0'),
      );

      final latestTx = transaksiState.maybeWhen(
        data: (t) => t.items.isNotEmpty ? t.items.first : null,
        orElse: () => null,
      );

      return SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
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
                    Text(
                      'DASHBOARD',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Saving Mobile App',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(10.r),
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
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.surfaceWhite,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        dateString,
                        style: TextStyle(
                          color: AppTheme.surfaceWhite,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
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
                SizedBox(width: 16.w),
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
            SizedBox(height: 16.h),
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
                SizedBox(width: 16.w),
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
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaksi Terakhir',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 24.h),
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
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 56.w,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    color: isPending
                                        ? const Color(0xFFFEF3C7)
                                        : const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.receipt_long_outlined,
                                      color: isPending
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF15803D),
                                      size: 28.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        latestTx.deskripsi,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'sebesar Rp ${latestTx.nominal}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        latestTx.waktu,
                                        style: TextStyle(
                                          fontSize: 12.sp,
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
                          width: 56.w,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(
                              alpha: 0.06,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.receipt_long_outlined,
                              color: AppTheme.primaryColor,
                              size: 28.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mohon maaf',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Tidak ditemukan data yang cocok.',
                                style: TextStyle(
                                  fontSize: 14.sp,
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
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
