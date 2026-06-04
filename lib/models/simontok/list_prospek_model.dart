class ListProspekModel {
  final bool success;
  final List<ProspekModel> data;
  final String? nextCursor;
  final bool hasMore;

  const ListProspekModel({
    required this.success,
    required this.data,
    this.nextCursor,
    required this.hasMore,
  });

  factory ListProspekModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List?;
    return ListProspekModel(
      success: json['success'] as bool? ?? false,
      data: list != null
          ? list.map((item) => ProspekModel.fromJson(item as Map<String, dynamic>)).toList()
          : const [],
      nextCursor: json['next_cursor']?.toString(),
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class ProspekModel {
  final int id;
  final int? makerId;
  final String? tanggal;
  final String? jenis;
  final String namaLengkap;
  final String? nomorHp;
  final String? keterangan;
  final String? foto;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const ProspekModel({
    required this.id,
    this.makerId,
    this.tanggal,
    this.jenis,
    required this.namaLengkap,
    this.nomorHp,
    this.keterangan,
    this.foto,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProspekModel.fromJson(Map<String, dynamic> json) {
    return ProspekModel(
      id: json['id'] as int? ?? 0,
      makerId: json['maker_id'] as int?,
      tanggal: json['tanggal']?.toString(),
      jenis: json['jenis']?.toString(),
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      nomorHp: json['nomor_hp']?.toString(),
      keterangan: json['keterangan']?.toString(),
      foto: json['foto']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
