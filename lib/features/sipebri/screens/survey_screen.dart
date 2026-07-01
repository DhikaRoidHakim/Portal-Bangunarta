import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

class SipebriSurveyScreen extends StatelessWidget {
  final bool showBackButton;

  const SipebriSurveyScreen({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: showBackButton,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'SURVEY SIPEBRU',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pie_chart_outline_rounded,
                color: AppTheme.primaryColor,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Halaman Survey',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur survey aplikasi Sipebri.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
