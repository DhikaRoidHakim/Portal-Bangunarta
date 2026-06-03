class ListTugasModel {
  final bool success;
  final List<TugasModel> data;
  final String? nextCursor;
  final bool hasMore;

  const ListTugasModel({
    required this.success,
    required this.data,
    this.nextCursor,
    required this.hasMore,
  });

  factory ListTugasModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List?;
    return ListTugasModel(
      success: json['success'] as bool? ?? false,
      data: list != null
          ? list.map((item) => TugasModel.fromJson(item as Map<String, dynamic>)).toList()
          : const [],
      nextCursor: json['next_cursor']?.toString(),
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class TugasModel {
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

  const TugasModel({
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
  });

  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id'] as int? ?? 0,
      kode: json['kode']?.toString(),
      nomorRekening: json['nomor_rekening']?.toString(),
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      tanggal: json['tanggal']?.toString(),
      jenis: json['jenis']?.toString(),
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
    );
  }

  static double? _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
