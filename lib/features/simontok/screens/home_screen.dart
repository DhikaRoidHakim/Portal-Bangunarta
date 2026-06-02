// Main
import 'package:bangunarta_portal/core/auth/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// Screen
import 'kelolaan_screen.dart';
import 'tugas_screen.dart';
import 'prospek_screen.dart';

// Widgets
import 'package:bangunarta_portal/features/simontok/widgets/simontok_widgets.dart';

class SimontokHomeScreen extends StatefulWidget {
  const SimontokHomeScreen({super.key});

  @override
  State<SimontokHomeScreen> createState() => _SimontokHomeScreenState();
}

class _SimontokHomeScreenState extends State<SimontokHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          buildDashboardWidget(
            currentIndex: _currentIndex,
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
