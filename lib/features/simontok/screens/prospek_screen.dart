import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_provider.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_repository.dart';
import 'package:bangunarta_portal/models/simontok/list_prospek_model.dart';

class ProspekPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const ProspekPage({super.key, this.showBackButton = true});

  @override
  ConsumerState<ProspekPage> createState() => _ProspekPageState();
}

class _ProspekPageState extends ConsumerState<ProspekPage> {
  bool _isSearching = false;
  late TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref
            .read(simontokProspekSearchQueryProvider.notifier)
            .updateQuery(query);
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        _isSearching = false;
        _searchController.clear();
        ref.read(simontokProspekSearchQueryProvider.notifier).updateQuery('');
      } else {
        _isSearching = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listProspekAsync = ref.watch(listProspekProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Cari nama prospek...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'PROSPEK',
                style: TextStyle(
                  color: AppTheme.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 24.sp),
            onPressed: () => context.push('/simontok/tambah-prospek'),
          ),
        ],
      ),
      body: listProspekAsync.when(
        data: (model) {
          final prospeks = model.data;
          if (prospeks.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: () async {
              ref.invalidate(listProspekProvider);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.textPrimary.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(prospeks.length, (idx) {
                      final prospek = prospeks[idx];
                      return _buildProspekItem(
                        context,
                        prospek,
                        isLast: idx == prospeks.length - 1,
                      );
                    }),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildProspekItem(
    BuildContext context,
    ProspekModel prospek, {
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: () => _showActionBottomSheet(prospek),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7F8C9D),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prospek.namaLengkap,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ).copyWith(color: AppTheme.secondaryColor),
                      ),
                      if (prospek.nomorHp != null &&
                          prospek.nomorHp!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          prospek.nomorHp!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (prospek.status != null) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: prospek.status == 'Selesai'
                          ? const Color(0xFF10B981).withValues(alpha: 0.1)
                          : Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      prospek.status!,
                      style: TextStyle(
                        color: prospek.status == 'Selesai'
                            ? const Color(0xFF10B981)
                            : Colors.amber.shade800,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isLast)
            Divider(
              color: AppTheme.inputBorder,
              thickness: 0.5.h,
              height: 0.h,
              indent: 72.w,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.trending_up_rounded,
                color: AppTheme.primaryColor,
                size: 56.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Tidak Ada Prospek',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Tidak ditemukan data prospek yang cocok atau aktif saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.sp,
                height: 1.4.h,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(listProspekProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Segarkan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 56.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Gagal Memuat Prospek',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14.sp,
                height: 1.4.h,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(listProspekProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionBottomSheet(ProspekModel prospek) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: .24),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                prospek.namaLengkap,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (prospek.nomorHp != null && prospek.nomorHp!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  prospek.nomorHp!,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              Divider(height: 1.h),
              SizedBox(height: 12.h),
              _buildBottomSheetItem(
                icon: Icons.info_outline,
                title: 'Detail Prospek',
                subtitle: 'Lihat rincian lengkap informasi prospek',
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push('/simontok/detail-prospek', extra: prospek.id);
                },
              ),
              _buildBottomSheetItem(
                icon: Icons.edit_outlined,
                title: 'Edit Prospek',
                subtitle: 'Ubah data informasi prospek ini',
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push('/simontok/tambah-prospek', extra: prospek);
                },
              ),
              _buildBottomSheetItem(
                icon: Icons.delete_outline_rounded,
                title: 'Hapus Prospek',
                subtitle: 'Hapus prospek ini secara permanen',
                iconColor: Colors.redAccent,
                titleColor: Colors.redAccent,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _confirmDeleteProspek(prospek);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.primaryColor).withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppTheme.primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: titleColor ?? AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteProspek(ProspekModel prospek) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Hapus Prospek?',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus prospek "${prospek.namaLengkap}"? Tindakan ini tidak dapat dibatalkan.',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Batal',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close confirmation dialog
                _deleteProspek(prospek);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('Ya, Hapus', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        );
      },
    );
  }

  void _deleteProspek(ProspekModel prospek) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        );
      },
    );

    final navigator = Navigator.of(context);

    Future(() async {
      try {
        final response = await SimontokRepository.instance.deleteProspek(
          prospek.id,
        );

        if (!mounted) return;
        navigator.pop(); // Pop loading dialog

        ref.invalidate(listProspekProvider);

        showDialog(
          context: context,
          builder: (successContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28.sp),
                SizedBox(width: 8.w),
                Text('Berhasil', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            content: Text(
              response.message.isNotEmpty
                  ? response.message
                  : 'Prospek "${prospek.namaLengkap}" berhasil dihapus.',
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(successContext),
                child: Text('OK', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
        );
      } catch (e) {
        if (!mounted) return;
        navigator.pop(); // Pop loading dialog

        showDialog(
          context: context,
          builder: (errorContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.redAccent, size: 28.sp),
                SizedBox(width: 8.w),
                Text('Gagal', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(errorContext),
                child: Text('Tutup', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
        );
      }
    });
  }
}
