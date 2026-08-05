import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/widgets/skeleton_loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigmaBerandaSkeleton extends StatelessWidget {
  const SigmaBerandaSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 100.w, height: 12.h),
                    SizedBox(height: 8.h),
                    SkeletonLine(width: 180.w, height: 22.h),
                  ],
                ),
                SkeletonBox(width: 44.w, height: 44.h, borderRadius: 22.r),
              ],
            ),
            SizedBox(height: 20.h),

            // Stat Cards Row 1
            Row(
              children: [
                Expanded(child: _StatCardSkeleton()),
                SizedBox(width: 14.w),
                Expanded(child: _StatCardSkeleton()),
              ],
            ),
            SizedBox(height: 14.h),

            // Stat Cards Row 2
            Row(
              children: [
                Expanded(child: _StatCardSkeleton()),
                SizedBox(width: 14.w),
                Expanded(child: _StatCardSkeleton()),
              ],
            ),
            SizedBox(height: 24.h),

            // Section Header
            SkeletonLine(width: 140.w, height: 18.h),
            SizedBox(height: 14.h),

            // Asset Cards List Skeleton
            const _AssetCardSkeleton(),
            SizedBox(height: 12.h),
            const _AssetCardSkeleton(),
            SizedBox(height: 12.h),
            const _AssetCardSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _StatCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 36.w, height: 36.h, borderRadius: 10.r),
          SizedBox(height: 12.h),
          SkeletonLine(width: 70.w, height: 12.h),
          SizedBox(height: 6.h),
          SkeletonLine(width: 90.w, height: 20.h),
        ],
      ),
    );
  }
}

class _AssetCardSkeleton extends StatelessWidget {
  const _AssetCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SkeletonBox(width: 48.w, height: 48.h, borderRadius: 12.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 140.w, height: 16.h),
                SizedBox(height: 6.h),
                SkeletonLine(width: 100.w, height: 12.h),
                SizedBox(height: 8.h),
                SkeletonLine(width: 160.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
