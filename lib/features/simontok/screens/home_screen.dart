// Main
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/auth/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screen
import 'kelolaan_screen.dart';
import 'tugas_screen.dart';
import 'prospek_screen.dart';

// Widgets
import 'package:bangunarta_portal/features/simontok/widgets/simontok_widgets.dart';

class SimontokHomeScreen extends ConsumerStatefulWidget {
  const SimontokHomeScreen({super.key});

  @override
  ConsumerState<SimontokHomeScreen> createState() => _SimontokHomeScreenState();
}

class _SimontokHomeScreenState extends ConsumerState<SimontokHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user?.user;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          buildDashboardWidget(
            currentIndex: _currentIndex,
            namaPengguna: user?.name ?? 'User',
            role: user?.role ?? 'User',
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          const KelolaanPage(showBackButton: false),
          const TugasPage(showBackButton: false),
          const ProspekPage(showBackButton: false),
          const SettingsPage(),
        ],
      ),
      floatingActionButton: buildSimontokFAB(
        currentIndex: _currentIndex,
        onTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildSimontokBottomAppBar(
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
