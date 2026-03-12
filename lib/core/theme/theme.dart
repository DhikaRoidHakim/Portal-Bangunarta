import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors (Berbasis Mockup)
  static const Color primaryColor = Color(0xFF092966); // Biru tua/dongker untuk logo, tombol, judul
  static const Color secondaryColor = Color(0xFF1976D2); // Biru standar
  
  // Background & Surface Colors
  static const Color backgroundLight = Color(0xFFF7F8FB); // Abu-abu sangat muda untuk background
  static const Color surfaceWhite = Colors.white; // Background card/input form
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0A2240); // Hitam kebiruan untuk judul "Super App"
  static const Color textSecondary = Color(0xFF8A98A8); // Abu-abu kebiruan untuk subtitle
  static const Color textLink = Color(0xFF5E718B); // Abu-abu sedang untuk label username/password
  static const Color textLightBlue = Color(0xFF94A3B8); // Abu-abu muda untuk placeholder & hint
  static const Color textWhite = Colors.white;

  // Form Colors
  static const Color inputBorder = Color(0xFFE2E8F0); // Outline input text field
  static const Color inputFocusBorder = primaryColor; // Outline saat aktif
  static const Color iconColor = Color(0xFF94A3B8); // Warna icon di textfield

  // Teks Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle subtitleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: textLink,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: textWhite,
  );
  
  static const TextStyle outlinedButtonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle footerLink = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textLightBlue,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textLightBlue,
  );

  // Splash Screen existing
  static const TextStyle splashTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    letterSpacing: 2.0,
  );

  static const TextStyle versionText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    letterSpacing: 1.2,
  );
}
