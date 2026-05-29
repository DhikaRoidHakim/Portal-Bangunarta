import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/auth/auth_repository.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/shell/widgets/floatingnav_widget.dart';
import 'package:bangunarta_portal/models/auth/auth_me_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

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
    _loadBiometricSetting();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final employee = authState.user?.employee;

    Widget bodyWidget;

    if (authState.status == AuthStatus.loading) {
      bodyWidget = const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    } else if (employee == null) {
      bodyWidget = _buildErrorState();
    } else {
      bodyWidget = RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: _refreshProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            children: [
              _buildHeader(employee),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildChangePasswordButton(),
                    const SizedBox(height: 16),
                    _buildBiometricSettingTile(),
                    const SizedBox(height: 16),
                    _buildLogoutButton(),
                    const SizedBox(height: 16),
                    _buildInfoSection(
                      title: 'Informasi Personal',
                      children: [
                        _buildInfoTile(
                          Icons.badge_outlined,
                          'Nomor Karyawan',
                          employee.nomorKaryawan,
                        ),
                        _buildInfoTile(
                          Icons.credit_card_outlined,
                          'Nomor KTP',
                          employee.nomorKtp,
                        ),
                        _buildInfoTile(
                          Icons.person_outline_rounded,
                          'Jenis Kelamin',
                          employee.jenisKelamin,
                        ),
                        _buildInfoTile(
                          Icons.cake_outlined,
                          'Tempat, Tanggal Lahir',
                          _joinValues([
                            employee.tempatLahir,
                            employee.tanggalLahir,
                          ]),
                        ),
                        _buildInfoTile(
                          Icons.family_restroom_outlined,
                          'Status Perkawinan',
                          employee.statusPerkawinan,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoSection(
                      title: 'Kontak & Alamat',
                      children: [
                        _buildInfoTile(
                          Icons.home_outlined,
                          'Alamat',
                          employee.alamatLengkap,
                        ),
                        _buildInfoTile(
                          Icons.markunread_mailbox_outlined,
                          'Kode Pos',
                          employee.kodePos,
                        ),
                        _buildInfoTile(
                          Icons.phone_android_outlined,
                          'Nomor Handphone',
                          employee.nomorHandphone,
                        ),
                        _buildInfoTile(
                          Icons.chat_outlined,
                          'Nomor WhatsApp',
                          employee.nomorWhatsapp,
                        ),
                        _buildInfoTile(
                          Icons.email_outlined,
                          'Email',
                          employee.alamatEmail,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoSection(
                      title: 'Informasi Pekerjaan',
                      children: [
                        _buildInfoTile(
                          Icons.work_outline_rounded,
                          'Jabatan',
                          employee.jabatan,
                        ),
                        _buildInfoTile(
                          Icons.business_outlined,
                          'Kantor',
                          employee.kantor,
                        ),
                        _buildInfoTile(
                          Icons.verified_user_outlined,
                          'Status Bekerja',
                          employee.statusBekerja,
                        ),
                        _buildInfoTile(
                          Icons.event_available_outlined,
                          'Tanggal Bekerja',
                          employee.tanggalBekerja,
                        ),
                        _buildInfoTile(
                          Icons.swap_horiz_rounded,
                          'Tanggal Mutasi',
                          employee.tanggalMutasi,
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
      bottomNavigationBar: FloatingNavWidget(currentIndex: 3, onTap: _onNavTap),
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
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ganti Password',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ubah password akun Anda',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                  size: 26,
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.fingerprint_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login Biometrik',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Aktifkan login menggunakan sidik jari atau wajah',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Keluar dari akun Anda',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _isLoggingOut
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.redAccent,
                        ),
                      )
                    : const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.textSecondary,
                        size: 26,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(EmployeeModel employee) {
    final name = _displayValue(employee.namaLengkap, fallback: 'User');
    final job = _displayValue(employee.jabatan, fallback: 'Pegawai');

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
            child: const CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_rounded,
                color: AppTheme.primaryColor,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            job,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
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

  Future<void> _refreshProfile() async {
    await ref.read(authProvider.notifier).checkAuth();
  }

  Future<void> _loadBiometricSetting() async {
    final isEnabled = await AuthRepository.instance.isBiometricEnabled();

    if (!mounted) return;

    setState(() {
      _isBiometricEnabled = isEnabled;
    });
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
        );

        if (!didAuthenticate) return;
      }

      await AuthRepository.instance.setBiometricEnabled(value);

      if (!mounted) return;

      setState(() {
        _isBiometricEnabled = value;
      });

      _showMessage(
        value
            ? 'Login biometrik berhasil diaktifkan'
            : 'Login biometrik dimatikan',
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage('Gagal mengubah pengaturan biometrik');
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

  String _joinValues(List<String?> values) {
    final validValues = values
        .map((value) => value?.trim())
        .where((value) => value != null && value.isNotEmpty)
        .cast<String>()
        .toList();

    if (validValues.isEmpty) return '-';

    return validValues.join(', ');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
