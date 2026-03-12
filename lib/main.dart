import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:bangunarta_portal/features/auth/screen/login_screen.dart';
import 'package:bangunarta_portal/features/shell/screens/splash_screen.dart';
import 'package:bangunarta_portal/features/shell/screens/dashboard.dart';

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
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/dashboard': (context) => const DashboardPage(),
          },
        ),
      ),
    );
  }
}
