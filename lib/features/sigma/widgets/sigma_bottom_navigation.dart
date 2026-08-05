import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildSigmaFAB({
  required int currentIndex,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: 64.w,
    height: 64.h,
    child: FloatingActionButton(
      onPressed: onTap,
      backgroundColor: currentIndex == 2
          ? AppTheme.secondaryColor
          : const Color(0xFF28A745),
      foregroundColor: Colors.white,
      elevation: currentIndex == 2 ? 8 : 4,
      shape: const CircleBorder(),
      child: Icon(
        currentIndex == 2 ? Icons.qr_code_scanner : Icons.qr_code_scanner_outlined,
        size: 26.sp,
      ),
    ),
  );
}

Widget buildSigmaBottomAppBar({
  required int currentIndex,
  required Function(int) onTap,
}) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8.0.r,
    color: AppTheme.surfaceWhite,
    elevation: 12,
    shadowColor: AppTheme.textPrimary.withValues(alpha: 0.15),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Beranda & Aset
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSigmaNavItem(
                  index: 0,
                  currentIndex: currentIndex,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Beranda',
                  onTap: () => onTap(0),
                ),
                _buildSigmaNavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.inventory_2_outlined,
                  activeIcon: Icons.inventory_2,
                  label: 'Daftar Aset',
                  onTap: () => onTap(1),
                ),
              ],
            ),
          ),
          // Center: Scan QR Label
          GestureDetector(
            onTap: () => onTap(2),
            child: SizedBox(
              width: 70.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Scan QR',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: currentIndex == 2
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: currentIndex == 2
                          ? AppTheme.secondaryColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          // Right: Maintenance & Pengaturan
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSigmaNavItem(
                  index: 3,
                  currentIndex: currentIndex,
                  icon: Icons.build_circle_outlined,
                  activeIcon: Icons.build_circle,
                  label: 'Perbaikan',
                  onTap: () => onTap(3),
                ),
                _buildSigmaNavItem(
                  index: 4,
                  currentIndex: currentIndex,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Pengaturan',
                  onTap: () => onTap(4),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSigmaNavItem({
  required int index,
  required int currentIndex,
  required IconData icon,
  required IconData activeIcon,
  required String label,
  required VoidCallback onTap,
}) {
  final isSelected = currentIndex == index;
  final color = isSelected ? const Color(0xFF28A745) : AppTheme.textSecondary;

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isSelected ? activeIcon : icon,
          color: color,
          size: 22.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    ),
  );
}
