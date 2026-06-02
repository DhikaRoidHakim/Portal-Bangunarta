import 'package:bangunarta_portal/features/samba/screens/open_account_screen.dart';
import 'package:bangunarta_portal/core/auth/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// Screen
import 'rekening_screen.dart';
import 'transaksi_screen.dart';

// Widgets
import 'package:bangunarta_portal/features/samba/widgets/samba_widgets.dart';

class SambaHomeScreen extends StatefulWidget {
  const SambaHomeScreen({super.key});

  @override
  State<SambaHomeScreen> createState() => _SambaHomeScreenState();
}

class _SambaHomeScreenState extends State<SambaHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading:
            false, // Menghilangkan back button bawaan jika ada
        title: Row(
          children: [
            Image.asset('assets/images/logo_polos.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text(
              'BPR BANGUNARTA',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppTheme.inputBorder, height: 1.0),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          buildBerandaBody(),
          const RekeningScreen(),
          const OpenAccountScreen(),
          const TransaksiScreen(),
          const SettingsPage(),
        ],
      ),
      floatingActionButton: buildSambaFAB(
        currentIndex: _currentIndex,
        onTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildSambaBottomAppBar(
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
