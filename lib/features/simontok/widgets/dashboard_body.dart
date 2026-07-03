import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Dashboard Widget utama Simontok
Widget buildDashboardWidget({
  required int currentIndex,
  required String namaPengguna,
  required String role,
  required Function(int) onTap,
}) {
  return Stack(
    children: [
      // Primary Background Header
      Container(
        height: 220.h,
        width: double.infinity,
        color: AppTheme.primaryColor,
      ),
      SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          children: [
            // Top Custom App Bar
            Center(
              child: Text(
                'SIMONTOK Mobile',
                style: const TextStyle(
                  color: AppTheme.textWhite,
                ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30.h),

            // Main Profile Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: .05),
                    blurRadius: 20.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang.',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            // Text(
                            //   role,
                            //   style: TextStyle(
                            //     color: AppTheme.textPrimary,
                            //     fontSize: 14.sp,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            SizedBox(height: 4.h),
                            Text(
                              namaPengguna,
                              style: TextStyle(
                                color: AppTheme.secondaryColor,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_outline,
                            color: AppTheme.primaryColor,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Grid Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Kelolaan Debitur',
                    '0',
                    AppTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard('Surat Tugas', '0', Colors.pink),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Prospek Kredit', '0', Colors.blue),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard('Verifikasi Kredit', '0', Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://img.freepik.com/free-vector/customer-support-illustration_23-2148889374.jpg',
                  ), // Generic placeholder for the bottom vector
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  opacity: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Action Item Widget internal
Widget buildActionItem({
  required IconData icon,
  required String title,
  required Color color,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 55.w,
          height: 55.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.surfaceWhite, size: 28),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

// Status Card Widget internal
Widget _buildStatCard(String title, String value, Color valueColor) {
  return Container(
    padding: EdgeInsets.all(20.r),
    decoration: BoxDecoration(
      color: AppTheme.surfaceWhite,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
