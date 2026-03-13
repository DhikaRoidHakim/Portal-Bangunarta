import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppTheme.textPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 40.w,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'SIMONTOK',
              style: TextStyle(color: AppTheme.textPrimary).copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Sistem Monitoring Kredit',
              style: TextStyle(color: AppTheme.textSecondary).copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
