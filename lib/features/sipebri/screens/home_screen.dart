import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/auth/settings_screen.dart';
import 'package:bangunarta_portal/features/sipebri/screens/survey_screen.dart';
import 'package:bangunarta_portal/features/sipebri/screens/survey_rsc_screen.dart';
import 'package:bangunarta_portal/features/sipebri/screens/tracking_screen.dart';
import 'package:bangunarta_portal/features/sipebri/widgets/sipebri_widgets.dart';

class SipebriHomeScreen extends ConsumerStatefulWidget {
  const SipebriHomeScreen({super.key});

  @override
  ConsumerState<SipebriHomeScreen> createState() => _SipebriHomeScreenState();
}

class _SipebriHomeScreenState extends ConsumerState<SipebriHomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user?.user;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundLight,
      drawer: Drawer(
        backgroundColor: AppTheme.backgroundLight,
        child: Column(
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primaryColor),
              currentAccountPicture: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user?.name != null && user!.name!.isNotEmpty
                        ? user.name![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              accountName: Text(
                user?.name ?? 'User',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                user?.role ?? 'Karyawan',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),

            // Drawer Items
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: AppTheme.primaryColor,
              ),
              title: const Text(
                'Kembali ke Portal',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.go('/dashboard');
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: AppTheme.secondaryColor,
              ),
              title: const Text(
                'Tentang Sipebri',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: const Text('Sistem Permohonan Kredit V1.0'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),

            const Spacer(),

            // Logout di bagian bawah drawer
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Index 0: Dashboard Body
          SipebriDashboardBody(
            onMenuTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            onNotificationTap: () {
              context.push('/dashboard/notifications');
            },
            onPermohonanDetailTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menuju halaman detail permohonan kredit...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            onRealisasiViewAllTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menuju halaman semua data realisasi...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),

          // Index 1: Survey Screen
          SipebriSurveyScreen(
            showBackButton: false,
            onMenuTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),

          // Index 2: Survey RSC Screen (FAB Page)
          SipebriSurveyRscScreen(
            showBackButton: false,
            onMenuTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),

          // Index 3: Tracking Screen
          SipebriTrackingScreen(
            showBackButton: false,
            onMenuTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),

          // Index 4: Settings Screen
          const SettingsPage(),
        ],
      ),

      floatingActionButton: buildSipebriFAB(
        currentIndex: _currentIndex,
        onTap: () {
          setState(() {
            _currentIndex = 2; // Survey RSC
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: buildSipebriBottomAppBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Tentang SIPEBRI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        content: const Text(
          'SIPEBRI (Sistem Permohonan Kredit) adalah modul aplikasi internal BPR Bangunarta untuk mendokumentasikan, menganalisis, dan memantau setiap pengajuan kredit debitur secara real-time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF4444),
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keluar dari Akun?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda akan keluar dari aplikasi dan perlu login kembali.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
