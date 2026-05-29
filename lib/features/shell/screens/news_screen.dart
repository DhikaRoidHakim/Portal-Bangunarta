import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/shell/widgets/floatingnav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class NewsItem {
  const NewsItem({
    required this.title,
    required this.category,
    required this.date,
    required this.imageUrl,
    required this.summary,
    required this.content,
  });

  final String title;
  final String category;
  final String date;
  final String imageUrl;
  final String summary;
  final String content;
}

const List<NewsItem> dummyNews = [
  NewsItem(
    title: 'Bangunarta One Hadir untuk Memudahkan Aktivitas Karyawan',
    category: 'Perusahaan',
    date: '20 Mei 2026',
    imageUrl:
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?q=80&w=1200&auto=format&fit=crop',
    summary:
        'Portal internal kini menghadirkan akses layanan yang lebih cepat dan terintegrasi untuk seluruh karyawan.',
    content:
        'Bangunarta One dikembangkan sebagai portal terpusat untuk membantu karyawan mengakses berbagai layanan internal secara lebih mudah. Melalui aplikasi ini, informasi perusahaan, layanan operasional, dan kebutuhan kerja harian dapat diakses dalam satu tempat.\n\nPengembangan akan dilakukan bertahap agar setiap fitur dapat digunakan secara stabil dan sesuai kebutuhan pengguna.',
  ),
  NewsItem(
    title: 'Peningkatan Keamanan Akun dengan Autentikasi Token',
    category: 'Teknologi',
    date: '19 Mei 2026',
    imageUrl:
        'https://images.unsplash.com/photo-1563986768494-4dee2763ff3f?q=80&w=1200&auto=format&fit=crop',
    summary:
        'Sistem login menggunakan token diterapkan untuk menjaga keamanan akses aplikasi.',
    content:
        'Keamanan akun menjadi prioritas dalam pengembangan portal. Dengan autentikasi token, setiap request ke layanan yang membutuhkan otorisasi akan divalidasi menggunakan token pengguna.\n\nPengguna diimbau untuk menjaga kerahasiaan akun dan tidak membagikan kredensial login kepada pihak lain.',
  ),
  NewsItem(
    title: 'Informasi Pemeliharaan Sistem Internal',
    category: 'Pengumuman',
    date: '18 Mei 2026',
    imageUrl:
        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=1200&auto=format&fit=crop',
    summary:
        'Pemeliharaan sistem akan dilakukan untuk meningkatkan performa dan stabilitas layanan.',
    content:
        'Tim IT akan melakukan pemeliharaan sistem internal secara berkala. Selama proses berlangsung, beberapa layanan mungkin mengalami keterlambatan akses sementara.\n\nPemeliharaan ini bertujuan untuk memastikan aplikasi tetap stabil, aman, dan nyaman digunakan oleh seluruh pengguna.',
  ),
];

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBody: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: dummyNews
                    .map(
                      (news) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildNewsCard(context, news),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavWidget(
        currentIndex: 2,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF19428F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berita',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Informasi terbaru seputar perusahaan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsItem news) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          context.push('/news/detail', extra: news);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  news.imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildCategoryBadge(news.category),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            news.date,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      news.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      news.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) {
      context.go('/dashboard');
      return;
    }

    if (index == 3) {
      context.go('/profile');
    }
  }
}
