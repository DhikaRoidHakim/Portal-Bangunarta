import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

Widget buildMenuCard({
  required String title,
  required String iconPath,
  required Color color,
  VoidCallback? onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppTheme.surfaceWhite,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: .08),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        splashColor: color.withValues(alpha: .1),
        highlightColor: color.withValues(alpha: .05),
        onTap: onTap,
        child: Stack(
          children: [
            // Motif Latar (Hiasan Lingkaran) di pojok kanan bawah
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: .04),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SvgPicture.asset(
                      iconPath,
                      width: 26,
                      height: 26,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
