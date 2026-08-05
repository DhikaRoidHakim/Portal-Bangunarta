import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/models/sigma/list_assets_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigmaAssetCard extends StatelessWidget {
  final AssetsModel asset;
  final VoidCallback? onTap;

  const SigmaAssetCard({
    super.key,
    required this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRepair = asset.inRepair;
    final statusColor = isRepair ? const Color(0xFFDC3545) : const Color(0xFF28A745);
    final statusBgColor = statusColor.withValues(alpha: 0.1);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.inputBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Code & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF28A745).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        asset.kodeAset,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF28A745),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusColor,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            isRepair ? 'Perbaikan' : 'Aktif',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Asset Name
                Text(
                  asset.namaAset,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),

                // Office & Room
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        '${asset.currentOfficeName} • ${asset.currentRoomName}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(height: 1.h, color: AppTheme.inputBorder.withValues(alpha: 0.5)),
                SizedBox(height: 10.h),

                // Bottom Row: Stats & Last Moved
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.sync_alt_rounded,
                          label: '${asset.totalMoves}x pindah',
                        ),
                        SizedBox(width: 8.w),
                        _buildInfoChip(
                          icon: Icons.build_outlined,
                          label: '${asset.totalRepairs}x perbaikan',
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.textSecondary,
                      size: 20.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppTheme.textSecondary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
