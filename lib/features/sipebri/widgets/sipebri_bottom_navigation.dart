import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// Widget Floating Action Button untuk navigasi Survey RSC di tengah
Widget buildSipebriFAB({
  required int currentIndex,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: 64,
    height: 64,
    child: FloatingActionButton(
      onPressed: onTap,
      backgroundColor: currentIndex == 2
          ? AppTheme.secondaryColor
          : AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: currentIndex == 2 ? 8 : 4,
      shape: const CircleBorder(),
      child: Icon(
        currentIndex == 2 ? Icons.pie_chart : Icons.pie_chart_outline,
        size: 26,
      ),
    ),
  );
}

// Widget BottomAppBar dengan notched layout melengkung di tengah
Widget buildSipebriBottomAppBar({
  required int currentIndex,
  required Function(int) onTap,
}) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8.0,
    color: AppTheme.surfaceWhite,
    elevation: 12,
    shadowColor: AppTheme.textPrimary.withValues(alpha: 0.15),
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ---- Kiri: Home & Survey ----
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSipebriNavItem(
                  index: 0,
                  currentIndex: currentIndex,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  onTap: () => onTap(0),
                ),
                buildSipebriNavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.donut_large_outlined,
                  activeIcon: Icons.donut_large,
                  label: 'Survey',
                  onTap: () => onTap(1),
                ),
              ],
            ),
          ),
          // Label Survey RSC di bawah lengkungan notch
          GestureDetector(
            onTap: () => onTap(2),
            child: SizedBox(
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Survey RSC',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: currentIndex == 2
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: currentIndex == 2
                          ? AppTheme.secondaryColor
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          // ---- Kanan: Tracking & Setting ----
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSipebriNavItem(
                  index: 3,
                  currentIndex: currentIndex,
                  icon: Icons.inbox_outlined,
                  activeIcon: Icons.inbox,
                  label: 'Tracking',
                  onTap: () => onTap(3),
                ),
                buildSipebriNavItem(
                  index: 4,
                  currentIndex: currentIndex,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Setting',
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

// Helper widget untuk merender item menu navigasi Sipebri
Widget buildSipebriNavItem({
  required int index,
  required int currentIndex,
  required IconData icon,
  required IconData activeIcon,
  required String label,
  required VoidCallback onTap,
}) {
  final isSelected = currentIndex == index;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    splashColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
    highlightColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected
                ? AppTheme.secondaryColor
                : AppTheme.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppTheme.secondaryColor
                  : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
