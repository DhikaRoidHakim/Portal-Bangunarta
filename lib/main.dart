import 'package:bangunarta_portal/features/auth/screen/login_screen.dart';
import 'package:bangunarta_portal/features/helpdesk/screens/home_screen.dart';
import 'package:bangunarta_portal/features/samba/screens/detail_rekening.dart';
import 'package:bangunarta_portal/features/samba/screens/detail_transaksi.dart';
import 'package:bangunarta_portal/features/samba/screens/home_screen.dart';
import 'package:bangunarta_portal/features/samba/screens/profile_screen.dart';
import 'package:bangunarta_portal/features/shell/screens/dashboard.dart';
import 'package:bangunarta_portal/features/shell/screens/splash_screen.dart';
import 'package:bangunarta_portal/features/simontok/screens/detail_kredit_screen.dart';
import 'package:bangunarta_portal/features/simontok/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => OverlaySupport.global(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            // Portal Routes
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/dashboard': (context) => const DashboardPage(),

            // Simontok Routes
            '/simontok': (context) => const SimontokHomeScreen(),
            '/simontok/kredit': (context) => const DetailKreditScreen(),

            // Helpdesk Routes
            '/helpdesk': (context) => const HelpdeskHomeScreen(),

            // Samba Routes
            '/samba': (context) => const SambaHomeScreen(),
            '/samba/rekening': (context) => const DetailRekeningScreen(),
            '/samba/transaksi': (context) => const DetailTransaksiScreen(),
            '/samba/profile': (context) => const ProfileScreen(),
          },
        ),
      ),
    );
  }
}
