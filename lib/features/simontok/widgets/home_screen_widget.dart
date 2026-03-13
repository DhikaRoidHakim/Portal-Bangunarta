import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// Widget

// Logout (Sementara)
//TODO: Implementasi Logout
Widget logout(BuildContext context) {
  return AlertDialog(
    title: const Text('Keluar'),
    content: const Text('Apakah Anda yakin ingin keluar?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      TextButton(
        onPressed: () {
          // Implementasi logout
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
        child: const Text('Keluar'),
      ),
    ],
  );
}

// Bottom Navigation
Widget buildBottomNav(int currentIndex, Function(int) onTap) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: AppTheme.backgroundLight,
    elevation: 0,
    selectedItemColor: AppTheme.primaryColor,
    unselectedItemColor: AppTheme.textSecondary,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(
      color: AppTheme.primaryColor,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: TextStyle(
      color: AppTheme.textPrimary,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
    onTap: (index) {
      onTap(index);
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_outline),
        activeIcon: Icon(Icons.people),
        label: 'Kelolaan',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment_outlined),
        activeIcon: Icon(Icons.assignment),
        label: 'Tugas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.pie_chart_outline),
        activeIcon: Icon(Icons.pie_chart),
        label: 'Prospek',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
    ],
  );
}

// Dashboard Widget
Widget buildDashboardWidget({
  required int currentIndex,
  required Function(int) onTap,
}) {
  return Stack(
    children: [
      // Primary Background Header
      Container(
        height: 220,
        width: double.infinity,
        color: AppTheme.primaryColor,
      ),
      SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            // Top Custom App Bar
            Center(
              child: Text(
                'SIMONTOK Mobile',
                style: TextStyle(
                  color: AppTheme.textWhite,
                ).copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            // Main Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: .05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang',
                              style: TextStyle(color: AppTheme.textPrimary)
                                  .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Super Admin',
                              style: TextStyle(color: AppTheme.textPrimary)
                                  .copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.secondaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_outline,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppTheme.inputBorder, thickness: 1),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionItem(
                        icon: Icons.people_alt_outlined,
                        title: 'Kelolaan',
                        color: AppTheme.primaryColor,
                        onTap: () {
                          onTap(1);
                        },
                      ),
                      _buildActionItem(
                        icon: Icons.assignment_outlined,
                        title: 'Tugas',
                        color: Colors.pink,
                        onTap: () {
                          onTap(2);
                        },
                      ),
                      _buildActionItem(
                        icon: Icons.pie_chart_outline,
                        title: 'Prospek',
                        color: Colors.blue,
                        onTap: () {
                          onTap(3);
                        },
                      ),
                      _buildActionItem(
                        icon: Icons.check_circle_outline,
                        title: 'Verifikasi',
                        color: Colors.green,
                        onTap: () {
                          onTap(4);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grid Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Kelolaan Debitur',
                    '0',
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Surat Tugas', '0', Colors.pink),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Prospek Kredit', '0', Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Verifikasi Kredit', '0', Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom Illustration Banner (Placeholder)
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://img.freepik.com/free-vector/customer-support-illustration_23-2148889374.jpg',
                  ), // Generic placeholder for the bottom vector
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  opacity: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Action Item Widget
Widget _buildActionItem({
  required IconData icon,
  required String title,
  required Color color,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(icon, color: AppTheme.surfaceWhite, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

// Status Card Widget
Widget _buildStatCard(String title, String value, Color valueColor) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppTheme.surfaceWhite,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
