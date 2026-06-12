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

  void _showFeatureNotAvailableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.construction_outlined,
                  color: AppTheme.primaryColor,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Segera Hadir',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Fitur ini sedang dalam pengembangan dan akan segera hadir untuk Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Tutup'),
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
        onTap: _showFeatureNotAvailableDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildSambaBottomAppBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _showFeatureNotAvailableDialog();
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
