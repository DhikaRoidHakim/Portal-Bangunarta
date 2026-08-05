import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/models/sigma/list_assets_model.dart';
import 'package:bangunarta_portal/features/sigma/providers/sigma_provider.dart';
import 'package:bangunarta_portal/features/sigma/widgets/sigma_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SigmaAssetListScreen extends ConsumerStatefulWidget {
  final bool showBackButton;
  final bool initialInRepairOnly;

  const SigmaAssetListScreen({
    super.key,
    this.showBackButton = false,
    this.initialInRepairOnly = false,
  });

  @override
  ConsumerState<SigmaAssetListScreen> createState() => _SigmaAssetListScreenState();
}

class _SigmaAssetListScreenState extends ConsumerState<SigmaAssetListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(sigmaSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAssetDetailModal(BuildContext context, AssetsModel asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.only(
            left: 24.r,
            right: 24.r,
            top: 16.r,
            bottom: MediaQuery.of(context).padding.bottom + 24.r,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppTheme.inputBorder,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Code & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF28A745).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      asset.kodeAset,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF28A745),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: asset.inRepair
                          ? const Color(0xFFDC3545).withValues(alpha: 0.1)
                          : const Color(0xFF28A745).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      asset.inRepair ? 'Dalam Perbaikan' : 'Kondisi Baik (Aktif)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: asset.inRepair
                            ? const Color(0xFFDC3545)
                            : const Color(0xFF28A745),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                asset.namaAset,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              Divider(color: AppTheme.inputBorder.withValues(alpha: 0.5)),
              SizedBox(height: 16.h),

              // Details grid
              _buildDetailRow(
                icon: Icons.business_rounded,
                label: 'Lokasi Kantor',
                value: asset.currentOfficeName,
              ),
              SizedBox(height: 12.h),
              _buildDetailRow(
                icon: Icons.meeting_room_rounded,
                label: 'Ruangan',
                value: asset.currentRoomName,
              ),
              SizedBox(height: 12.h),
              _buildDetailRow(
                icon: Icons.history_toggle_off_rounded,
                label: 'Terakhir Dipindah',
                value: asset.lastMovedAt != null
                    ? _formatDate(asset.lastMovedAt)
                    : 'Belum Pernah Dipindah',
              ),
              SizedBox(height: 12.h),
              _buildDetailRow(
                icon: Icons.numbers_rounded,
                label: 'Total Perpindahan',
                value: '${asset.totalMoves} kali',
              ),
              SizedBox(height: 12.h),
              _buildDetailRow(
                icon: Icons.build_circle_outlined,
                label: 'Total Perbaikan',
                value: '${asset.totalRepairs} kali',
              ),
              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        side: const BorderSide(color: Color(0xFF28A745)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF28A745),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/sigma/asset-detail', extra: asset);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28A745),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Detail Lengkap',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: const Color(0xFF28A745).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: const Color(0xFF28A745), size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetsAsync = ref.watch(sigmaAssetsNotifierProvider);
    final selectedOffice = ref.watch(sigmaOfficeFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: widget.showBackButton
          ? AppBar(
              backgroundColor: AppTheme.surfaceWhite,
              elevation: 0,
              title: Text(
                widget.initialInRepairOnly ? 'Aset Dalam Perbaikan' : 'Daftar Aset',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: Column(
        children: [
          // Search & Filter Header Card
          Container(
            padding: EdgeInsets.all(16.r),
            color: AppTheme.surfaceWhite,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    ref.read(sigmaSearchQueryProvider.notifier).updateQuery(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari kode / nama aset...',
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppTheme.textSecondary,
                      size: 20.sp,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, size: 18.sp),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(sigmaSearchQueryProvider.notifier).updateQuery('');
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.backgroundLight,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Office Filters Horizontal List
                assetsAsync.when(
                  data: (state) {
                    final offices = <String>{'Semua'};
                    for (var item in state.items) {
                      if (item.currentOfficeName.isNotEmpty) {
                        offices.add(item.currentOfficeName);
                      }
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: offices.map((office) {
                          final isSelected = (office == 'Semua' && selectedOffice == null) ||
                              (selectedOffice == office);

                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: FilterChip(
                              label: Text(office),
                              labelStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                              ),
                              selected: isSelected,
                              onSelected: (_) {
                                ref
                                    .read(sigmaOfficeFilterProvider.notifier)
                                    .selectOffice(office == 'Semua' ? null : office);
                              },
                              backgroundColor: AppTheme.backgroundLight,
                              selectedColor: const Color(0xFF28A745),
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                side: BorderSide.none,
                              ),
                              showCheckmark: false,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Assets List Body
          Expanded(
            child: assetsAsync.when(
              data: (state) {
                var filtered = state.items;

                // Filter for repair tab
                if (widget.initialInRepairOnly) {
                  filtered = filtered.where((item) => item.inRepair).toList();
                }

                // Filter by office
                if (selectedOffice != null && selectedOffice.isNotEmpty) {
                  filtered = filtered
                      .where((item) => item.currentOfficeName == selectedOffice)
                      .toList();
                }

                if (filtered.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(sigmaAssetsNotifierProvider.notifier).refresh(),
                    child: ListView(
                      children: [
                        SizedBox(height: 80.h),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64.sp,
                                color: AppTheme.textSecondary.withValues(alpha: 0.5),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Tidak Ada Aset Ditemukan',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Coba sesuaikan pencarian atau filter Anda',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFF28A745),
                  onRefresh: () =>
                      ref.read(sigmaAssetsNotifierProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return SigmaAssetCard(
                        asset: item,
                        onTap: () => _showAssetDetailModal(context, item),
                      );
                    },
                  ),
                );
              },
              loading: () => const SigmaBerandaSkeleton(),
              error: (err, stack) => Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.sp,
                        color: const Color(0xFFDC3545),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Gagal Memuat Data Aset',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        err.toString().replaceAll('Exception: ', ''),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () =>
                            ref.read(sigmaAssetsNotifierProvider.notifier).refresh(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF28A745),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
