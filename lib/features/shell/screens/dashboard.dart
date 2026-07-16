import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/utils/dashboard_util.dart';
import 'package:bangunarta_portal/features/shell/widgets/dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _currentIndex = 0;
  late final TextEditingController _searchController;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Semua', 'icon': Icons.grid_view_rounded},
    {'name': 'Pendanaan', 'icon': Icons.account_balance_wallet_rounded},
    {'name': 'Kredit', 'icon': Icons.payments_rounded},
    {'name': 'SDM & UMUM', 'icon': Icons.people_alt_rounded},
  ];

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
      subtitle: 'Saving Mobile Bangunarta',
      iconPath: 'assets/icons/cash-banknote-plus.svg',
      color: const Color(0xFF4FA8D2),
      gradient: const [Color(0xFF4FA8D2), Color(0xFF3388CA)],
      onTap: () => context.go('/samba'),
      category: 'Pendanaan',
    ),
    _ServiceItem(
      title: 'Simontok',
      subtitle: 'Sistem Monitoring Kredit',
      iconPath: 'assets/icons/device-desktop-analytics.svg',
      color: const Color(0xFFE28C4A),
      gradient: const [Color(0xFFE28C4A), Color(0xFFD6732B)],
      onTap: () => context.go('/simontok'),
      category: 'Kredit',
    ),
    _ServiceItem(
      title: 'Sipebri',
      subtitle: 'Sistem Pemberian Kredit',
      iconPath: 'assets/icons/file-check.svg',
      color: AppTheme.primaryColor,
      gradient: const [AppTheme.primaryColor, Color(0xFF1E3A8A)],
      onTap: () => context.go('/sipebri'),
      category: 'Kredit',
      disabled: true,
    ),
    _ServiceItem(
      title: 'Sigma',
      subtitle: 'Sistem Informasi Management Assets',
      iconPath: 'assets/icons/device-desktop-analytics.svg',
      color: const Color(0xFF28A745),
      gradient: const [Color(0xFF28A745), Color(0xFF28A745)],
      onTap: () => context.go('/sipebri'),
      category: 'SDM & UMUM',
      disabled: true,
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
    final authMe = authState.user;
    final name = authMe?.user.name?.trim();
    final loggedInName = name == null || name.isEmpty ? 'User' : name;

    final filteredServices = _services.where((s) {
      final q = _searchQuery.toLowerCase();
      final matchesQuery =
          s.title.toLowerCase().contains(q) ||
          s.subtitle.toLowerCase().contains(q);

      if (_searchQuery.isNotEmpty) {
        return matchesQuery;
      } else {
        if (_selectedCategory == 'Semua') {
          return true;
        } else {
          return s.category == _selectedCategory;
        }
      }
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

            SizedBox(height: 28.h),

            // ─── Section: Layanan ───
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchQuery.isEmpty
                        ? 'Layanan'
                        : 'Hasil Pencarian (${filteredServices.length})',
                    style: TextStyle(
                      fontSize: 18.sp,
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
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              SizedBox(height: 14.h),
              _buildCategoryPills(),
            ],
            SizedBox(height: 16.h),

            // ─── Service Cards ───
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B3A7D), Color(0xFF264DA6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
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
                        width: 1.5.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22.r,
                      backgroundImage: const AssetImage(
                        'assets/images/logo_polos.png',
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),

                  // Greeting + Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          loggedInName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(14.r),
                  //   child: BackdropFilter(
                  //     filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  //     child: Container(
                  //       padding: const EdgeInsets.all(10),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white.withValues(alpha: 0.12),
                  //         borderRadius: BorderRadius.circular(14.r),
                  //         border: Border.all(
                  //           color: Colors.white.withValues(alpha: 0.18),
                  //         ),
                  //       ),
                  //       child: GestureDetector(
                  //         onTap: () => context.push('/dashboard/notifications'),
                  //         child: Icon(
                  //           Icons.notifications_none_rounded,
                  //           color: Colors.white,
                  //           size: 22.r,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              SizedBox(height: 20.h),

              // ── Search Bar ──
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 22.r,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: 'Cari layanan...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
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
                          size: 20.r,
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
  //  Category Pills & List Layanan
  // ═══════════════════════════════════════════════════════

  Widget _buildCategoryPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: _categories.map((cat) {
          final name = cat['name'] as String;
          final icon = cat['icon'] as IconData;
          final isSelected = _selectedCategory == name;

          // Count items in this category
          int count = 0;
          if (name == 'Semua') {
            count = _services.length;
          } else {
            count = _services.where((s) => s.category == name).length;
          }

          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Material(
              color: isSelected ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              elevation: isSelected ? 4 : 0,
              shadowColor: isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF092966), Color(0xFF1976D2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = name;
                    });
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 18.sp,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServicesList(List<_ServiceItem> items) {
    // If searching, just render as flat list of search results
    if (_searchQuery.isNotEmpty) {
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

    // If a specific category is selected, render its items as flat list
    if (_selectedCategory != 'Semua') {
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

    // If 'Semua' is selected, group by category
    final grouped = <String, List<_ServiceItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    // Order of categories to display
    final categoryOrder = ['Pendanaan', 'Kredit', 'SDM & UMUM'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categoryOrder.map((category) {
        final categoryItems = grouped[category] ?? [];
        if (categoryItems.isEmpty) return const SizedBox.shrink();

        // Get matching colors/accent for each category header
        Color categoryAccentColor;
        switch (category) {
          case 'Pendanaan':
            categoryAccentColor = const Color(0xFF3388CA);
            break;
          case 'Kredit':
            categoryAccentColor = const Color(0xFFE28C4A);
            break;
          case 'SDM & UMUM':
            categoryAccentColor = const Color(0xFF28A745);
            break;
          default:
            categoryAccentColor = AppTheme.primaryColor;
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Section Header
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: categoryAccentColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '(${categoryItems.length})',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // List of cards for this category
              ...List.generate(categoryItems.length, (i) {
                final s = categoryItems[i];
                final isLast = i == categoryItems.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
                  child: _buildServiceCard(s),
                );
              }),
            ],
          ),
        );
      }).toList(),
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
            borderRadius: BorderRadius.circular(20.r),
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
                width: 52.w,
                height: 52.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: cardGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
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
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

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
                    SizedBox(height: 3.h),
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
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: cardColor,
                    size: 16.sp,
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
        borderRadius: BorderRadius.circular(20.r),
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
              size: 36.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Layanan Tidak Ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Tidak ada layanan yang cocok\ndengan "$_searchQuery"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
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
            child: Text(
              'Reset Pencarian',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
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
  final String category;

  _ServiceItem({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.color,
    required this.gradient,
    required this.onTap,
    this.disabled = false,
    required this.category,
  });
}
