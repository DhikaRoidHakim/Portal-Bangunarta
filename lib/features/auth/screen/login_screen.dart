import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/shell/screens/dashboard.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  // ganti jadi menggunakan gambar
                  child: Image.asset(
                    "assets/images/logo_polos.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Judul Utama
              const Text(
                'Bangunarta One',
                style: AppTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Silahkan login ke dalam aplikasi',
                style: AppTheme.subtitleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Form Username
              const Text('Username', style: AppTheme.inputLabel),
              const SizedBox(height: 8),
              _buildTextField(hint: 'E-123456', icon: Icons.badge_outlined),
              const SizedBox(height: 24),

              // Form Password
              const Text('Password', style: AppTheme.inputLabel),
              const SizedBox(height: 8),
              _buildTextField(
                hint: '........',
                icon: Icons.lock_outline,
                isPassword: true,
                obscureText: _obscurePassword,
                onTogglePassword: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Remember Me Custom Checkbox
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: AppTheme.inputBorder),
                      activeColor: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textLink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Tombol Masuk
              ElevatedButton(
                onPressed: () {
                  // TODO: Ganti dengan routing package yang digunakan (seperti GoRouter) jika diperlukan.
                  // Sementara menggunakan Navigator native untuk langsung ke halaman dashboard.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('Masuk', style: AppTheme.buttonText),
              ),
              const SizedBox(height: 24),

              // Divider Atau Lanjutkan Dengan
              Row(
                children: [
                  const Expanded(child: Divider(color: AppTheme.inputBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Atau Lanjutkan Dengan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textLightBlue,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppTheme.inputBorder)),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Login Biometrik
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.fingerprint, color: AppTheme.textLink),
                label: const Text(
                  'Login Biometrik',
                  style: AppTheme.outlinedButtonText,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.surfaceWhite,
                  side: const BorderSide(color: AppTheme.inputBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 48),

              // IT Helpdesk
              Center(
                child: Column(
                  children: [
                    Text(
                      'Mengalami Masalah pada aplikasi?',
                      style: AppTheme.subtitleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hubungi IT Helpdesk',
                      style: AppTheme.subtitleMedium.copyWith(
                        color: AppTheme.textLink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Footer Version & Privacy
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('v1.0.0', style: AppTheme.footerLink),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('•', style: AppTheme.footerLink),
                  ),
                  const Text('Privacy Policy', style: AppTheme.footerLink),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('•', style: AppTheme.footerLink),
                  ),
                  const Text('Terms of Service', style: AppTheme.footerLink),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.inputBorder),
      ),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTheme.hintText,
          prefixIcon: Icon(icon, color: AppTheme.iconColor, size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.iconColor,
                    size: 22,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
