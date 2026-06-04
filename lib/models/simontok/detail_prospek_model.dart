class DetailProspekModel {
  final bool success;
  final ProspekDetailData data;

  DetailProspekModel({
    required this.success,
    required this.data,
  });

  factory DetailProspekModel.fromJson(Map<String, dynamic> json) {
    return DetailProspekModel(
      success: json['success'] ?? false,
      data: ProspekDetailData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class ProspekDetailData {
  final int id;
  final int makerId;
  final String tanggal;
  final String jenis;
  final String namaLengkap;
  final String? nomorHp;
  final String? keterangan;
  final String? foto;
  final String status;
  final String createdAt;
  final String updatedAt;

  ProspekDetailData({
    required this.id,
    required this.makerId,
    required this.tanggal,
    required this.jenis,
    required this.namaLengkap,
    this.nomorHp,
    this.keterangan,
    this.foto,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProspekDetailData.fromJson(Map<String, dynamic> json) {
    return ProspekDetailData(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      makerId: json['maker_id'] is int ? json['maker_id'] as int : int.tryParse(json['maker_id']?.toString() ?? '') ?? 0,
      tanggal: json['tanggal']?.toString() ?? '',
      jenis: json['jenis']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      nomorHp: json['nomor_hp']?.toString(),
      keterangan: json['keterangan']?.toString(),
      foto: json['foto']?.toString(),
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maker_id': makerId,
      'tanggal': tanggal,
      'jenis': jenis,
      'nama_lengkap': namaLengkap,
      'nomor_hp': nomorHp,
      'keterangan': keterangan,
      'foto': foto,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
