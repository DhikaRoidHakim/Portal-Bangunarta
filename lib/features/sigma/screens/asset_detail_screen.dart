import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/models/sigma/detail_asset_model.dart';
import 'package:bangunarta_portal/models/sigma/list_assets_model.dart';
import 'package:bangunarta_portal/features/sigma/providers/sigma_provider.dart';
import 'package:bangunarta_portal/core/widgets/skeleton_loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AssetDetailScreen extends ConsumerStatefulWidget {
  final String? assetId;
  final DetailModel? asset;

  const AssetDetailScreen({
    super.key,
    this.assetId,
    this.asset,
  });

  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen> {
  void _showFeatureNotAvailableDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.construction_outlined,
                  color: const Color(0xFF28A745),
                  size: 48.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text('Tutup', style: TextStyle(fontSize: 14.sp)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'Belum ada data';
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If direct asset model is passed
    if (widget.asset != null) {
      return _buildScaffold(widget.asset!);
    }

    final assetId = widget.assetId;
    if (assetId == null || assetId.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceWhite,
          title: Text('Detail Aset', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16.sp)),
        ),
        body: Center(
          child: Text(
            'ID Aset tidak ditemukan',
            style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    final detailAsync = ref.watch(sigmaDetailAssetProvider(assetId));

    return detailAsync.when(
      data: (model) {
        final detailData = model.detail;
        if (detailData == null) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppTheme.surfaceWhite,
              title: Text('Detail Aset', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16.sp)),
            ),
            body: Center(
              child: Text(
                'Data detail aset tidak ditemukan',
                style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
              ),
            ),
          );
        }
        return _buildScaffold(detailData);
      },
      loading: () => Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceWhite,
          elevation: 0,
          title: Text(
            'Detail Aset',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              SkeletonBox(width: double.infinity, height: 160.h, borderRadius: 20.r),
              SizedBox(height: 16.h),
              SkeletonBox(width: double.infinity, height: 200.h, borderRadius: 20.r),
            ],
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceWhite,
          elevation: 0,
          title: Text(
            'Detail Aset',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 48.sp, color: const Color(0xFFDC3545)),
                SizedBox(height: 16.h),
                Text(
                  'Gagal Memuat Detail Aset',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                SizedBox(height: 8.h),
                Text(
                  err.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: AppTheme.textSecondary),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => ref.invalidate(sigmaDetailAssetProvider(assetId)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28A745),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(DetailModel asset) {
    final isRepair = asset.inRepair;
    final statusColor = isRepair ? const Color(0xFFDC3545) : const Color(0xFF28A745);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Detail Aset',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_2_rounded, color: const Color(0xFF28A745), size: 24.sp),
            onPressed: () {
              _showFeatureNotAvailableDialog(
                'Cetak QR Code',
                'Fitur cetak QR Code label aset sedang dalam pengembangan.',
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0.h),
          child: Container(color: AppTheme.inputBorder, height: 1.0.h),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isRepair
                      ? [const Color(0xFFDC3545), const Color(0xFFA71D2A)]
                      : [const Color(0xFF28A745), const Color(0xFF1E7E34)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          asset.kodeAset,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          isRepair ? 'Sedang Perbaikan' : 'Kondisi Aktif',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    asset.namaAset,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white.withValues(alpha: 0.9), size: 16.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '${asset.currentOfficeName} • ${asset.currentRoomName}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Section 1: Detail Lokasi & Ruangan
            _buildSectionCard(
              title: 'Informasi Lokasi & PIC',
              icon: Icons.business_center_rounded,
              children: [
                _buildInfoItem(
                  icon: Icons.apartment_rounded,
                  label: 'Nama Kantor',
                  value: asset.currentOfficeName,
                ),
                _buildInfoItem(
                  icon: Icons.meeting_room_rounded,
                  label: 'Ruangan',
                  value: asset.currentRoomName,
                ),
                _buildInfoItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Penanggung Jawab (PIC)',
                  value: asset.currentRoomPic ?? 'Belum Ditentukan',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Section 2: Riwayat Pemeliharaan & Mutasi
            _buildSectionCard(
              title: 'Riwayat & Pemeliharaan',
              icon: Icons.history_edu_rounded,
              children: [
                _buildInfoItem(
                  icon: Icons.compare_arrows_rounded,
                  label: 'Total Perpindahan',
                  value: '${asset.totalMoves} kali',
                ),
                _buildInfoItem(
                  icon: Icons.history_rounded,
                  label: 'Terakhir Dipindah',
                  value: asset.lastMovedAt != null ? _formatDate(asset.lastMovedAt) : 'Belum Pernah Dipindah',
                ),
                _buildInfoItem(
                  icon: Icons.build_circle_outlined,
                  label: 'Total Perbaikan',
                  value: '${asset.totalRepairs} kali',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Section 3: Informasi Sistem
            _buildSectionCard(
              title: 'Informasi Sistem',
              icon: Icons.info_outline_rounded,
              children: [
                _buildInfoItem(
                  icon: Icons.fingerprint_rounded,
                  label: 'ID Sistem (UUID)',
                  value: asset.id,
                ),
                _buildInfoItem(
                  icon: Icons.event_available_rounded,
                  label: 'Tanggal Terdaftar',
                  value: _formatDate(asset.createdAt),
                ),
                _buildInfoItem(
                  icon: Icons.update_rounded,
                  label: 'Terakhir Diperbarui',
                  value: _formatDate(asset.updatedAt),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Bottom Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showFeatureNotAvailableDialog(
                        'Laporkan Kerusakan',
                        'Fitur pengajuan perbaikan / servis aset sedang dalam proses integrasi.',
                      );
                    },
                    icon: Icon(Icons.build_rounded, size: 18.sp),
                    label: Text('Perbaikan', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC3545),
                      side: const BorderSide(color: Color(0xFFDC3545)),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showFeatureNotAvailableDialog(
                        'Perpindahan Aset',
                        'Fitur formulir mutasi / pemindahan aset sedang dalam proses integrasi.',
                      );
                    },
                    icon: Icon(Icons.swap_horiz_rounded, size: 18.sp),
                    label: Text('Mutasi Aset', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.inputBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF28A745), size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: AppTheme.inputBorder.withValues(alpha: 0.5)),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.sp, color: AppTheme.textSecondary),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
