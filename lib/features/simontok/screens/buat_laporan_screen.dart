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

class _BuatLaporanScreenState extends ConsumerState<BuatLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _selectedImage;

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

  @override
  void initState() {
    super.initState();

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

  void _populateControllers(DetailTaskModel taskDetail, List<DetailCollateralModel> colls) {
    if (taskDetail.penggunaKredit != null && _penggunaKreditController.text.isEmpty) {
      _penggunaKreditController.text = taskDetail.penggunaKredit!;
    }
    if (taskDetail.penggunaanKredit != null && _penggunaanKreditController.text.isEmpty) {
      _penggunaanKreditController.text = taskDetail.penggunaanKredit!;
    }
    if (taskDetail.alamatDebitur != null && _alamatDebiturController.text.isEmpty) {
      _alamatDebiturController.text = taskDetail.alamatDebitur!;
    }
    if (taskDetail.caraPembayaran != null && _caraPembayaranController.text.isEmpty) {
      _caraPembayaranController.text = taskDetail.caraPembayaran!;
    }
    if (taskDetail.pekerjaanDebitur != null && _pekerjaanDebiturController.text.isEmpty) {
      _pekerjaanDebiturController.text = taskDetail.pekerjaanDebitur!;
    }
    if (taskDetail.karakterDebitur != null && _karakterDebiturController.text.isEmpty) {
      _karakterDebiturController.text = taskDetail.karakterDebitur!;
    }
    if (taskDetail.nomorDebitur != null && _nomorDebiturController.text.isEmpty) {
      _nomorDebiturController.text = taskDetail.nomorDebitur!;
    }
    if (taskDetail.nomorPendamping != null && _nomorPendampingController.text.isEmpty) {
      _nomorPendampingController.text = taskDetail.nomorPendamping!;
    }

    if (taskDetail.pelaksanaanDetail != null && _keteranganPelaksanaanController.text.isEmpty) {
      _keteranganPelaksanaanController.text = taskDetail.pelaksanaanDetail!;
    }
    if (taskDetail.hasilDetail != null && _keteranganHasilController.text.isEmpty) {
      _keteranganHasilController.text = taskDetail.hasilDetail!;
    }
    if (taskDetail.janjiBayar != null && _janjiBayarController.text.isEmpty) {
      _janjiBayarController.text = taskDetail.janjiBayar!;
    }

    if (taskDetail.pelaksanaan != null && (_selectedPelaksanaan == null || _selectedPelaksanaan == 'Penagihan Kredit')) {
      setState(() {
        _selectedPelaksanaan = taskDetail.pelaksanaan;
      });
    }
    if (taskDetail.hasil != null && (_selectedHasil == null || _selectedHasil == 'Lainnya')) {
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
        _kondisiJaminanController.text = _selectedCollateral!.kondisiAgunan ?? '';
        _penguasaanJaminanController.text = _selectedCollateral!.penguasaanAgunan ?? '';
      }
    });
  }

  @override
  void dispose() {
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
    final isPenagihan = detailTugas.jenis == 'Penagihan';
    final showPhotoPicker = isPenagihan || _verifikasiType == 'Pinjaman';

    if (showPhotoPicker &&
        _selectedImage == null &&
        (detailTugas.foto == null || detailTugas.foto!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto penanganan wajib dilampirkan'),
          backgroundColor: Colors.redAccent,
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
            content: const Text('Laporan penanganan berhasil dikirim.'),
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
    ref.listen<AsyncValue<DetailTugasModel>>(
      detailTugasProvider(widget.task.id),
      (previous, next) {
        if (next.hasValue && next.value != null) {
          _populateControllers(next.value!.data.task, next.value!.data.collaterals);
        }
      },
    );

    final isPenagihan = widget.task.jenis == 'Penagihan';

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            centerTitle: true,
            title: Text(
              'BUAT LAPORAN ${widget.task.jenis?.toUpperCase() ?? ""}',
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
                  _buildDebiturInfoCard(),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
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
                        if (!isPenagihan) ...[_buildVerifikasiTypeSelector()],
                        if (isPenagihan) ...[
                          _buildDropdownField(
                            label: 'Pelaksanaan',
                            value: _selectedPelaksanaan,
                            items: _pelaksanaanOptions,
                            onChanged: (value) =>
                                setState(() => _selectedPelaksanaan = value),
                          ),
                          _buildFormField(
                            label: 'Keterangan Pelaksanaan',
                            controller: _keteranganPelaksanaanController,
                            maxLines: 3,
                            validator: (val) => _requiredValidator(
                              val,
                              'Keterangan Pelaksanaan',
                            ),
                          ),
                          _buildDropdownField(
                            label: 'Hasil Pelaksanaan',
                            value: _selectedHasil,
                            items: _hasilOptions,
                            onChanged: (value) =>
                                setState(() => _selectedHasil = value),
                          ),
                          _buildFormField(
                            label: 'Keterangan Hasil',
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
                            controller: _penggunaKreditController,
                            validator: (val) =>
                                _requiredValidator(val, 'Pengguna Kredit'),
                          ),
                          _buildFormField(
                            label: 'Penggunaan Kredit',
                            controller: _penggunaanKreditController,
                            validator: (val) =>
                                _requiredValidator(val, 'Penggunaan Kredit'),
                          ),
                          _buildFormField(
                            label: 'Alamat Debitur',
                            controller: _alamatDebiturController,
                            maxLines: 2,
                            validator: (val) =>
                                _requiredValidator(val, 'Alamat Debitur'),
                          ),
                          _buildFormField(
                            label: 'Cara Pembayaran',
                            controller: _caraPembayaranController,
                            validator: (val) =>
                                _requiredValidator(val, 'Cara Pembayaran'),
                          ),
                          _buildFormField(
                            label: 'Pekerjaan Debitur',
                            controller: _pekerjaanDebiturController,
                            validator: (val) =>
                                _requiredValidator(val, 'Pekerjaan Debitur'),
                          ),
                          _buildFormField(
                            label: 'Karakter Debitur',
                            controller: _karakterDebiturController,
                            maxLines: 2,
                            validator: (val) =>
                                _requiredValidator(val, 'Karakter Debitur'),
                          ),
                          _buildFormField(
                            label: 'Nomor Debitur',
                            controller: _nomorDebiturController,
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                _requiredValidator(val, 'Nomor Debitur'),
                          ),
                          _buildFormField(
                            label: 'Nomor Pendamping',
                            controller: _nomorPendampingController,
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                _requiredValidator(val, 'Nomor Pendamping'),
                          ),
                          _buildKlasifikasiDropdown(),
                        ] else ...[
                          if (_collaterals.isNotEmpty) ...[
                            _buildDropdownFieldGeneric<DetailCollateralModel>(
                              label: 'Pilih Jaminan/Agunan *',
                              value: _selectedCollateral,
                              items: _collaterals,
                              itemAsString: (col) => '${col.nomorAgunan ?? "-"} | ${col.namaAgunan}',
                              onChanged: (col) {
                                setState(() {
                                  _selectedCollateral = col;
                                  if (col != null) {
                                    _kondisiJaminanController.text = col.kondisiAgunan ?? '';
                                    _penguasaanJaminanController.text = col.penguasaanAgunan ?? '';
                                  }
                                });
                              },
                            ),
                          ],
                          _buildFormField(
                            label: 'Kondisi Jaminan',
                            controller: _kondisiJaminanController,
                            maxLines: 2,
                            validator: (val) =>
                                _requiredValidator(val, 'Kondisi Jaminan'),
                          ),
                          _buildFormField(
                            label: 'Penguasaan Jaminan',
                            controller: _penguasaanJaminanController,
                            maxLines: 2,
                            validator: (val) =>
                                _requiredValidator(val, 'Penguasaan Jaminan'),
                          ),
                        ],
                        if (isPenagihan || _verifikasiType == 'Pinjaman') ...[
                          const SizedBox(height: 8),
                          _buildPhotoPicker(),
                          const SizedBox(height: 28),
                        ] else ...[
                          const SizedBox(height: 16),
                        ],
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submitReport,
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

  Widget _buildVerifikasiTypeSelector() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _verifikasiType = 'Pinjaman'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _verifikasiType == 'Pinjaman'
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Verifikasi Pinjaman',
                    style: TextStyle(
                      color: _verifikasiType == 'Pinjaman'
                          ? Colors.white
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _verifikasiType = 'Jaminan'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _verifikasiType == 'Jaminan'
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Verifikasi Jaminan',
                    style: TextStyle(
                      color: _verifikasiType == 'Jaminan'
                          ? Colors.white
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebiturInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          Text(
            'Nama Debitur',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.task.namaLengkap,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),
          Text(
            'Nomor Rekening',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.task.nomorRekening ?? '-',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
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
          initialValue: items.contains(value) ? value : null,
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

  Widget _buildKlasifikasiDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Klasifikasi *',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryColor.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: const ['DM', 'DPP', 'DS', 'DSS', 'DTT'].contains(_selectedKlasifikasi)
              ? _selectedKlasifikasi
              : null,
          hint: const Text(
            'Pilih Klasifikasi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'DM', child: Text('Debitur Mudah')),
            DropdownMenuItem(
              value: 'DPP',
              child: Text('Debitur Perlu Pengingat'),
            ),
            DropdownMenuItem(value: 'DS', child: Text('Debitur Sulit')),
            DropdownMenuItem(value: 'DSS', child: Text('Debitur Sangat Sulit')),
            DropdownMenuItem(
              value: 'DTT',
              child: Text('Debitur Tidak Tertagih'),
            ),
          ],
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

  Widget _buildDropdownFieldGeneric<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemAsString,
    required ValueChanged<T?> onChanged,
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
        DropdownButtonFormField<T>(
          initialValue: items.contains(value) ? value : null,
          hint: Text(
            hint ?? 'Pilih $label',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
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

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
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
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
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
                readOnly: true,
                onTap: () => _selectDate(controller),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(controller),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: AppTheme.textPrimary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey.shade200, height: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhotoPicker() {
    final detailTugasAsync = ref.watch(detailTugasProvider(widget.task.id));
    final fotoUrl = detailTugasAsync.value?.data.task.foto ?? widget.task.foto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Penanganan *',
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
        else if (fotoUrl != null && fotoUrl.isNotEmpty)
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
                    fotoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Gagal memuat foto dari server',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
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
                    label: const Text('Ganti Foto (Kamera)'),
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
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
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
                  'Silakan ambil atau unggah foto penanganan',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
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
