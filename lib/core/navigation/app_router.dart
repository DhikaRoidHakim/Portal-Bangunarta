import 'package:bangunarta_portal/features/samba/screens/open_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/navigation/navigation_service.dart';
import 'package:bangunarta_portal/core/network/dio_client.dart';
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
import 'package:bangunarta_portal/features/simontok/screens/tambah_prospek_screen.dart';
import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';
import 'package:bangunarta_portal/models/simontok/list_prospek_model.dart';
import 'package:bangunarta_portal/features/sipebri/screens/home_screen.dart';
import 'package:bangunarta_portal/features/sipebri/screens/tracking_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (_, _) {
      notifyListeners();
    });
  }
}

// ─────────────────────────────────────────────────────
//  Router Provider
// ─────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthChangeNotifier(ref);

  // Set the unauthorized callback to update authProvider state
  DioClient.instance.onUnauthorized = () {
    ref.read(authProvider.notifier).forceUnauthenticated();
  };

  return GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final status = ref.read(authProvider).status;
      final location = state.matchedLocation;
      final isOnLogin = location == '/login';
      final isOnSplash = location == '/';

      if (status == AuthStatus.initial || status == AuthStatus.loading) {
        return null;
      }
      if (status == AuthStatus.unauthenticated || status == AuthStatus.error) {
        return isOnLogin ? null : '/login';
      }

      if (status == AuthStatus.authenticated) {
        return (isOnLogin || isOnSplash) ? '/dashboard' : null;
      }

      return null;
    },

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
            path: 'notifications',
            builder: (context, state) => const NotificationCenterPage(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const shell_profile.ProfilePage(),
          ),
        ],
      ),

      // Helpdesk Route
      GoRoute(
        path: '/helpdesk',
        builder: (context, state) => const HelpdeskHomeScreen(),
      ),

      // News Route
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
            builder: (context, state) {
              final task = state.extra as TugasModel;
              return BuatLaporanScreen(task: task);
            },
          ),
          GoRoute(
            path: 'detail-prospek',
            builder: (context, state) {
              final id = state.extra as int;
              return DetailProspekScreen(prospekId: id);
            },
          ),
          GoRoute(
            path: 'tambah-prospek',
            builder: (context, state) {
              final prospek = state.extra as ProspekModel?;
              return TambahProspekScreen(prospek: prospek);
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
            builder: (context, state) {
              final nomorRekening = state.extra as String;
              return DetailRekeningScreen(nomorRekening: nomorRekening);
            },
          ),
          GoRoute(
            path: 'transaksi',
            builder: (context, state) {
              final id = state.extra as int;
              return DetailTransaksiScreen(transactionId: id);
            },
          ),
          GoRoute(
            path: 'open-account',
            builder: (context, state) => const OpenAccountScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Sipebri Route
      GoRoute(
        path: '/sipebri',
        builder: (context, state) => const SipebriHomeScreen(),
        routes: [
          GoRoute(
            path: 'tracking-detail',
            builder: (context, state) {
              final name = state.extra as String? ?? 'User';
              return SipebriTrackingDetailScreen(name: name);
            },
          ),
        ],
      ),
    ],
  );
});
