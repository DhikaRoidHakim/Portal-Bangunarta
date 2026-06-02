import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// Widget Floating Action Button untuk navigasi Tugas di tengah
Widget buildSimontokFAB({
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
        currentIndex == 2 ? Icons.assignment : Icons.assignment_outlined,
        size: 26,
      ),
    ),
  );
}

// Widget BottomAppBar dengan notched layout melengkung di tengah
Widget buildSimontokBottomAppBar({
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
          // ---- Kiri: Dashboard & Kelolaan ----
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSimontokNavItem(
                  index: 0,
                  currentIndex: currentIndex,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Dashboard',
                  onTap: () => onTap(0),
                ),
                buildSimontokNavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: 'Kelolaan',
                  onTap: () => onTap(1),
                ),
              ],
            ),
          ),
          // Label Tugas di bawah lengkungan notch
          GestureDetector(
            onTap: () => onTap(2),
            child: SizedBox(
              width: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tugas',
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
          // ---- Kanan: Prospek & Settings ----
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSimontokNavItem(
                  index: 3,
                  currentIndex: currentIndex,
                  icon: Icons.pie_chart_outline,
                  activeIcon: Icons.pie_chart,
                  label: 'Prospek',
                  onTap: () => onTap(3),
                ),
                buildSimontokNavItem(
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

// Helper widget untuk merender item menu navigasi Simontok
Widget buildSimontokNavItem({
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
