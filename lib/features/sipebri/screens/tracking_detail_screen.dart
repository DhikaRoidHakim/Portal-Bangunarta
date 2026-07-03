import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

class SipebriTrackingDetailScreen extends StatelessWidget {
  final String name;

  const SipebriTrackingDetailScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'DETAIL TRACKING',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        children: [
          // 1. Info Debitur Card (Header)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'No. Pengajuan: 0035526',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Nominal Pengajuan: Rp. 100.000.000',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 2. Timeline Card Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Proses Permohonan',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 24.h),

                // Stepper Timeline
                _buildTimelineStep(
                  title: 'Verifikasi Data',
                  date: '2023-11-27 00:28:01',
                  status: TimelineStepStatus.completed,
                ),
                _buildTimelineStep(
                  title: 'Proses Survey',
                  date: '2023-11-27 23:40:06',
                  status: TimelineStepStatus.completed,
                ),
                _buildTimelineStep(
                  title: 'Proses Analisa',
                  date: '2023-11-28 21:36:47',
                  status: TimelineStepStatus.completed,
                ),
                _buildTimelineStep(
                  title: 'Keputusan Komite',
                  date: '2023-12-03 20:45:26',
                  status: TimelineStepStatus.completed,
                  extraChild: Container(
                    margin: EdgeInsets.only(top: 8.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'DISETUJUI',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ),
                _buildTimelineStep(
                  title: 'Akad Kredit',
                  date: '2023-12-05 18:46:11',
                  status: TimelineStepStatus.completed,
                ),
                _buildTimelineStep(
                  title: 'Pencairan Dana',
                  date: '-',
                  status: TimelineStepStatus.active,
                ),
                _buildTimelineStep(
                  title: 'Selesai',
                  date: '-',
                  status: TimelineStepStatus.pending,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String date,
    required TimelineStepStatus status,
    Widget? extraChild,
    bool isLast = false,
  }) {
    Color indicatorColor;
    Widget dotWidget;
    Color lineColor = AppTheme.inputBorder;

    // Set colors & widgets based on step status
    switch (status) {
      case TimelineStepStatus.completed:
        indicatorColor = const Color(0xFF4CAF50); // Green
        lineColor = const Color(0xFF4CAF50);
        dotWidget = Container(
          width: 24.r,
          height: 24.r,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: const Color(0xFF4CAF50),
            size: 14.sp,
          ),
        );
        break;
      case TimelineStepStatus.active:
        indicatorColor = AppTheme.secondaryColor; // Blue
        lineColor = AppTheme.inputBorder;
        dotWidget = Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.secondaryColor, width: 2.w),
          ),
          child: Center(
            child: Container(
              width: 8.r,
              height: 8.r,
              decoration: const BoxDecoration(
                color: AppTheme.secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
        break;
      case TimelineStepStatus.pending:
        indicatorColor = AppTheme.textSecondary.withValues(alpha: 0.5);
        dotWidget = Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5.w),
          ),
        );
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Line & Dot
          Column(
            children: [
              dotWidget,
              if (!isLast)
                Expanded(
                  child: Container(width: 2.w, color: lineColor),
                ),
            ],
          ),
          SizedBox(width: 16.w),

          // Right side: Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: status == TimelineStepStatus.active
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: status == TimelineStepStatus.pending
                          ? AppTheme.textSecondary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    date == '-' ? 'Menunggu antrean proses' : date,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  extraChild ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum TimelineStepStatus { completed, active, pending }
