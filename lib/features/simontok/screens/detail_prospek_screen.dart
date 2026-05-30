import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:image_picker/image_picker.dart';

class DetailProspekScreen extends StatefulWidget {
  final String namaDebitur;
  const DetailProspekScreen({super.key, required this.namaDebitur});

  @override
  State<DetailProspekScreen> createState() => _DetailProspekScreenState();
}

class _DetailProspekScreenState extends State<DetailProspekScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Image state
  File? _capturedImage;
  File? _uploadedImage;
  bool _isPreviewExpanded = false;

  // Form controllers
  final _calonDebiturController = TextEditingController();
  final _nomorTelpController = TextEditingController(text: '081324743443');
  final _keteranganController = TextEditingController(text: 'Closing 100jt');

  // Dropdown values
  String? _selectedJenis = 'Prospek';
  String? _selectedStatus = 'Proses';

  final List<String> _jenisOptions = [
    'Prospek',
    'Survey',
    'Lainnya',
  ];

  final List<String> _statusOptions = [
    'Proses',
    'Berhasil',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
    _calonDebiturController.text = widget.namaDebitur;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _calonDebiturController.dispose();
    _nomorTelpController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        title: const Text(
          'PROSPEK',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: _buildTabbedFormCard(),
      ),
    );
  }

  Widget _buildTabbedFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 18),
                        SizedBox(width: 6),
                        Text('Prospek'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 18),
                        SizedBox(width: 6),
                        Text('Foto'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 18),
                        SizedBox(width: 6),
                        Text('Upload'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildProspekForm();
      case 1:
        return _buildFotoContent();
      case 2:
        return _buildUploadContent();
      default:
        return _buildProspekForm();
    }
  }

  Widget _buildProspekForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Jenis',
          value: _selectedJenis,
          items: _jenisOptions,
          onChanged: (value) => setState(() => _selectedJenis = value),
        ),
        _buildDropdownField(
          label: 'Status',
          value: _selectedStatus,
          items: _statusOptions,
          onChanged: (value) => setState(() => _selectedStatus = value),
        ),
        _buildFormField(
          label: 'Calon Debitur',
          controller: _calonDebiturController,
        ),
        _buildFormField(
          label: 'Nomor Telp',
          controller: _nomorTelpController,
          keyboardType: TextInputType.phone,
        ),
        _buildFormField(
          label: 'Keterangan',
          controller: _keteranganController,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        // SIMPAN Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prospek berhasil disimpan')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'SIMPAN',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Shared form widgets ──

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
            color: AppTheme.primaryColor.withOpacity(0.7),
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
            color: AppTheme.textPrimary.withOpacity(0.5),
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
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
            color: AppTheme.primaryColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
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

  // ── Foto tab ──

  Widget _buildFotoContent() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: _capturedImage != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_capturedImage!, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => _capturedImage = null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_rounded,
                          size: 56, color: Colors.white.withOpacity(0.6)),
                      const SizedBox(height: 8),
                      Text('Preview Kamera',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => _takePhoto(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('AMBIL GAMBAR',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1)),
          ),
        ),
      ],
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 85,
    );
    if (photo != null) {
      setState(() => _capturedImage = File(photo.path));
    }
  }

  // ── Upload tab ──

  Widget _buildUploadContent() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.textSecondary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: _uploadedImage != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child:
                            Image.file(_uploadedImage!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _uploadedImage = null),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_circle_up_outlined,
                            size: 48,
                            color:
                                AppTheme.textSecondary.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        Text('Upload a Photo',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary
                                    .withOpacity(0.5))),
                      ],
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => _pickImage(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('UPLOAD',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 12),
        // Preview Foto expandable
        GestureDetector(
          onTap: () => setState(() => _isPreviewExpanded = !_isPreviewExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Preview Foto',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isPreviewExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isPreviewExpanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _uploadedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_uploadedImage!, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Belum ada foto yang diupload',
                        style: TextStyle(
                            fontSize: 14, color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
          ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 720,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _uploadedImage = File(image.path));
    }
  }
}
