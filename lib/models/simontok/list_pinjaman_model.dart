class ListPinjamanModel {
  final bool success;
  final List<PinjamanModel> data;
  final String? nextCursor;
  final bool hasMore;

  const ListPinjamanModel({
    required this.success,
    required this.data,
    this.nextCursor,
    required this.hasMore,
  });

  factory ListPinjamanModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List?;
    return ListPinjamanModel(
      success: json['success'] as bool? ?? false,
      data: list != null
          ? list.map((item) => PinjamanModel.fromJson(item as Map<String, dynamic>)).toList()
          : const [],
      nextCursor: json['next_cursor']?.toString(),
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class PinjamanModel {
  final String nomorRekening;
  final String? nomorAlt;
  final String namaDebitur;

  const PinjamanModel({
    required this.nomorRekening,
    this.nomorAlt,
    required this.namaDebitur,
  });

  factory PinjamanModel.fromJson(Map<String, dynamic> json) {
    return PinjamanModel(
      nomorRekening: json['nomor_rekening'] as String? ?? '',
      nomorAlt: json['nomor_alt'] as String?,
      namaDebitur: json['nama_debitur'] as String? ?? '',
    );
  }
}
