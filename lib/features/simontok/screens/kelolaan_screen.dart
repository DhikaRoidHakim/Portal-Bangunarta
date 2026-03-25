import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'detail_kredit_screen.dart';

class KelolaanPage extends StatelessWidget {
  final bool showBackButton;
  const KelolaanPage({super.key, this.showBackButton = true});

  // 5 data dummy nasabah kredit
  static const List<Map<String, String>> _dummyData = [
    {'nama': 'ACAH CAHYATI', 'noRekening': '001010140151516756'},
    {'nama': 'ACENG FAJAR RIZKY PERMANA', 'noRekening': '0010101401523194'},
    {'nama': 'AGUS YANTO', 'noRekening': '0010101401522603'},
    {'nama': 'AHMAD MUSHOLLI', 'noRekening': '0010101401521064'},
    {'nama': 'AHMAD ROHMAT', 'noRekening': '0010101401522079'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        title: const Text(
          'KREDIT',
          style: TextStyle(
            color: AppTheme.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _dummyData.length,
        itemBuilder: (context, index) {
          final item = _dummyData[index];
          return Column(
            children: [
              _NasabahTile(
                nama: item['nama']!,
                noRekening: item['noRekening']!,
                onTap: () => _showAksiBottomSheet(context, item['nama']!),
              ),
              if (index < _dummyData.length - 1)
                const Divider(
                  height: 1,
                  thickness: 0.8,
                  color: Color(0xFFE2E8F0),
                  indent: 72,
                  endIndent: 0,
                ),
            ],
          );
        },
      ),
    );
  }

  void _showAksiBottomSheet(BuildContext context, String nama) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Pilih Aksi',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 0.8, color: Color(0xFFE2E8F0)),
              // Detail Kredit
              ListTile(
                leading: const Icon(Icons.person_outline, size: 24),
                title: const Text(
                  'Detail Kredit',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailKreditScreen(
                        namaDebitur: nama,
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                height: 1,
                thickness: 0.8,
                color: Color(0xFFE2E8F0),
                indent: 16,
                endIndent: 16,
              ),
              // Buat Tugas
              ListTile(
                leading: const Icon(Icons.description_outlined, size: 24),
                title: const Text(
                  'Buat Tugas',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  // TODO: Navigasi ke halaman Buat Tugas
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _NasabahTile extends StatelessWidget {
  final String nama;
  final String noRekening;
  final VoidCallback? onTap;

  const _NasabahTile({
    required this.nama,
    required this.noRekening,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar lingkaran ungu gelap dengan icon person
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.textWhite,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Nama & nomor rekening
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    noRekening,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
