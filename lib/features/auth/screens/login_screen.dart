import 'dart:io';

import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/auth/auth_repository.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isBiometricLoginVisible = false;

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadBiometricLoginVisibility();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),

              // Logo
              Center(
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: .2),
                        blurRadius: 16.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/logo_polos.png",
                    width: 40.w,
                    height: 40.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Judul Utama
              Text(
                'Bangunarta One',
                style: AppTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Silahkan login ke dalam aplikasi',
                style: AppTheme.subtitleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),

              // Form Username
              Text('Username', style: AppTheme.inputLabel),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _usernameController,
                hint: 'Nomor Induk Karyawan',
                icon: Icons.badge_outlined,
              ),
              SizedBox(height: 24.h),

              // Form Password
              Text('Password', style: AppTheme.inputLabel),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _passwordController,
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
              SizedBox(height: 16.h),
              Center(
                child: Column(
                  children: [
                    Text(
                      ApiEndpoints.baseUrl ==
                              'https://codex.bprbangunarta.co.id'
                          ? 'Server: Main'
                          : 'Server: Backup',
                      style: AppTheme.versionText,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
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

              // Tombol Masuk & Tombol Biometrik Berdampingan
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('Masuk', style: AppTheme.buttonText),
                    ),
                  ),
                  if (_isBiometricLoginVisible) ...[
                    const SizedBox(width: 12),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isLoading ? null : _loginWithBiometric,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height:
                              56, // Menyesuaikan tinggi ElevatedButton dengan padding vertical 16
                          width: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceWhite,
                            border: Border.all(color: AppTheme.inputBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
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

              // Footer Version
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('v1.0.0 BETA', style: AppTheme.footerLink),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  //   child: Text('•', style: AppTheme.footerLink),
                  // ),
                  // const Text('Privacy Policy', style: AppTheme.footerLink),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  //   child: Text('•', style: AppTheme.footerLink),
                  // ),
                  // const Text('Terms of Service', style: AppTheme.footerLink),
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
    required TextEditingController controller,
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
        controller: controller,
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

  Future<void> _loadBiometricLoginVisibility() async {
    final isEnabled = await AuthRepository.instance.isBiometricEnabled();

    if (!mounted) return;

    setState(() {
      _isBiometricLoginVisible = isEnabled;
    });
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Username dan password wajib diisi');
      return;
    }

    try {
      final deviceInfo = await _getDeviceLoginInfo();

      await ref
          .read(authProvider.notifier)
          .login(
            username: username,
            password: password,
            deviceIdentifier: deviceInfo.identifier,
            deviceName: deviceInfo.name,
            deviceOs: deviceInfo.os,
            fmcToken: '',
          );

      // Simpan kredensial secara aman untuk login biometrik mendatang
      await AuthRepository.instance.saveCredentials(username, password);

      if (!mounted) return;

      context.go('/dashboard');
    } catch (error) {
      if (!mounted) return;

      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _loginWithBiometric() async {
    try {
      final canAuthenticate =
          await _localAuthentication.canCheckBiometrics ||
          await _localAuthentication.isDeviceSupported();

      if (!canAuthenticate) {
        _showMessage('Biometrik tidak tersedia di perangkat ini');
        return;
      }

      final didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: 'Gunakan biometrik untuk masuk ke Bangunarta One',
        biometricOnly: true,
      );

      if (!didAuthenticate || !mounted) return;

      // Coba verifikasi token lokal terlebih dahulu jika masih aktif
      final token = await AuthRepository.instance.getAccessToken();
      if (token != null && token.isNotEmpty) {
        await ref.read(authProvider.notifier).checkAuth();
        if (!mounted) return;

        final authState = ref.read(authProvider);
        if (authState.status == AuthStatus.authenticated) {
          context.go('/dashboard');
          return;
        }
      }

      // Jika token tidak ada atau tidak valid, lakukan login menggunakan kredensial tersimpan
      final credentials = await AuthRepository.instance.getCredentials();
      if (credentials == null) {
        _showMessage(
          'Sesi biometrik kedaluwarsa. Silakan masuk menggunakan password.',
        );
        return;
      }

      final username = credentials['username']!;
      final password = credentials['password']!;
      final deviceInfo = await _getDeviceLoginInfo();

      await ref
          .read(authProvider.notifier)
          .login(
            username: username,
            password: password,
            deviceIdentifier: deviceInfo.identifier,
            deviceName: deviceInfo.name,
            deviceOs: deviceInfo.os,
            fmcToken: '',
          );

      if (!mounted) return;

      context.go('/dashboard');
    } on LocalAuthException catch (error) {
      if (!mounted) return;
      _showMessage('Otentikasi biometrik gagal: ${error.description}');
    } catch (error) {
      if (!mounted) return;

      _showMessage('Autentikasi biometrik gagal: $error');
    }
  }

  Future<_DeviceLoginInfo> _getDeviceLoginInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;

      return _DeviceLoginInfo(
        identifier: androidInfo.id,
        name: '${androidInfo.manufacturer} ${androidInfo.model}'.trim(),
        os: 'ANDROID ${androidInfo.version.release}',
      );
    }

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;

      return _DeviceLoginInfo(
        identifier: iosInfo.identifierForVendor ?? iosInfo.name,
        name: iosInfo.name,
        os: 'IOS ${iosInfo.systemVersion}',
      );
    }

    return _DeviceLoginInfo(
      identifier: Platform.localHostname,
      name: Platform.localHostname,
      os: Platform.operatingSystem.toUpperCase(),
    );
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final Color backgroundColor = isError
        ? const Color(0xFFFDF2F2)
        : const Color(0xFFF0FDF4);
    final Color borderColor = isError
        ? const Color(0xFFFDE8E8)
        : const Color(0xFFDCFCE7);
    final Color textColor = isError
        ? const Color(0xFF9B1C1C)
        : const Color(0xFF15803D);
    final Color iconColor = isError
        ? const Color(0xFFE02424)
        : const Color(0xFF16A34A);
    final IconData icon = isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_outline_rounded;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color:
                    (isError
                            ? const Color(0xFF9B1C1C)
                            : const Color(0xFF15803D))
                        .withValues(alpha: 0.08),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isError
                      ? const Color(0xFFFDE8E8)
                      : const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isError ? 'Terjadi Kesalahan' : 'Pemberitahuan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textColor.withValues(alpha: 0.85),
                        height: 1.3,
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
}

class _DeviceLoginInfo {
  const _DeviceLoginInfo({
    required this.identifier,
    required this.name,
    required this.os,
  });

  final String identifier;
  final String name;
  final String os;
}
