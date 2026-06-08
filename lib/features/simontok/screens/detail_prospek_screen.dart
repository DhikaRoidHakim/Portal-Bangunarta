import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_provider.dart';
import 'package:bangunarta_portal/models/simontok/detail_prospek_model.dart';

class DetailProspekScreen extends ConsumerStatefulWidget {
  final int prospekId;
  const DetailProspekScreen({super.key, required this.prospekId});

  @override
  ConsumerState<DetailProspekScreen> createState() => _DetailProspekScreenState();
}

class _DetailProspekScreenState extends ConsumerState<DetailProspekScreen> {
  // Form controllers (read-only)
  final _calonDebiturController = TextEditingController();
  final _nomorTelpController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _jenisController = TextEditingController();
  final _statusController = TextEditingController();

  bool _isInitialized = false;

  void _initializeFormValues(ProspekDetailData data) {
    if (_isInitialized) return;
    _calonDebiturController.text = data.namaLengkap;
    _nomorTelpController.text = data.nomorHp ?? '';
    _keteranganController.text = data.keterangan ?? '';
    _jenisController.text = data.jenis;
    _statusController.text = data.status;
    _isInitialized = true;
  }

  @override
  void dispose() {
    _calonDebiturController.dispose();
    _nomorTelpController.dispose();
    _keteranganController.dispose();
    _jenisController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(detailProspekProvider(widget.prospekId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        title: const Text(
          'DETAIL PROSPEK',
          style: TextStyle(
            color: AppTheme.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: detailAsync.when(
        data: (model) {
          _initializeFormValues(model.data);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: _buildDetailCard(model.data),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gagal Memuat Detail Prospek',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(detailProspekProvider(widget.prospekId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(ProspekDetailData data) {
    final hasServerImage = data.foto != null && data.foto!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: 'Jenis Prospek',
            controller: _jenisController,
          ),
          _buildFormField(
            label: 'Status Prospek',
            controller: _statusController,
          ),
          _buildFormField(
            label: 'Calon Debitur',
            controller: _calonDebiturController,
          ),
          _buildFormField(
            label: 'Nomor Telp',
            controller: _nomorTelpController,
          ),
          _buildFormField(
            label: 'Keterangan',
            controller: _keteranganController,
            maxLines: 4,
          ),
          if (hasServerImage) ...[
            const SizedBox(height: 8),
            Text(
              'Foto Prospek',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.network(
                  data.foto!.startsWith('http')
                      ? data.foto!
                      : '${ApiEndpoints.baseUrl}/storage/simontok/prospek/${data.foto!}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                          const SizedBox(height: 8),
                          const Text(
                            'Gagal memuat foto dari server',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: true,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey.shade200, height: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}
