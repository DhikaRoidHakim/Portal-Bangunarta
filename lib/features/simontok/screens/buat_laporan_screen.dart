import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';
import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_tugas_model.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_provider.dart';
import 'package:bangunarta_portal/features/simontok/providers/simontok_repository.dart';
import 'package:image_picker/image_picker.dart';

class BuatLaporanScreen extends ConsumerStatefulWidget {
  final TugasModel task;
  const BuatLaporanScreen({super.key, required this.task});

  @override
  ConsumerState<BuatLaporanScreen> createState() => _BuatLaporanScreenState();
}

class _BuatLaporanScreenState extends ConsumerState<BuatLaporanScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _selectedImage;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // Verifikasi sub tipe (Pinjaman / Jaminan)
  String _verifikasiType = 'Pinjaman';
  DetailCollateralModel? _selectedCollateral;
  List<DetailCollateralModel> _collaterals = [];

  // Controler untuk form Penagihan
  late final TextEditingController _keteranganPelaksanaanController;
  late final TextEditingController _keteranganHasilController;
  late final TextEditingController _janjiBayarController;
  String? _selectedHasil = 'Lainnya';
  String? _selectedPelaksanaan = 'Penagihan Kredit';
  String? _selectedKlasifikasi;

  // Controller untuk form Verifikasi Pinjaman
  late final TextEditingController _penggunaKreditController;
  late final TextEditingController _penggunaanKreditController;
  late final TextEditingController _alamatDebiturController;
  late final TextEditingController _caraPembayaranController;
  late final TextEditingController _pekerjaanDebiturController;
  late final TextEditingController _karakterDebiturController;
  late final TextEditingController _nomorDebiturController;
  late final TextEditingController _nomorPendampingController;

  // Controller untuk form Verifikasi Jaminan
  late final TextEditingController _kondisiJaminanController;
  late final TextEditingController _penguasaanJaminanController;

  // list select form hasil
  final List<String> _hasilOptions = [
    'Bayar Full',
    'Bayar Sebagian',
    'Janji Bayar',
    'Tidak Bayar',
    'Top Up Kredit',
    'Lainnya',
  ];

  final List<String> _pelaksanaanOptions = [
    'Penagihan Kredit',
    'Prospek Kredit',
  ];

  final Map<String, IconData> _hasilIcons = {
    'Bayar Full': Icons.check_circle_outline,
    'Bayar Sebagian': Icons.pie_chart_outline,
    'Janji Bayar': Icons.schedule_outlined,
    'Tidak Bayar': Icons.cancel_outlined,
    'Top Up Kredit': Icons.trending_up_outlined,
    'Lainnya': Icons.more_horiz,
  };

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    _keteranganPelaksanaanController = TextEditingController(
      text: widget.task.pelaksanaanDetail,
    );
    _keteranganHasilController = TextEditingController(
      text: widget.task.hasilDetail,
    );
    _janjiBayarController = TextEditingController(text: widget.task.janjiBayar);

    // Inisialisasi select values
    if (widget.task.pelaksanaan != null &&
        widget.task.pelaksanaan!.isNotEmpty) {
      _selectedPelaksanaan = widget.task.pelaksanaan;
    }
    if (widget.task.hasil != null && widget.task.hasil!.isNotEmpty) {
      _selectedHasil = widget.task.hasil;
    }
    if (widget.task.klasifikasi != null &&
        widget.task.klasifikasi!.isNotEmpty) {
      _selectedKlasifikasi = widget.task.klasifikasi;
    }

    // Inisialisasi sub-type
    if (widget.task.pelaksanaan != null &&
        widget.task.pelaksanaan!.toLowerCase().contains('jaminan')) {
      _verifikasiType = 'Jaminan';
    }

    // Inisialisasi verifikasi pinjaman
    _penggunaKreditController = TextEditingController();
    _penggunaanKreditController = TextEditingController();
    _alamatDebiturController = TextEditingController();
    _caraPembayaranController = TextEditingController();
    _pekerjaanDebiturController = TextEditingController();
    _karakterDebiturController = TextEditingController();
    _nomorDebiturController = TextEditingController();
    _nomorPendampingController = TextEditingController();

    // Inisialisasi verifikasi jaminan
    _kondisiJaminanController = TextEditingController();
    _penguasaanJaminanController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cached = ref.read(detailTugasProvider(widget.task.id)).value;
        if (cached != null) {
          _populateControllers(cached.data.task, cached.data.collaterals);
        }
      }
    });
  }

  void _populateControllers(
      DetailTaskModel taskDetail, List<DetailCollateralModel> colls) {
    if (taskDetail.penggunaKredit != null &&
        _penggunaKreditController.text.isEmpty) {
      _penggunaKreditController.text = taskDetail.penggunaKredit!;
    }
    if (taskDetail.penggunaanKredit != null &&
        _penggunaanKreditController.text.isEmpty) {
      _penggunaanKreditController.text = taskDetail.penggunaanKredit!;
    }
    if (taskDetail.alamatDebitur != null &&
        _alamatDebiturController.text.isEmpty) {
      _alamatDebiturController.text = taskDetail.alamatDebitur!;
    }
    if (taskDetail.caraPembayaran != null &&
        _caraPembayaranController.text.isEmpty) {
      _caraPembayaranController.text = taskDetail.caraPembayaran!;
    }
    if (taskDetail.pekerjaanDebitur != null &&
        _pekerjaanDebiturController.text.isEmpty) {
      _pekerjaanDebiturController.text = taskDetail.pekerjaanDebitur!;
    }
    if (taskDetail.karakterDebitur != null &&
        _karakterDebiturController.text.isEmpty) {
      _karakterDebiturController.text = taskDetail.karakterDebitur!;
    }
    if (taskDetail.nomorDebitur != null &&
        _nomorDebiturController.text.isEmpty) {
      _nomorDebiturController.text = taskDetail.nomorDebitur!;
    }
    if (taskDetail.nomorPendamping != null &&
        _nomorPendampingController.text.isEmpty) {
      _nomorPendampingController.text = taskDetail.nomorPendamping!;
    }

    if (taskDetail.pelaksanaanDetail != null &&
        _keteranganPelaksanaanController.text.isEmpty) {
      _keteranganPelaksanaanController.text = taskDetail.pelaksanaanDetail!;
    }
    if (taskDetail.hasilDetail != null &&
        _keteranganHasilController.text.isEmpty) {
      _keteranganHasilController.text = taskDetail.hasilDetail!;
    }
    if (taskDetail.janjiBayar != null && _janjiBayarController.text.isEmpty) {
      _janjiBayarController.text = taskDetail.janjiBayar!;
    }

    if (taskDetail.pelaksanaan != null &&
        (_selectedPelaksanaan == null ||
            _selectedPelaksanaan == 'Penagihan Kredit')) {
      setState(() {
        _selectedPelaksanaan = taskDetail.pelaksanaan;
      });
    }
    if (taskDetail.hasil != null &&
        (_selectedHasil == null || _selectedHasil == 'Lainnya')) {
      setState(() {
        _selectedHasil = taskDetail.hasil;
      });
    }
    if (taskDetail.klasifikasi != null && _selectedKlasifikasi == null) {
      setState(() {
        _selectedKlasifikasi = taskDetail.klasifikasi;
      });
    }

    if (taskDetail.pelaksanaan != null &&
        taskDetail.pelaksanaan!.toLowerCase().contains('jaminan')) {
      setState(() {
        _verifikasiType = 'Jaminan';
      });
    }

    setState(() {
      _collaterals = colls;
      if (_selectedCollateral == null && colls.isNotEmpty) {
        _selectedCollateral = colls.first;
        _kondisiJaminanController.text =
            _selectedCollateral!.kondisiAgunan ?? '';
        _penguasaanJaminanController.text =
            _selectedCollateral!.penguasaanAgunan ?? '';
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _keteranganPelaksanaanController.dispose();
    _keteranganHasilController.dispose();
    _janjiBayarController.dispose();

    _penggunaKreditController.dispose();
    _penggunaanKreditController.dispose();
    _alamatDebiturController.dispose();
    _caraPembayaranController.dispose();
    _pekerjaanDebiturController.dispose();
    _karakterDebiturController.dispose();
    _nomorDebiturController.dispose();
    _nomorPendampingController.dispose();

    _kondisiJaminanController.dispose();
    _penguasaanJaminanController.dispose();
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

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final detailTugas =
        ref.read(detailTugasProvider(widget.task.id)).value?.data.task ??
            DetailTaskModel.fromTugasModel(widget.task);
    final isPenagihan = detailTugas.jenis == 'Penagihan' ||
        detailTugas.jenis == 'Prospek' ||
        detailTugas.jenis == 'Telebiling' ||
        detailTugas.jenis == 'Telebilling';
    final showPhotoPicker = isPenagihan || _verifikasiType == 'Pinjaman';

    if (showPhotoPicker &&
        _selectedImage == null &&
        (detailTugas.foto == null || detailTugas.foto!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Foto penanganan wajib dilampirkan'),
            ],
          ),
          backgroundColor: Colors.redAccent.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (isPenagihan) {
        await SimontokRepository.instance.submitPenagihanReport(
          taskId: detailTugas.id,
          pelaksanaan: _selectedPelaksanaan ?? 'Penagihan Kredit',
          keteranganPelaksanaan: _keteranganPelaksanaanController.text.trim(),
          hasilPelaksanaan: _selectedHasil ?? 'Lainnya',
          keteranganHasil: _keteranganHasilController.text.trim(),
          janjiBayar: _janjiBayarController.text.trim(),
          fotoPenanganan: _selectedImage,
          klasifikasi: _selectedKlasifikasi ?? '',
        );
      } else if (_verifikasiType == 'Pinjaman') {
        await SimontokRepository.instance.submitVerifikasiReport(
          taskId: detailTugas.id,
          penggunaKredit: _penggunaKreditController.text.trim(),
          penggunaanKredit: _penggunaanKreditController.text.trim(),
          alamatDebitur: _alamatDebiturController.text.trim(),
          caraPembayaran: _caraPembayaranController.text.trim(),
          pekerjaanDebitur: _pekerjaanDebiturController.text.trim(),
          karakterDebitur: _karakterDebiturController.text.trim(),
          nomorDebitur: _nomorDebiturController.text.trim(),
          nomorPendamping: _nomorPendampingController.text.trim(),
          fotoPenanganan: _selectedImage,
          klasifikasi: _selectedKlasifikasi ?? '',
        );
      } else {
        await SimontokRepository.instance.submitVerifikasiJaminanReport(
          nomorAgunan: _selectedCollateral?.nomorAgunan ?? '',
          kondisiJaminan: _kondisiJaminanController.text.trim(),
          penguasaanJaminan: _penguasaanJaminanController.text.trim(),
        );
      }

      if (mounted) {
        ref.invalidate(listTugasProvider);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF4CAF50),
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Laporan Terkirim!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Laporan penanganan berhasil dikirim.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_rounded,
                  color: Colors.redAccent,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gagal Mengirim',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<DetailTugasModel>>(
      detailTugasProvider(widget.task.id),
      (previous, next) {
        if (next.hasValue && next.value != null) {
          _populateControllers(
              next.value!.data.task, next.value!.data.collaterals);
        }
      },
    );

    final isPenagihan = widget.task.jenis == 'Penagihan' ||
        widget.task.jenis == 'Prospek' ||
        widget.task.jenis == 'Telebiling' ||
        widget.task.jenis == 'Telebilling';

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: _buildAppBar(),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildDebiturInfoCard(),
                    const SizedBox(height: 16),
                    _buildFormCard(isPenagihan),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Mengirim laporan...',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, Color(0xFF1565C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'BUAT LAPORAN',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            widget.task.jenis?.toUpperCase() ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 16,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildFormCard(bool isPenagihan) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Laporan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Isi semua informasi dengan benar',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isPenagihan) ...[_buildVerifikasiTypeSelector()],
                if (isPenagihan) ...[
                  _buildDropdownField(
                    label: 'Pelaksanaan',
                    icon: Icons.work_outline,
                    value: _selectedPelaksanaan,
                    items: _pelaksanaanOptions,
                    onChanged: (value) =>
                        setState(() => _selectedPelaksanaan = value),
                  ),
                  _buildFormField(
                    label: 'Keterangan Pelaksanaan',
                    icon: Icons.notes_outlined,
                    controller: _keteranganPelaksanaanController,
                    maxLines: 3,
                    validator: (val) =>
                        _requiredValidator(val, 'Keterangan Pelaksanaan'),
                  ),
                  _buildDropdownField(
                    label: 'Hasil Pelaksanaan',
                    icon: Icons.flag_outlined,
                    value: _selectedHasil,
                    items: _hasilOptions,
                    onChanged: (value) =>
                        setState(() => _selectedHasil = value),
                  ),
                  _buildFormField(
                    label: 'Keterangan Hasil',
                    icon: Icons.description_outlined,
                    controller: _keteranganHasilController,
                    maxLines: 3,
                    validator: (val) =>
                        _requiredValidator(val, 'Keterangan Hasil'),
                  ),
                  _buildDateField(
                    label: 'Janji Bayar (Optional)',
                    controller: _janjiBayarController,
                  ),
                  _buildKlasifikasiDropdown(),
                ] else if (_verifikasiType == 'Pinjaman') ...[
                  _buildFormField(
                    label: 'Pengguna Kredit',
                    icon: Icons.person_outline,
                    controller: _penggunaKreditController,
                    validator: (val) =>
                        _requiredValidator(val, 'Pengguna Kredit'),
                  ),
                  _buildFormField(
                    label: 'Penggunaan Kredit',
                    icon: Icons.account_balance_wallet_outlined,
                    controller: _penggunaanKreditController,
                    validator: (val) =>
                        _requiredValidator(val, 'Penggunaan Kredit'),
                  ),
                  _buildFormField(
                    label: 'Alamat Debitur',
                    icon: Icons.location_on_outlined,
                    controller: _alamatDebiturController,
                    maxLines: 2,
                    validator: (val) =>
                        _requiredValidator(val, 'Alamat Debitur'),
                  ),
                  _buildFormField(
                    label: 'Cara Pembayaran',
                    icon: Icons.payments_outlined,
                    controller: _caraPembayaranController,
                    validator: (val) =>
                        _requiredValidator(val, 'Cara Pembayaran'),
                  ),
                  _buildFormField(
                    label: 'Pekerjaan Debitur',
                    icon: Icons.business_center_outlined,
                    controller: _pekerjaanDebiturController,
                    validator: (val) =>
                        _requiredValidator(val, 'Pekerjaan Debitur'),
                  ),
                  _buildFormField(
                    label: 'Karakter Debitur',
                    icon: Icons.psychology_outlined,
                    controller: _karakterDebiturController,
                    maxLines: 2,
                    validator: (val) =>
                        _requiredValidator(val, 'Karakter Debitur'),
                  ),
                  _buildFormField(
                    label: 'Nomor Debitur',
                    icon: Icons.phone_outlined,
                    controller: _nomorDebiturController,
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        _requiredValidator(val, 'Nomor Debitur'),
                  ),
                  _buildFormField(
                    label: 'Nomor Pendamping',
                    icon: Icons.phone_in_talk_outlined,
                    controller: _nomorPendampingController,
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        _requiredValidator(val, 'Nomor Pendamping'),
                  ),
                  _buildKlasifikasiDropdown(),
                ] else ...[
                  if (_collaterals.isNotEmpty) ...[
                    _buildDropdownFieldGeneric<DetailCollateralModel>(
                      label: 'Pilih Jaminan/Agunan',
                      icon: Icons.home_work_outlined,
                      value: _selectedCollateral,
                      items: _collaterals,
                      itemAsString: (col) =>
                          '${col.nomorAgunan ?? "-"} | ${col.namaAgunan}',
                      onChanged: (col) {
                        setState(() {
                          _selectedCollateral = col;
                          if (col != null) {
                            _kondisiJaminanController.text =
                                col.kondisiAgunan ?? '';
                            _penguasaanJaminanController.text =
                                col.penguasaanAgunan ?? '';
                          }
                        });
                      },
                    ),
                  ],
                  _buildFormField(
                    label: 'Kondisi Jaminan',
                    icon: Icons.verified_outlined,
                    controller: _kondisiJaminanController,
                    maxLines: 2,
                    validator: (val) =>
                        _requiredValidator(val, 'Kondisi Jaminan'),
                  ),
                  _buildFormField(
                    label: 'Penguasaan Jaminan',
                    icon: Icons.lock_outline,
                    controller: _penguasaanJaminanController,
                    maxLines: 2,
                    validator: (val) =>
                        _requiredValidator(val, 'Penguasaan Jaminan'),
                  ),
                ],
                if (isPenagihan || _verifikasiType == 'Pinjaman') ...[
                  const SizedBox(height: 4),
                  _buildPhotoPicker(),
                  const SizedBox(height: 24),
                ] else ...[
                  const SizedBox(height: 8),
                ],
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifikasiTypeSelector() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          _buildTypeTab('Pinjaman', Icons.account_balance_outlined),
          _buildTypeTab('Jaminan', Icons.home_work_outlined),
        ],
      ),
    );
  }

  Widget _buildTypeTab(String type, IconData icon) {
    final isSelected = _verifikasiType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _verifikasiType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Verifikasi $type',
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebiturInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            const Color(0xFF1565C0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Debitur',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.7),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.task.namaLengkap,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nomor Rekening',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.7),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.task.nomorRekening ?? '-',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.label_outline,
                            size: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.task.jenis ?? '-',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
              height: 1.4,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(icon, size: 18, color: AppTheme.primaryColor.withValues(alpha: 0.6)),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              filled: true,
              fillColor: AppTheme.backgroundLight,
              hintText: 'Masukkan $label',
              hintStyle: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.8,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: items.contains(value) ? value : null,
            hint: Text(
              hint ?? 'Pilih $label',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Icon(
                      _hasilIcons[item] ?? Icons.circle,
                      size: 16,
                      color: AppTheme.primaryColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(icon, size: 18, color: AppTheme.primaryColor.withValues(alpha: 0.6)),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              filled: true,
              fillColor: AppTheme.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.8,
                ),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textPrimary.withValues(alpha: 0.4),
            ),
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  Widget _buildKlasifikasiDropdown() {
    final Map<String, String> klasifikasiMap = {
      'DM': 'Debitur Mudah',
      'DPP': 'Debitur Perlu Pengingat',
      'DS': 'Debitur Sulit',
      'DSS': 'Debitur Sangat Sulit',
      'DTT': 'Debitur Tidak Tertagih',
    };

    final Map<String, Color> klasifikasiColors = {
      'DM': const Color(0xFF4CAF50),
      'DPP': const Color(0xFF2196F3),
      'DS': const Color(0xFFFF9800),
      'DSS': const Color(0xFFFF5722),
      'DTT': const Color(0xFFF44336),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Klasifikasi Debitur',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue:
                const ['DM', 'DPP', 'DS', 'DSS', 'DTT'].contains(_selectedKlasifikasi)
                    ? _selectedKlasifikasi
                    : null,
            hint: Text(
              'Pilih Klasifikasi Debitur',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            items: klasifikasiMap.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: klasifikasiColors[entry.key],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${entry.key} — ${entry.value}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedKlasifikasi = val;
              });
            },
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Klasifikasi tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 18,
                  color: AppTheme.primaryColor.withValues(alpha: 0.6),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              filled: true,
              fillColor: AppTheme.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.8,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.2,
                ),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textPrimary.withValues(alpha: 0.4),
            ),
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFieldGeneric<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemAsString,
    required ValueChanged<T?> onChanged,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            initialValue: items.contains(value) ? value : null,
            hint: Text(
              hint ?? 'Pilih $label',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemAsString(item),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (val) {
              if (val == null) {
                return '$label tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(icon, size: 18, color: AppTheme.primaryColor.withValues(alpha: 0.6)),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              filled: true,
              fillColor: AppTheme.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.8,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.2,
                ),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textPrimary.withValues(alpha: 0.4),
            ),
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppTheme.primaryColor.withValues(alpha: 0.6),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                        color: AppTheme.textSecondary.withValues(alpha: 0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          controller.clear();
                        });
                      },
                    )
                  : Icon(
                      Icons.edit_calendar_outlined,
                      size: 18,
                      color: AppTheme.textSecondary.withValues(alpha: 0.5),
                    ),
              filled: true,
              fillColor: AppTheme.backgroundLight,
              hintText: 'Pilih tanggal (yyyy-mm-dd)',
              hintStyle: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 1.8,
                ),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPicker() {
    final detailTugasAsync = ref.watch(detailTugasProvider(widget.task.id));
    final fotoUrl = detailTugasAsync.value?.data.task.foto ?? widget.task.foto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 16,
              color: AppTheme.primaryColor.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 6),
            const Text(
              'Foto Penanganan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Wajib',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          _buildSelectedImagePreview()
        else if (fotoUrl != null && fotoUrl.isNotEmpty)
          _buildNetworkImagePreview(fotoUrl)
        else
          _buildEmptyPhotoState(),
      ],
    );
  }

  Widget _buildSelectedImagePreview() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            image: DecorationImage(
              image: FileImage(_selectedImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => setState(() => _selectedImage = null),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => _showImageSourcePicker(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, color: Colors.white, size: 13),
                  SizedBox(width: 4),
                  Text(
                    'Ganti',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImagePreview(String fotoUrl) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.inputBorder,
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.network(
                  fotoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.backgroundLight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 36,
                            color: AppTheme.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gagal memuat foto dari server',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => _showImageSourcePicker(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'Ganti Foto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyPhotoState() {
    return GestureDetector(
      onTap: _showImageSourcePicker,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.inputBorder,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                size: 28,
                color: AppTheme.primaryColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tambahkan Foto Penanganan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ketuk untuk mengambil foto dari kamera\natau unggah dari galeri',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPhotoActionChip(
                  icon: Icons.camera_alt_outlined,
                  label: 'Kamera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 12),
                _buildPhotoActionChip(
                  icon: Icons.photo_library_outlined,
                  label: 'Galeri',
                  onTap: () => _pickImage(ImageSource.gallery),
                  isOutlined: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.primaryColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isOutlined ? AppTheme.primaryColor : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isOutlined ? AppTheme.primaryColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pilih Sumber Foto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ambil foto dari kamera atau pilih dari galeri',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              _buildSourceOption(
                icon: Icons.camera_alt_rounded,
                title: 'Kamera',
                subtitle: 'Ambil foto secara langsung',
                color: AppTheme.primaryColor,
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              _buildSourceOption(
                icon: Icons.photo_library_rounded,
                title: 'Galeri',
                subtitle: 'Pilih foto dari galeri perangkat',
                color: const Color(0xFF1565C0),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: color.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ).copyWith(
          overlayColor: WidgetStateProperty.all(
            Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.send_rounded, size: 18),
            SizedBox(width: 8),
            Text(
              'KIRIM LAPORAN',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
