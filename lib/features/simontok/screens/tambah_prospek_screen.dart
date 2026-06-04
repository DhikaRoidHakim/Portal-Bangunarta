import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_provider.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_repository.dart';
import 'package:bangunarta_portal/models/simontok/list_prospek_model.dart';
import 'package:image_picker/image_picker.dart';

class TambahProspekScreen extends ConsumerStatefulWidget {
  final ProspekModel? prospek;
  const TambahProspekScreen({super.key, this.prospek});

  @override
  ConsumerState<TambahProspekScreen> createState() => _TambahProspekScreenState();
}

class _TambahProspekScreenState extends ConsumerState<TambahProspekScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _selectedImage;

  // Controllers
  late final TextEditingController _namaLengkapController;
  late final TextEditingController _nomorHpController;
  late final TextEditingController _keteranganController;

  // Selected values
  String? _selectedJenis = 'Survey';
  String? _selectedStatus = 'Selesai';

  final List<String> _jenisOptions = ['Survey', 'Prospek'];
  final List<String> _statusOptions = ['Selesai', 'Proses'];

  @override
  void initState() {
    super.initState();
    _namaLengkapController = TextEditingController(
      text: widget.prospek?.namaLengkap ?? '',
    );
    _nomorHpController = TextEditingController(
      text: widget.prospek?.nomorHp ?? '',
    );
    _keteranganController = TextEditingController(
      text: widget.prospek?.keterangan ?? '',
    );
    if (widget.prospek != null) {
      if (_jenisOptions.contains(widget.prospek!.jenis)) {
        _selectedJenis = widget.prospek!.jenis;
      }
      if (_statusOptions.contains(widget.prospek!.status)) {
        _selectedStatus = widget.prospek!.status;
      }
    }
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _nomorHpController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  Future<void> _submitProspek() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.prospek == null && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto prospek wajib dilampirkan'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final authState = ref.read(authProvider);
    final alias = authState.user?.user.alias;

    if (alias == null || alias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alias user tidak ditemukan. Silakan login kembali.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.prospek != null) {
        await SimontokRepository.instance.updateProspekReport(
          id: widget.prospek!.id,
          alias: alias,
          jenisProspek: _selectedJenis ?? 'Survey',
          namaLengkap: _namaLengkapController.text.trim(),
          nomorHp: _nomorHpController.text.trim(),
          keterangan: _keteranganController.text.trim(),
          statusProspek: _selectedStatus ?? 'Selesai',
          fotoProspek: _selectedImage,
        );
      } else {
        await SimontokRepository.instance.submitProspekReport(
          alias: alias,
          jenisProspek: _selectedJenis ?? 'Survey',
          namaLengkap: _namaLengkapController.text.trim(),
          nomorHp: _nomorHpController.text.trim(),
          keterangan: _keteranganController.text.trim(),
          statusProspek: _selectedStatus ?? 'Selesai',
          fotoProspek: _selectedImage!,
        );
      }

      if (mounted) {
        // Refresh the Prospek list
        ref.invalidate(listProspekProvider);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Berhasil'),
              ],
            ),
            content: Text(widget.prospek != null
                ? 'Perubahan data prospek berhasil disimpan.'
                : 'Data prospek berhasil disimpan.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Pop dialog
                  Navigator.pop(context); // Pop screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.redAccent, size: 28),
                SizedBox(width: 8),
                Text('Gagal'),
              ],
            ),
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            centerTitle: true,
            title: Text(
              widget.prospek != null ? 'EDIT PROSPEK' : 'TAMBAH PROSPEK',
              style: const TextStyle(
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
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
                        _buildDropdownField(
                          label: 'Jenis Prospek',
                          value: _selectedJenis,
                          items: _jenisOptions,
                          onChanged: (value) => setState(() => _selectedJenis = value),
                        ),
                        _buildFormField(
                          label: 'Nama Lengkap',
                          controller: _namaLengkapController,
                          validator: (val) => _requiredValidator(val, 'Nama Lengkap'),
                        ),
                        _buildFormField(
                          label: 'Nomor HP',
                          controller: _nomorHpController,
                          keyboardType: TextInputType.phone,
                          validator: (val) => _requiredValidator(val, 'Nomor HP'),
                        ),
                        _buildFormField(
                          label: 'Keterangan',
                          controller: _keteranganController,
                          maxLines: 3,
                          validator: (val) => _requiredValidator(val, 'Keterangan'),
                        ),
                        _buildDropdownField(
                          label: 'Status Prospek',
                          value: _selectedStatus,
                          items: _statusOptions,
                          onChanged: (value) => setState(() => _selectedStatus = value),
                        ),
                        const SizedBox(height: 8),
                        _buildPhotoPicker(),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submitProspek,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.prospek != null ? 'SIMPAN PERUBAHAN' : 'SIMPAN',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          keyboardType: keyboardType,
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
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
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(
            hint ?? 'Pilih $label',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.textPrimary.withValues(alpha: 0.5),
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey.shade200, height: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhotoPicker() {
    final String? serverFoto = widget.prospek?.foto;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Prospek *',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedImage = null),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          )
        else if (serverFoto != null && serverFoto.isNotEmpty)
          Column(
            children: [
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
                    '${ApiEndpoints.baseUrl}/storage/simontok/prospek/$serverFoto',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Foto saat ini: $serverFoto\n(Gagal memuat dari server)',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, size: 16),
                    label: const Text('Ganti Kamera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.image, size: 16),
                    label: const Text('Ganti Galeri'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'Silakan ambil atau unggah foto prospek',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 16),
                      label: const Text('Kamera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.image, size: 16),
                      label: const Text('Galeri'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
