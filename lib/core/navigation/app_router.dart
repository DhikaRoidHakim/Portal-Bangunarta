import 'package:bangunarta_portal/core/navigation/navigation_service.dart';
import 'package:bangunarta_portal/features/auth/screens/login_screen.dart';
import 'package:bangunarta_portal/features/helpdesk/screens/home_screen.dart';
import 'package:bangunarta_portal/features/samba/screens/detail_rekening.dart';
import 'package:bangunarta_portal/features/samba/screens/detail_transaksi.dart';
import 'package:bangunarta_portal/features/samba/screens/home_screen.dart';
import 'package:bangunarta_portal/features/samba/screens/profile_screen.dart';
import 'package:bangunarta_portal/features/shell/screens/dashboard.dart';
import 'package:bangunarta_portal/features/shell/screens/news_detail_screen.dart';
import 'package:bangunarta_portal/features/shell/screens/news_screen.dart';
import 'package:bangunarta_portal/features/shell/screens/notification_center_screen.dart';
import 'package:bangunarta_portal/features/shell/screens/profile_screen.dart'
    as shell_profile;
import 'package:bangunarta_portal/features/shell/screens/splash_screen.dart';
import 'package:bangunarta_portal/features/simontok/screens/buat_laporan_screen.dart';
import 'package:bangunarta_portal/features/simontok/screens/detail_kredit_screen.dart';
import 'package:bangunarta_portal/features/simontok/screens/detail_prospek_screen.dart';
import 'package:bangunarta_portal/features/simontok/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    // Auth Route
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    // Dashboard Route
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
      routes: [
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationCenterPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const shell_profile.ProfilePage(),
        ),
      ],
    ),

    // Helpdesk Route
    GoRoute(
      path: '/helpdesk',
      builder: (context, state) => const HelpdeskHomeScreen(),
    ),

    // News Route (Persiapan)
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsPage(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final news = state.extra as NewsItem;
            return NewsDetailPage(news: news);
          },
        ),
      ],
    ),

    // Simontok Route
    GoRoute(
      path: '/simontok',
      builder: (context, state) => const SimontokHomeScreen(),
      routes: [
        GoRoute(
          path: 'kredit',
          builder: (context, state) => DetailKreditScreen(),
        ),
        GoRoute(
          path: 'buat-laporan',
          builder: (context, state) => const BuatLaporanScreen(),
        ),
        GoRoute(
          path: 'detail-prospek',
          builder: (context, state) {
            final name = state.extra as String;
            return DetailProspekScreen(namaDebitur: name);
          },
        ),
      ],
    ),

    // Samba Route
    GoRoute(
      path: '/samba',
      builder: (context, state) => const SambaHomeScreen(),
      routes: [
        GoRoute(
          path: 'rekening',
          builder: (context, state) => const DetailRekeningScreen(),
        ),
        GoRoute(
          path: 'transaksi',
          builder: (context, state) => const DetailTransaksiScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
