class ListTransaksiModel {
  final bool success;
  final List<SambaTransactionModel> data;
  final List<SambaSummaryModel> dataSummary;
  final String? nextCursor;
  final bool hasMore;

  const ListTransaksiModel({
    required this.success,
    required this.data,
    required this.dataSummary,
    this.nextCursor,
    required this.hasMore,
  });

  factory ListTransaksiModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List?;
    final summaryJson = json['summary'];
    return ListTransaksiModel(
      success: json['success'] as bool? ?? false,
      data: list != null
          ? list
                .map(
                  (item) => SambaTransactionModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : const [],
      dataSummary: summaryJson is Map<String, dynamic>
          ? [SambaSummaryModel.fromJson(summaryJson)]
          : summaryJson is List
          ? summaryJson
                .map(
                  (item) =>
                      SambaSummaryModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : const [],
      nextCursor: json['next_cursor']?.toString(),
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class SambaTransactionModel {
  final int id;
  final String kode;
  final String nomorRekening;
  final String namaLengkap;
  final num nominal;
  final String deskripsi;
  final String status;
  final String waktu;

  const SambaTransactionModel({
    required this.id,
    required this.kode,
    required this.nomorRekening,
    required this.namaLengkap,
    required this.nominal,
    required this.deskripsi,
    required this.status,
    required this.waktu,
  });

  factory SambaTransactionModel.fromJson(Map<String, dynamic> json) {
    return SambaTransactionModel(
      id: json['id'] as int? ?? 0,
      kode: json['kode']?.toString() ?? '',
      nomorRekening: json['nomor_rekening']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      nominal: json['nominal'] as num? ?? 0,
      deskripsi: json['deskripsi']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      waktu: json['waktu']?.toString() ?? '',
    );
  }
}

class SambaSummaryModel {
  final String overall;
  final String pending;
  final String success;

  const SambaSummaryModel({
    required this.overall,
    required this.pending,
    required this.success,
  });

  factory SambaSummaryModel.fromJson(Map<String, dynamic> json) {
    return SambaSummaryModel(
      overall: json['overall']?.toString() ?? '',
      pending: json['pending']?.toString() ?? '',
      success: json['success']?.toString() ?? '',
    );
  }
}
