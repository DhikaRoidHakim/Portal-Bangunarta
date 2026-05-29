import 'dart:ui';

import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/utils/dashboard_util.dart';
import 'package:bangunarta_portal/features/shell/widgets/floatingnav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Mengatur status bar style untuk header yang gelap
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final name = user?.employee.namaLengkap?.trim();
    final loggedInName = name == null || name.isEmpty ? 'User' : name;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        child: Stack(
          children: [
            // Background Header with Gradient & Pattern yang sekarang ikut terscroll
            _buildBackgroundHeader(),

            // Main Content
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildHeaderRow(loggedInName),
                  const SizedBox(height: 24),
                  // Search Bar inside Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildSearchBar(),
                  ),
                  const SizedBox(height: 24),

                  // Floating User Summary Card
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  //   child: _buildSummaryCard(),
                  // ),
                  // const SizedBox(height: 32),

                  // Layanan Kami
                  _buildSectionTitle(
                    'Layanan Kami',
                    'Lihat Semua',
                    AppTheme.textWhite,
                    AppTheme.textWhite,
                    () {},
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildServicesGrid(),
                  ),

                  const SizedBox(height: 32),

                  // Informasi Terkini
                  _buildSectionTitle(
                    'Informasi Terkini',
                    '',
                    AppTheme.primaryColor,
                    AppTheme.textWhite,
                    null,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildNewsBanner(),
                  ),

                  const SizedBox(height: 32),

                  // Aktivitas Terakhir
                  // _buildSectionTitle(
                  //   'Aktivitas Terakhir',
                  //   'Lihat Semua',
                  //   Colors.white,
                  //   AppTheme.primaryColor,
                  //   () {},
                  // ),
                  // const SizedBox(height: 16),
                  // _buildRecentActivities(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            context.go('/news');
            return;
          }

          if (index == 3) {
            context.go('/profile');
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // _loadLoggedInUser is no longer needed since name is reactively watched from authProvider

  Widget _buildBackgroundHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 380, // Ditinggikan sedikit agar aman untuk padding SafeArea
      child: Container(
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
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: 50,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(String loggedInName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE2E8F0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=11',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getGreeting(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loggedInName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Notification Glass Effect
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => context.push('/notifications'),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.8),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari layanan atau informasi...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: Colors.white.withValues(alpha: 0.9),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String actionText,
    Color colortitle,
    Color coloraction,
    VoidCallback? onAction,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: colortitle,
              letterSpacing: -0.3,
            ),
          ),
          if (actionText.isNotEmpty)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: coloraction,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      padding: EdgeInsets.zero,
      children: [
        _buildModernMenuCard(
          title: 'Samba',
          subtitle: 'Pengelolaan',
          iconPath: 'assets/icons/cash-banknote-plus.svg',
          color: const Color(0xFF4FA8D2),
          gradient: const [Color(0xFF4FA8D2), Color(0xFF3388CA)],
          onTap: () => context.go('/samba'),
        ),
        _buildModernMenuCard(
          title: 'Simontok',
          subtitle: 'Monitoring',
          iconPath: 'assets/icons/device-desktop-analytics.svg',
          color: const Color(0xFFE28C4A),
          gradient: const [Color(0xFFE28C4A), Color(0xFFD6732B)],
          onTap: () => context.go('/simontok'),
        ),
        _buildModernMenuCard(
          title: 'Helpdesk',
          subtitle: 'Bantuan',
          iconPath: 'assets/icons/messages.svg',
          color: const Color(0xFF4CAF50),
          gradient: const [Color(0xFF4EE293), Color(0xFF30B16B)],
          onTap: () => context.go('/helpdesk'),
        ),
        _buildModernMenuCard(
          title: 'Presensi',
          subtitle: 'Kehadiran',
          iconPath: 'assets/icons/fingerprint.svg',
          color: const Color(0xFF9C27B0),
          gradient: const [Color(0xFFA648E8), Color(0xFF7521B1)],
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildModernMenuCard({
    required String title,
    required String subtitle,
    required String iconPath,
    required Color color,
    required List<Color> gradient,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: color.withValues(alpha: 0.1), width: 1),
      ),
      shadowColor: color.withValues(alpha: 0.1),
      elevation: 8,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        highlightColor: color.withValues(alpha: 0.05),
        splashColor: color.withValues(alpha: 0.1),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.08),
                      color.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.last.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark slate
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=600&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0xFF1E293B).withValues(alpha: 0.8),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'UPDATE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pembaruan Sistem Portal\nQ1 2026',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Baca Selengkapnya',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white.withValues(alpha: 0.7),
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
