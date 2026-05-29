import 'dart:math' show pi, sin, cos;
import 'dart:ui' show ImageFilter;
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  String _version = '';
  late AnimationController _entryController;
  late AnimationController _floatingController;

  // Staggered animations
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    _initVersion();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // Loop terus untuk efek mengambang

    // Animasi kemunculan Logo
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // Animasi kemunculan Judul
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _titleSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    // Animasi kemunculan Subtitle/Tagline
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    // Animasi kemunculan Footer & Progress Bar
    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _entryController.forward();

    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    await ref.read(authProvider.notifier).checkAuth();

    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.status == AuthStatus.authenticated) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  Future<void> _initVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = 'v${info.version}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _version = 'v1.0.0';
        });
      }
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Base Gradient (Kombinasi Gradasi Lembut)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFF2F5FA),
                  Color(0xFFEBF1FC),
                ],
              ),
            ),
          ),

          // 2. Ambient Blurred Glowing Spheres (Orbs Dekoratif Melayang Lambat)
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              final double dy = sin(_floatingController.value * 2 * pi);
              final double dx = cos(_floatingController.value * 2 * pi);
              return Stack(
                children: [
                  // Orb 1: Atas Kanan (Warna Secondary Blue dengan opacity rendah)
                  Positioned(
                    top: -60 + (dy * 25),
                    right: -60 + (dx * 20),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.secondaryColor.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  // Orb 2: Bawah Kiri (Warna Primary Navy dengan opacity rendah)
                  Positioned(
                    bottom: -80 + (dx * 25),
                    left: -80 + (dy * 20),
                    child: Container(
                      width: 340,
                      height: 340,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 3. Efek Blur untuk latar belakang glassmorphic orbs
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 65.0, sigmaY: 65.0),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 4. Konten Utama
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Container dengan Efek Glassmorphism & Floating
                      AnimatedBuilder(
                        animation: _entryController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _logoFade,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: child,
                            ),
                          );
                        },
                        child: AnimatedBuilder(
                          animation: _floatingController,
                          builder: (context, child) {
                            final double floatOffset =
                                sin(_floatingController.value * 2 * pi) * 8;
                            return Transform.translate(
                              offset: Offset(0, floatOffset),
                              child: child,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.75),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: -4,
                                  offset: const Offset(0, -6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/images/logo_polos.png',
                                width: 124,
                                height: 124,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.business,
                                    size: 74,
                                    color: AppTheme.primaryColor,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Teks Judul Utama ("BANGUNARTA") dengan Slide & Fade
                      AnimatedBuilder(
                        animation: _entryController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _titleFade,
                            child: SlideTransition(
                              position: _titleSlide,
                              child: child,
                            ),
                          );
                        },
                        child: const Text(
                          'BANGUNARTA',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryColor,
                            letterSpacing: 4.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tagline/Subtitle ("PORTAL APLIKASI") dengan Slide & Fade
                      AnimatedBuilder(
                        animation: _entryController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _subtitleFade,
                            child: SlideTransition(
                              position: _subtitleSlide,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          'PORTAL APLIKASI',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor.withValues(alpha: 0.6),
                            letterSpacing: 6.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer: Versi & Gradient Progress Bar
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _entryController,
                    builder: (context, child) {
                      return FadeTransition(opacity: _footerFade, child: child);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Custom Gradient Progress Bar
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 2700),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Progress Bar Track
                                Container(
                                  width: 140,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      FractionallySizedBox(
                                        widthFactor: value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppTheme.primaryColor,
                                                AppTheme.secondaryColor,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.secondaryColor
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Persentase Loading
                                Text(
                                  '${(value * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.5,
                                    ),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Versi Aplikasi
                        if (_version.isNotEmpty)
                          Text(
                            _version,
                            style: AppTheme.versionText.copyWith(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
