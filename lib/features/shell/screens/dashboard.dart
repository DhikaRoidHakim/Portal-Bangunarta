import 'dart:ui';

import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/utils/dashboard_util.dart';
import 'package:bangunarta_portal/features/shell/widgets/dashboard_widgets.dart';
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
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Service data ──
  List<_ServiceItem> get _services => [
    _ServiceItem(
      title: 'Samba',
      subtitle: 'Pengelolaan Kredit',
      iconPath: 'assets/icons/cash-banknote-plus.svg',
      color: const Color(0xFF4FA8D2),
      gradient: const [Color(0xFF4FA8D2), Color(0xFF3388CA)],
      onTap: () => context.go('/samba'),
    ),
    _ServiceItem(
      title: 'Simontok',
      subtitle: 'Monitoring & Tagihan',
      iconPath: 'assets/icons/device-desktop-analytics.svg',
      color: const Color(0xFFE28C4A),
      gradient: const [Color(0xFFE28C4A), Color(0xFFD6732B)],
      onTap: () => context.go('/simontok'),
    ),
    // _ServiceItem(
    //   title: 'Helpdesk',
    //   subtitle: 'Pusat Bantuan',
    //   iconPath: 'assets/icons/messages.svg',
    //   color: const Color(0xFF4CAF50),
    //   gradient: const [Color(0xFF4EE293), Color(0xFF30B16B)],
    //   onTap: () => context.go('/helpdesk'),
    // ),
    // _ServiceItem(
    //   title: 'Presensi',
    //   subtitle: 'Kehadiran Karyawan',
    //   iconPath: 'assets/icons/fingerprint.svg',
    //   color: const Color(0xFF9C27B0),
    //   gradient: const [Color(0xFFA648E8), Color(0xFF7521B1)],
    //   onTap: () {},
    //   disabled: true,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final name = user?.employee.namaLengkap?.trim();
    final loggedInName = name == null || name.isEmpty ? 'User' : name;

    final filteredServices = _services.where((s) {
      final q = _searchQuery.toLowerCase();
      return s.title.toLowerCase().contains(q) ||
          s.subtitle.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      extendBody: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───
            _buildHeader(loggedInName),

            const SizedBox(height: 28),

            // ─── Section: Layanan ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchQuery.isEmpty
                        ? 'Layanan'
                        : 'Hasil Pencarian (${filteredServices.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      }),
                      child: Text(
                        'Bersihkan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Service Cards ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: filteredServices.isEmpty
                  ? _buildEmptyState()
                  : _buildServicesList(filteredServices),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            context.go('/dashboard/profile');
            return;
          }
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  HEADER
  // ═══════════════════════════════════════════════════════

  Widget _buildHeader(String loggedInName) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B3A7D), Color(0xFF264DA6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            children: [
              // ── Row: Avatar + Name + Bell ──
              Row(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        'assets/images/logo_polos.png',
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Greeting + Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loggedInName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => context.push('/dashboard/notifications'),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Search Bar ──
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari layanan...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        }),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 20,
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

  // ═══════════════════════════════════════════════════════
  //  SERVICE LIST (vertical cards)
  // ═══════════════════════════════════════════════════════

  Widget _buildServicesList(List<_ServiceItem> items) {
    return Column(
      children: List.generate(items.length, (i) {
        final s = items[i];
        final isLast = i == items.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
          child: _buildServiceCard(s),
        );
      }),
    );
  }

  Widget _buildServiceCard(_ServiceItem item) {
    final isDisabled = item.disabled;
    final cardColor = isDisabled ? Colors.grey.shade400 : item.color;
    final cardGradient = isDisabled
        ? [Colors.grey.shade400, Colors.grey.shade500]
        : item.gradient;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: isDisabled ? 0 : 2,
      shadowColor: cardColor.withValues(alpha: 0.15),
      child: InkWell(
        onTap: isDisabled ? null : item.onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: cardColor.withValues(alpha: 0.08),
        highlightColor: cardColor.withValues(alpha: 0.04),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey.shade200
                  : cardColor.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: cardGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDisabled
                      ? []
                      : [
                          BoxShadow(
                            color: cardGradient.last.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    item.iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDisabled
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),

              // Badge / Arrow
              if (isDisabled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                )
              else
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: cardColor,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  EMPTY STATE
  // ═══════════════════════════════════════════════════════

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              color: Colors.amber.shade700,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Layanan Tidak Ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tidak ada layanan yang cocok\ndengan "$_searchQuery"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => setState(() {
              _searchController.clear();
              _searchQuery = '';
            }),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: const Text(
              'Reset Pencarian',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  MODELS
// ═══════════════════════════════════════════════════════

class _ServiceItem {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color color;
  final List<Color> gradient;
  final VoidCallback onTap;
  final bool disabled;

  _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.color,
    required this.gradient,
    required this.onTap,
    this.disabled = false,
  });
}
