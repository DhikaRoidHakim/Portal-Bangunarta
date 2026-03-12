import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

Widget buildSearchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(
      color: AppTheme.surfaceWhite,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.inputBorder.withValues(alpha: .5)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.search_rounded, color: AppTheme.textLightBlue),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Cari layanan atau informasi...',
              hintStyle: AppTheme.hintText.copyWith(fontSize: 14),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
      ],
    ),
  );
}
