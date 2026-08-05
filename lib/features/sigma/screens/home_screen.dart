import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/auth/settings_screen.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/sigma/providers/sigma_provider.dart';
import 'package:bangunarta_portal/features/sigma/screens/asset_list_screen.dart';
import 'package:bangunarta_portal/features/sigma/widgets/sigma_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigmaHomeScreen extends ConsumerStatefulWidget {
  const SigmaHomeScreen({super.key});

  @override
  ConsumerState<SigmaHomeScreen> createState() => _SigmaHomeScreenState();
}

class _SigmaHomeScreenState extends ConsumerState<SigmaHomeScreen> {
  int _currentIndex = 0;

  void _showFeatureNotAvailableDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.construction_outlined,
                  color: const Color(0xFF28A745),
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text('Tutup', style: TextStyle(fontSize: 14.sp)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user?.user;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20.sp),
            //   onPressed: () => context.go('/dashboard'),
            //   constraints: const BoxConstraints(),
            //   padding: EdgeInsets.only(right: 8.w),
            // ),
            Image.asset(
              'assets/images/logo_polos.png',
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BPR BANGUNARTA',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'SIGMA • Management Assets',
                  style: TextStyle(
                    color: const Color(0xFF28A745),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF28A745).withValues(alpha: 0.08),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_none_rounded, size: 22.sp),
              color: const Color(0xFF28A745),
              onPressed: () {
                _showFeatureNotAvailableDialog(
                  'Notifikasi SIGMA',
                  'Fitur notifikasi pemeliharaan dan pengingat aset akan segera hadir.',
                );
              },
              constraints: BoxConstraints(minWidth: 38.w, minHeight: 38.h),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0.h),
          child: Container(color: AppTheme.inputBorder, height: 1.0.h),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildBerandaBody(user?.name ?? 'User', user?.role ?? 'Karyawan'),
          const SigmaAssetListScreen(),
          const SizedBox.shrink(), // Center FAB screen placeholder
          const SigmaAssetListScreen(initialInRepairOnly: true),
          const SettingsPage(),
        ],
      ),
      floatingActionButton: buildSigmaFAB(
        currentIndex: _currentIndex,
        onTap: () {
          context.push('/sigma/scan-qr');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildSigmaBottomAppBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            context.push('/sigma/scan-qr');
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBerandaBody(String userName, String userRole) {
    final assetsAsync = ref.watch(sigmaAssetsNotifierProvider);

    return RefreshIndicator(
      color: const Color(0xFF28A745),
      onRefresh: () => ref.read(sigmaAssetsNotifierProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting Header Card
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF28A745), Color(0xFF1E7E34)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF28A745).withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Sistem Manajemen & Pelacakan Aset',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Statistics Grid Section Header
            Text(
              'Ringkasan Aset',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            // Async Assets Statistics Cards
            assetsAsync.when(
              data: (state) {
                final totalAssets = state.items.length;
                final activeAssets = state.items
                    .where((e) => !e.inRepair)
                    .length;
                final inRepairAssets = state.items
                    .where((e) => e.inRepair)
                    .length;
                final totalMoves = state.items.fold<int>(
                  0,
                  (sum, item) => sum + item.totalMoves,
                );

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Total Aset',
                            value: '$totalAssets Unit',
                            icon: Icons.inventory_2_rounded,
                            iconColor: const Color(0xFF28A745),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Kondisi Aktif',
                            value: '$activeAssets Unit',
                            icon: Icons.check_circle_rounded,
                            iconColor: const Color(0xFF0D6EFD),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Perlu Perbaikan',
                            value: '$inRepairAssets Unit',
                            icon: Icons.build_circle_rounded,
                            iconColor: const Color(0xFFDC3545),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Riwayat Mutasi',
                            value: '$totalMoves Kali',
                            icon: Icons.alt_route_rounded,
                            iconColor: const Color(0xFFFFC107),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Aset',
                          value: '...',
                          icon: Icons.inventory_2_rounded,
                          iconColor: const Color(0xFF28A745),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Kondisi Aktif',
                          value: '...',
                          icon: Icons.check_circle_rounded,
                          iconColor: const Color(0xFF0D6EFD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              error: (_, _) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Aset',
                          value: '0 Unit',
                          icon: Icons.inventory_2_rounded,
                          iconColor: const Color(0xFF28A745),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Perlu Perbaikan',
                          value: '0 Unit',
                          icon: Icons.build_circle_rounded,
                          iconColor: const Color(0xFFDC3545),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Quick Menu Actions Grid
            Text(
              'Menu Utama',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickMenuItem(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan QR',
                  color: const Color(0xFF28A745),
                  onTap: () {
                    context.push('/sigma/scan-qr');
                  },
                ),
                _buildQuickMenuItem(
                  icon: Icons.format_list_bulleted_rounded,
                  label: 'Daftar Aset',
                  color: const Color(0xFF0D6EFD),
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                ),
                _buildQuickMenuItem(
                  icon: Icons.build_rounded,
                  label: 'Perbaikan',
                  color: const Color(0xFFDC3545),
                  onTap: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                ),
                _buildQuickMenuItem(
                  icon: Icons.history_rounded,
                  label: 'Riwayat',
                  color: const Color(0xFFFFC107),
                  onTap: () {
                    _showFeatureNotAvailableDialog(
                      'Riwayat Mutasi Aset',
                      'Fitur riwayat pemindahan dan log pemeliharaan lengkap akan segera hadir.',
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Recent Assets List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aset Terbaru',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF28A745),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Recent Assets List
            assetsAsync.when(
              data: (state) {
                if (state.items.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        'Belum ada data aset',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                // Show first 4 items as recent assets
                final recentItems = state.items.take(4).toList();

                return Column(
                  children: recentItems.map((item) {
                    return SigmaAssetCard(
                      asset: item,
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                    );
                  }).toList(),
                );
              },
              loading: () => const SigmaBerandaSkeleton(),
              error: (err, _) => Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    'Gagal memuat daftar aset terbaru',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.inputBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 26.sp),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
