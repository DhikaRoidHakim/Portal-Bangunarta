import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bangunarta_portal/core/theme/theme.dart';

class OpenAccountScreen extends StatefulWidget {
  const OpenAccountScreen({super.key});

  @override
  State<OpenAccountScreen> createState() => _OpenAccountScreenState();
}

class _OpenAccountScreenState extends State<OpenAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _tujuanController = TextEditingController();
  final _warisNamaController = TextEditingController();
  final _warisHubunganController = TextEditingController();

  // Dropdown values
  String? _selectedKantor;
  String? _selectedKodeProduk;

  // Image state
  XFile? _ktpImage;
  final ImagePicker _picker = ImagePicker();

  // Signature state
  final List<List<Offset>> _signatureStrokes = [];
  List<Offset> _currentStroke = [];
  bool _isSignatureEmpty = true;

  // Dummy data untuk data kantor & produk
  final List<Map<String, String>> _kantorOptions = [
    {'value': '01', 'label': 'Kantor Pusat Pamanukan'},
    {'value': '02', 'label': 'Kantor Kas Subang'},
    {'value': '03', 'label': 'Kantor Kas Pagaden'},
  ];

  final List<Map<String, String>> _kodeProdukOptions = [
    {'value': '01', 'label': 'Simapan'},
    {'value': '02', 'label': 'Simantap'},
    {'value': '03', 'label': 'Simabrur'},
  ];

  @override
  void dispose() {
    _tujuanController.dispose();
    _warisNamaController.dispose();
    _warisHubunganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            _buildHeader(),
            const SizedBox(height: 20),

            // ── Form Card ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Data Rekening
                  _buildSectionTitle('DATA REKENING'),
                  const SizedBox(height: 20),

                  _buildDropdownField(
                    label: 'Kantor',
                    hint: 'Pilih kantor',
                    value: _selectedKantor,
                    items: _kantorOptions,
                    icon: Icons.business_outlined,
                    onChanged: (value) {
                      setState(() => _selectedKantor = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownField(
                    label: 'Kode Produk',
                    hint: 'Pilih produk tabungan',
                    value: _selectedKodeProduk,
                    items: _kodeProdukOptions,
                    icon: Icons.inventory_2_outlined,
                    onChanged: (value) {
                      setState(() => _selectedKodeProduk = value);
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: 'Tujuan',
                    hint: 'Masukkan tujuan pembukaan rekening',
                    controller: _tujuanController,
                    icon: Icons.flag_outlined,
                  ),

                  const SizedBox(height: 28),
                  _buildDividerWithLabel('AHLI WARIS'),
                  const SizedBox(height: 20),

                  _buildTextField(
                    label: 'Nama Ahli Waris',
                    hint: 'Masukkan nama ahli waris',
                    controller: _warisNamaController,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: 'Hubungan',
                    hint: 'Contoh: Suami, Istri, Anak, dsb.',
                    controller: _warisHubunganController,
                    icon: Icons.people_outline,
                  ),

                  const SizedBox(height: 28),
                  _buildDividerWithLabel('DOKUMEN'),
                  const SizedBox(height: 20),

                  // KTP Upload
                  _buildKtpUploadSection(),
                  const SizedBox(height: 24),

                  // Signature Canvas
                  _buildSignatureSection(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Submit Button ───────────────────────────
            _buildSubmitButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  HEADER
  // ═══════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'FORMULIR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Buka Rekening',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF28A745),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF28A745).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: const [
              Icon(
                Icons.add_card_outlined,
                color: AppTheme.surfaceWhite,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Tabungan Baru',
                style: TextStyle(
                  color: AppTheme.surfaceWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  SECTION TITLE
  // ═══════════════════════════════════════════════════════

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary.withValues(alpha: 0.7),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  DIVIDER WITH LABEL
  // ═══════════════════════════════════════════════════════

  Widget _buildDividerWithLabel(String label) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppTheme.inputBorder, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Divider(color: AppTheme.inputBorder, thickness: 1),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  DROPDOWN FIELD
  // ═══════════════════════════════════════════════════════

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<Map<String, String>> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.secondaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.inputBorder),
            color: AppTheme.surfaceWhite,
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textSecondary,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                color: AppTheme.textLightBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
            dropdownColor: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(12),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w500,
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item['value'],
                    child: Text(item['label']!),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label wajib dipilih';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  TEXT FIELD
  // ═══════════════════════════════════════════════════════

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppTheme.secondaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF334155),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppTheme.textLightBlue,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines > 1 ? 14 : 12,
            ),
            filled: true,
            fillColor: AppTheme.surfaceWhite,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.inputBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppTheme.secondaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  KTP UPLOAD SECTION
  // ═══════════════════════════════════════════════════════

  Widget _buildKtpUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.badge_outlined,
              size: 16,
              color: AppTheme.secondaryColor,
            ),
            SizedBox(width: 6),
            Text(
              'Foto KTP',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickKtpImage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: _ktpImage != null ? null : 160,
            decoration: BoxDecoration(
              color: _ktpImage != null
                  ? AppTheme.surfaceWhite
                  : AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _ktpImage != null
                    ? AppTheme.secondaryColor.withValues(alpha: 0.3)
                    : AppTheme.inputBorder,
                width: _ktpImage != null ? 1.5 : 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: _ktpImage != null
                ? _buildKtpPreview()
                : _buildKtpPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildKtpPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.add_a_photo_outlined,
            color: AppTheme.secondaryColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tap untuk upload foto KTP',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Kamera atau Galeri • JPG, PNG',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildKtpPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: FutureBuilder<Uint8List>(
            future: _ktpImage!.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                );
              }
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
        // Overlay gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ),
        // Actions
        Positioned(
          bottom: 10,
          right: 10,
          child: Row(
            children: [
              _buildImageActionButton(
                icon: Icons.refresh_rounded,
                label: 'Ganti',
                onTap: _pickKtpImage,
              ),
              const SizedBox(width: 8),
              _buildImageActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Hapus',
                color: Colors.red,
                onTap: () => setState(() => _ktpImage = null),
              ),
            ],
          ),
        ),
        // Success badge
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF28A745),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'KTP Terupload',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  SIGNATURE CANVAS SECTION
  // ═══════════════════════════════════════════════════════

  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.draw_outlined,
                  size: 16,
                  color: AppTheme.secondaryColor,
                ),
                SizedBox(width: 6),
                Text(
                  'Tanda Tangan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (!_isSignatureEmpty)
              GestureDetector(
                onTap: _clearSignature,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.refresh_rounded, color: Colors.red, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Ulangi',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: !_isSignatureEmpty
                  ? AppTheme.secondaryColor.withValues(alpha: 0.3)
                  : AppTheme.inputBorder,
              width: !_isSignatureEmpty ? 1.5 : 1,
            ),
          ),
          child: Stack(
            children: [
              // Background guide text
              if (_isSignatureEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.gesture,
                        size: 40,
                        color: AppTheme.textSecondary.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tanda tangan di sini',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Gunakan jari untuk menggambar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondary.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),

              // Canvas
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _currentStroke = [details.localPosition];
                      _isSignatureEmpty = false;
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _currentStroke = [
                        ..._currentStroke,
                        details.localPosition,
                      ];
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _signatureStrokes.add(_currentStroke);
                      _currentStroke = [];
                    });
                  },
                  child: CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _SignaturePainter(
                      strokes: _signatureStrokes,
                      currentStroke: _currentStroke,
                    ),
                  ),
                ),
              ),

              // Bottom signature line
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: Container(
                  height: 1,
                  color: AppTheme.textSecondary.withValues(alpha: 0.15),
                ),
              ),
              Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Tanda Tangan di Atas Garis',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary.withValues(alpha: 0.4),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  SUBMIT BUTTON
  // ═══════════════════════════════════════════════════════

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: AppTheme.surfaceWhite,
          disabledBackgroundColor: AppTheme.secondaryColor.withValues(
            alpha: 0.6,
          ),
          disabledForegroundColor: AppTheme.surfaceWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: AppTheme.secondaryColor.withValues(alpha: 0.3),
        ),
        child: _isSubmitting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Mengirim...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save_outlined, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Simpan & Ajukan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  ACTIONS
  // ═══════════════════════════════════════════════════════

  Future<void> _pickKtpImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Foto KTP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih sumber gambar',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library_outlined,
                      label: 'Galeri',
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
      );
      if (image != null) {
        setState(() => _ktpImage = image);
      }
    }
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppTheme.secondaryColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearSignature() {
    setState(() {
      _signatureStrokes.clear();
      _currentStroke = [];
      _isSignatureEmpty = true;
    });
  }

  /// Converts the signature canvas strokes into a PNG image as [Uint8List].
  ///
  /// The resulting image has a transparent background with the signature
  /// drawn in [AppTheme.primaryColor]. Returns `null` if the signature is empty.
  ///
  /// [width] and [height] control the output image dimensions.
  Future<Uint8List?> _getSignatureBytes({
    double width = 600,
    double height = 300,
  }) async {
    if (_isSignatureEmpty || _signatureStrokes.isEmpty) return null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Re-draw all strokes onto the recording canvas
    for (final stroke in _signatureStrokes) {
      if (stroke.length < 2) {
        if (stroke.isNotEmpty) {
          canvas.drawCircle(stroke.first, paint.strokeWidth / 2, paint);
        }
        continue;
      }

      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);

      for (int i = 1; i < stroke.length; i++) {
        final mid = Offset(
          (stroke[i - 1].dx + stroke[i].dx) / 2,
          (stroke[i - 1].dy + stroke[i].dy) / 2,
        );
        path.quadraticBezierTo(
          stroke[i - 1].dx,
          stroke[i - 1].dy,
          mid.dx,
          mid.dy,
        );
      }

      canvas.drawPath(path, paint);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    return byteData?.buffer.asUint8List();
  }

  bool _isSubmitting = false;

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar(
        'Mohon lengkapi semua field yang wajib diisi',
        isError: true,
      );
      return;
    }

    if (_ktpImage == null) {
      _showSnackBar('Mohon upload foto KTP terlebih dahulu', isError: true);
      return;
    }

    if (_isSignatureEmpty) {
      _showSnackBar('Mohon isi tanda tangan terlebih dahulu', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Convert signature canvas to PNG bytes
      final signatureBytes = await _getSignatureBytes();
      if (signatureBytes == null) {
        _showSnackBar('Gagal memproses tanda tangan', isError: true);
        return;
      }

      // Read KTP image bytes
      final ktpBytes = await _ktpImage!.readAsBytes();

      // TODO: Kirim ke backend via API service

      debugPrint('KTP size: ${ktpBytes.length} bytes');
      debugPrint('Signature size: ${signatureBytes.length} bytes');

      _showSnackBar('Pengajuan rekening berhasil dikirim!');
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : const Color(0xFF28A745),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  SIGNATURE PAINTER
// ═══════════════════════════════════════════════════════════

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  _SignaturePainter({required this.strokes, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }

    // Draw current stroke being drawn
    if (currentStroke.isNotEmpty) {
      _drawStroke(canvas, currentStroke, paint);
    }
  }

  void _drawStroke(Canvas canvas, List<Offset> stroke, Paint paint) {
    if (stroke.length < 2) {
      if (stroke.isNotEmpty) {
        canvas.drawCircle(stroke.first, paint.strokeWidth / 2, paint);
      }
      return;
    }

    final path = Path();
    path.moveTo(stroke.first.dx, stroke.first.dy);

    for (int i = 1; i < stroke.length; i++) {
      // Smooth curve using quadratic bezier
      final mid = Offset(
        (stroke[i - 1].dx + stroke[i].dx) / 2,
        (stroke[i - 1].dy + stroke[i].dy) / 2,
      );
      path.quadraticBezierTo(
        stroke[i - 1].dx,
        stroke[i - 1].dy,
        mid.dx,
        mid.dy,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
