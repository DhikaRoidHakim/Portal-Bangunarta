import 'package:bangunarta_portal/models/simontok/detail_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';

class DetailTugasModel {
  final bool success;
  final DetailTugasData data;

  const DetailTugasModel({
    required this.success,
    required this.data,
  });

  factory DetailTugasModel.fromJson(Map<String, dynamic> json) {
    return DetailTugasModel(
      success: json['success'] as bool? ?? false,
      data: DetailTugasData.fromJson(
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : const <String, dynamic>{},
      ),
    );
  }
}

class DetailTugasData {
  final DetailTaskModel task;
  final List<DetailCollateralModel> collaterals;

  const DetailTugasData({
    required this.task,
    required this.collaterals,
  });

  factory DetailTugasData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('task')) {
      final taskJson = json['task'] as Map<String, dynamic>? ?? const {};
      final collList = json['collaterals'] as List? ?? const [];
      return DetailTugasData(
        task: DetailTaskModel.fromJson(taskJson, defaultJenis: 'Verifikasi'),
        collaterals: collList
            .map((item) => DetailCollateralModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } else {
      return DetailTugasData(
        task: DetailTaskModel.fromJson(json),
        collaterals: const [],
      );
    }
  }
}

class DetailTaskModel {
  final int id;
  final String? kode;
  final String? nomorRekening;
  final String namaLengkap;
  final String? tanggal;
  final String? jenis;
  final String? pelaksanaan;
  final String? pelaksanaanDetail;
  final String? hasil;
  final String? hasilDetail;
  final String? janjiBayar;
  final String? catatan;
  final String? foto;
  final double? tunggakanPokok;
  final double? tunggakanBunga;
  final double? tunggakanDenda;
  final String? klasifikasi;
  final String? status;
  final int? makerId;
  final int? executorId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  // Verification-specific fields
  final String? penggunaKredit;
  final String? penggunaanKredit;
  final String? alamatDebitur;
  final String? caraPembayaran;
  final String? pekerjaanDebitur;
  final String? karakterDebitur;
  final String? nomorDebitur;
  final String? nomorPendamping;

  const DetailTaskModel({
    required this.id,
    this.kode,
    this.nomorRekening,
    required this.namaLengkap,
    this.tanggal,
    this.jenis,
    this.pelaksanaan,
    this.pelaksanaanDetail,
    this.hasil,
    this.hasilDetail,
    this.janjiBayar,
    this.catatan,
    this.foto,
    this.tunggakanPokok,
    this.tunggakanBunga,
    this.tunggakanDenda,
    this.klasifikasi,
    this.status,
    this.makerId,
    this.executorId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.penggunaKredit,
    this.penggunaanKredit,
    this.alamatDebitur,
    this.caraPembayaran,
    this.pekerjaanDebitur,
    this.karakterDebitur,
    this.nomorDebitur,
    this.nomorPendamping,
  });

  factory DetailTaskModel.fromJson(Map<String, dynamic> json, {String? defaultJenis}) {
    return DetailTaskModel(
      id: json['id'] as int? ?? 0,
      kode: json['kode']?.toString(),
      nomorRekening: json['nomor_rekening']?.toString(),
      namaLengkap: json['nama_debitur']?.toString() ?? json['nama_lengkap']?.toString() ?? '',
      tanggal: json['tanggal']?.toString(),
      jenis: json['jenis']?.toString() ?? defaultJenis,
      pelaksanaan: json['pelaksanaan']?.toString(),
      pelaksanaanDetail: json['pelaksanaan_detail']?.toString(),
      hasil: json['hasil']?.toString(),
      hasilDetail: json['hasil_detail']?.toString(),
      janjiBayar: json['janji_bayar']?.toString(),
      catatan: json['catatan']?.toString(),
      foto: json['foto']?.toString(),
      tunggakanPokok: _toDouble(json['tunggakan_pokok']),
      tunggakanBunga: _toDouble(json['tunggakan_bunga']),
      tunggakanDenda: _toDouble(json['tunggakan_denda']),
      klasifikasi: json['klasifikasi']?.toString(),
      status: json['status']?.toString(),
      makerId: json['maker_id'] as int?,
      executorId: json['executor_id'] as int?,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      penggunaKredit: json['pengguna_kredit']?.toString(),
      penggunaanKredit: json['penggunaan_kredit']?.toString(),
      alamatDebitur: json['alamat_debitur']?.toString(),
      caraPembayaran: json['cara_pembayaran']?.toString(),
      pekerjaanDebitur: json['pekerjaan_debitur']?.toString(),
      karakterDebitur: json['karakter_debitur']?.toString(),
      nomorDebitur: json['nomor_debitur']?.toString(),
      nomorPendamping: json['nomor_pendamping']?.toString(),
    );
  }

  factory DetailTaskModel.fromTugasModel(TugasModel task) {
    return DetailTaskModel(
      id: task.id,
      kode: task.kode,
      nomorRekening: task.nomorRekening,
      namaLengkap: task.namaLengkap,
      tanggal: task.tanggal,
      jenis: task.jenis,
      pelaksanaan: task.pelaksanaan,
      pelaksanaanDetail: task.pelaksanaanDetail,
      hasil: task.hasil,
      hasilDetail: task.hasilDetail,
      janjiBayar: task.janjiBayar,
      catatan: task.catatan,
      foto: task.foto,
      tunggakanPokok: task.tunggakanPokok,
      tunggakanBunga: task.tunggakanBunga,
      tunggakanDenda: task.tunggakanDenda,
      klasifikasi: task.klasifikasi,
      status: task.status,
      makerId: task.makerId,
      executorId: task.executorId,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      deletedAt: task.deletedAt,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class DetailCollateralModel {
  final int id;
  final String? nomorAgunan;
  final String? nomorRekening;
  final String? jenisAgunan;
  final String namaAgunan;
  final String? kondisiAgunan;
  final String? penguasaanAgunan;
  final String? createdAt;
  final String? updatedAt;
  final String? status;

  const DetailCollateralModel({
    required this.id,
    this.nomorAgunan,
    this.nomorRekening,
    this.jenisAgunan,
    required this.namaAgunan,
    this.kondisiAgunan,
    this.penguasaanAgunan,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory DetailCollateralModel.fromJson(Map<String, dynamic> json) {
    return DetailCollateralModel(
      id: json['id'] as int? ?? 0,
      nomorAgunan: json['nomor_agunan']?.toString(),
      nomorRekening: json['nomor_rekening']?.toString(),
      jenisAgunan: json['jenis_agunan']?.toString(),
      namaAgunan: json['nama_agunan']?.toString() ?? '',
      kondisiAgunan: json['kondisi_agunan']?.toString(),
      penguasaanAgunan: json['penguasaan_agunan']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
