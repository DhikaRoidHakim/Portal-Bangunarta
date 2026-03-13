// Main
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
          logout(context),
        ],
      ),
      bottomNavigationBar: buildBottomNav(_currentIndex, (index) {
        setState(() {
          _currentIndex = index;
        });
      }),
    );
  }
}
