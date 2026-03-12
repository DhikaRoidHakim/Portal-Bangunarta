import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// Widgets
import 'package:bangunarta_portal/features/shell/widgets/dashboard_widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody:
          true, // Memastikan body dapat di-scroll di belakang floating navbar
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: MediaQuery.of(context).padding.top + 20.0,
          bottom: 120.0, // Ruang kosong tambahan untuk floating nav bar
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Profile & Bell)
            buildHeader(),
            const SizedBox(height: 24),

            // Search Bar
            buildSearchBar(),
            const SizedBox(height: 24),

            // Info Terkini / Banner Berita
            const Text(
              'Info Terkini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            buildNewsBanner(),

            // Title Section Layanan Kami
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Layanan Kami',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Grid Menu Items
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.25,
              children: [
                buildMenuCard(
                  title: 'Sipebri',
                  iconPath: 'assets/icons/cash-banknote-plus.svg',
                  color: const Color(0xFF4FA8D2),
                ),
                buildMenuCard(
                  title: 'Simontok',
                  iconPath: 'assets/icons/device-desktop-analytics.svg',
                  color: const Color(0xFFE28C4A),
                ),
                buildMenuCard(
                  title: 'Helpdesk',
                  iconPath: 'assets/icons/messages.svg',
                  color: const Color(0xFF4CAF50),
                ),
                buildMenuCard(
                  title: 'Presensi',
                  iconPath: 'assets/icons/fingerprint.svg',
                  color: const Color(0xFF9C27B0),
                ),
              ],
            ),
            // const SizedBox(height: 12),

            // Aktivitas Terakhir
            // _buildRecentActivity(),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
