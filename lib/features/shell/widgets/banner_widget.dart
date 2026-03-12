import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/utils/dashboard_util.dart';

Widget buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColor, width: 2),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: AppTheme.subtitleMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Dhika Ganteng',
                style: AppTheme.titleLarge.copyWith(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppTheme.textPrimary,
            size: 24,
          ),
          onPressed: () {},
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(12),
        ),
      ),
    ],
  );
}
