class ListSimpananModel {
  final bool success;
  final int total;
  final List<SimpananModel> data;
  final String? nextCursor;
  final bool hasMore;

  const ListSimpananModel({
    required this.success,
    required this.total,
    required this.data,
    this.nextCursor,
    required this.hasMore,
  });

  factory ListSimpananModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List?;
    return ListSimpananModel(
      success: json['success'] as bool? ?? false,
      total: json['total'] as int? ?? 0,
      data: list != null
          ? list
                .map(
                  (item) =>
                      SimpananModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : const [],
      nextCursor: json['next_cursor']?.toString(),
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class SimpananModel {
  final String nomorCif;
  final String nomorRekening;
  final String namaLengkap;

  const SimpananModel({
    required this.nomorCif,
    required this.nomorRekening,
    required this.namaLengkap,
  });

  factory SimpananModel.fromJson(Map<String, dynamic> json) {
    return SimpananModel(
      nomorCif: json['nomor_cif']?.toString() ?? '',
      nomorRekening: json['nomor_rekening']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
    );
  }
}
