class SubmitLaporanResponseModel {
  final bool success;
  final String message;

  const SubmitLaporanResponseModel({
    required this.success,
    required this.message,
  });

  factory SubmitLaporanResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmitLaporanResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
    );
  }
}
