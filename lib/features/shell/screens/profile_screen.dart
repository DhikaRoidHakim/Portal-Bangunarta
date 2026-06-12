import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/auth/auth_repository.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/shell/widgets/floatingnav_widget.dart';
import 'package:bangunarta_portal/models/auth/auth_me_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:bangunarta_portal/core/utils/profile_util.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isBiometricEnabled = false;
  bool _isUpdatingBiometric = false;
  bool _isLoggingOut = false;

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    loadBiometricSetting(context, (isEnabled) {
      setState(() {
        _isBiometricEnabled = isEnabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user?.user;

    Widget bodyWidget;

    if (authState.status == AuthStatus.loading ||
        authState.status == AuthStatus.unauthenticated ||
        authState.status == AuthStatus.initial) {
      bodyWidget = const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    } else if (user == null || authState.status == AuthStatus.error) {
      bodyWidget = _buildErrorState();
    } else {
      bodyWidget = RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: () => refreshProfile(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            children: [
              _buildHeader(user),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildChangePasswordButton(),
                    SizedBox(height: 16.h),
                    _buildBiometricSettingTile(),
                    SizedBox(height: 16.h),
                    _buildLogoutButton(),
                    SizedBox(height: 16.h),
                    _buildInfoSection(
                      title: 'Informasi Personal',
                      children: [
                        _buildInfoTile(
                          Icons.badge_outlined,
                          'Username / NIP',
                          user.username,
                        ),
                        _buildInfoTile(
                          Icons.person_outline_rounded,
                          'Nama Lengkap',
                          user.name,
                        ),
                        _buildInfoTile(
                          Icons.alternate_email_rounded,
                          'Alias',
                          user.alias,
                        ),
                        _buildInfoTile(
                          Icons.email_outlined,
                          'Email',
                          user.email,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoSection(
                      title: 'Informasi Pekerjaan',
                      children: [
                        _buildInfoTile(
                          Icons.work_outline_rounded,
                          'Jabatan',
                          user.role,
                        ),
                        _buildInfoTile(
                          Icons.business_outlined,
                          'Kantor',
                          user.office,
                        ),
                        _buildInfoTile(
                          Icons.code_rounded,
                          'Kode MSO',
                          user.msoCode,
                        ),
                        _buildInfoTile(
                          Icons.qr_code_rounded,
                          'Kode Collector',
                          user.collectorCode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: bodyWidget,
      bottomNavigationBar: FloatingNavWidget(currentIndex: 1, onTap: _onNavTap),
    );
  }

  Widget _buildChangePasswordButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    color: AppTheme.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ganti Password',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Ubah password akun Anda',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                  size: 26.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricSettingTile() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.fingerprint_rounded,
                color: AppTheme.primaryColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login Biometrik',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Aktifkan login menggunakan sidik jari atau wajah',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isBiometricEnabled,
              activeThumbColor: AppTheme.primaryColor,
              onChanged: _isUpdatingBiometric ? null : _toggleBiometric,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoggingOut ? null : _showLogoutConfirmation,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Keluar dari akun Anda',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _isLoggingOut
                    ? SizedBox(
                        width: 22.w,
                        height: 22.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.redAccent,
                        ),
                      )
                    : Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.textSecondary,
                        size: 26.sp,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel user) {
    final name = _displayValue(user.name, fallback: 'User');
    final job = _displayValue(user.role, fallback: 'Pegawai');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF19428F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_rounded,
                color: AppTheme.primaryColor,
                size: 48.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            job,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _displayValue(value),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppTheme.primaryColor,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat profil',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tarik ke bawah atau tekan tombol di bawah untuk mencoba lagi.',
              textAlign: TextAlign.center,
              style: AppTheme.subtitleMedium,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).checkAuth();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Muat Ulang'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    setState(() {
      _isUpdatingBiometric = true;
    });

    try {
      if (value) {
        final canAuthenticate =
            await _localAuthentication.canCheckBiometrics ||
            await _localAuthentication.isDeviceSupported();

        if (!canAuthenticate) {
          _showMessage('Biometrik tidak tersedia di perangkat ini');
          return;
        }

        final didAuthenticate = await _localAuthentication.authenticate(
          localizedReason: 'Aktifkan login biometrik untuk Bangunarta One',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );

        if (!didAuthenticate) return;
      }

      await AuthRepository.instance.setBiometricEnabled(value);
      if (!value) {
        await AuthRepository.instance.clearCredentials();
      }

      if (!mounted) return;

      setState(() {
        _isBiometricEnabled = value;
      });

      _showMessage(
        value
            ? 'Login biometrik berhasil diaktifkan'
            : 'Login biometrik dimatikan',
      );
    } on LocalAuthException catch (error) {
      if (!mounted) return;
      if (error.code == LocalAuthExceptionCode.noCredentialsSet) {
        _showMessage('Gagal: Kunci layar (PIN/Pola/Password) belum diatur di perangkat. Silakan atur terlebih dahulu di Settings.');
      } else if (error.code == LocalAuthExceptionCode.noBiometricsEnrolled) {
        _showMessage('Gagal: Sidik jari belum terdaftar di perangkat. Silakan daftarkan sidik jari Anda di Settings.');
      } else {
        _showMessage('Gagal mengubah pengaturan biometrik: ${error.description}');
      }
    } catch (error) {
      if (!mounted) return;

      _showMessage('Gagal mengubah pengaturan biometrik: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingBiometric = false;
        });
      }
    }
  }

  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Konfirmasi Logout',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => context.pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _logout();
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await ref.read(authProvider.notifier).logout();

      if (!mounted) return;

      context.pushReplacement('/login');
    } catch (_) {
      if (!mounted) return;

      _showMessage('Gagal logout');
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _onNavTap(int index) {
    if (index == 0) {
      context.go('/dashboard');
      return;
    }

    if (index == 2) {
      context.go('/news');
    }
  }

  String _displayValue(String? value, {String fallback = '-'}) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return fallback;
    }

    return trimmedValue;
  }



  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
