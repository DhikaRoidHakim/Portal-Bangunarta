import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'permohonan_kredit_card.dart';
import 'realisasi_card.dart';

class SipebriDashboardBody extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onPermohonanDetailTap;
  final VoidCallback? onRealisasiViewAllTap;

  const SipebriDashboardBody({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onPermohonanDetailTap,
    this.onRealisasiViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: Colors.white, size: 24.sp),
          onPressed: onMenuTap,
        ),
        title: Text(
          'SIPEBRI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // Notification Bell with Red Badge
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                  onPressed: onNotificationTap,
                ),
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 1.5.w,
                      ),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16.w,
                      minHeight: 16.h,
                    ),
                    child: Text(
                      '4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        children: [
          // 1. Permohonan Kredit Card
          PermohonanKreditCard(onDetailTap: onPermohonanDetailTap),

          SizedBox(height: 20.h),

          // 2. Realisasi Card
          RealisasiCard(onViewAllTap: onRealisasiViewAllTap),

          SizedBox(height: 36.h),

          // 3. Footer
          Center(
            child: Column(
              children: [
                Text(
                  'SIPEBRI V1.0',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary.withValues(alpha: 0.8),
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'PT. BPR BANGUNARTA',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary.withValues(alpha: 0.6),
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),

          // Extra space for FAB and BottomBar
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
