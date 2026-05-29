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
import 'package:bangunarta_portal/features/simontok/screens/detail_kredit_screen.dart';
import 'package:bangunarta_portal/features/simontok/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(path: '/news', builder: (context, state) => const NewsPage()),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationCenterPage(),
    ),
    GoRoute(
      path: '/news/detail',
      builder: (context, state) {
        final news = state.extra as NewsItem;

        return NewsDetailPage(news: news);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const shell_profile.ProfilePage(),
    ),
    GoRoute(
      path: '/simontok',
      builder: (context, state) => const SimontokHomeScreen(),
    ),
    GoRoute(
      path: '/simontok/kredit',
      builder: (context, state) => const DetailKreditScreen(),
    ),
    GoRoute(
      path: '/helpdesk',
      builder: (context, state) => const HelpdeskHomeScreen(),
    ),
    GoRoute(
      path: '/samba',
      builder: (context, state) => const SambaHomeScreen(),
    ),
    GoRoute(
      path: '/samba/rekening',
      builder: (context, state) => const DetailRekeningScreen(),
    ),
    GoRoute(
      path: '/samba/transaksi',
      builder: (context, state) => const DetailTransaksiScreen(),
    ),
    GoRoute(
      path: '/samba/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
