import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';

class DetailTugasModel {
  final bool success;
  final TugasModel data;

  const DetailTugasModel({
    required this.success,
    required this.data,
  });

  factory DetailTugasModel.fromJson(Map<String, dynamic> json) {
    return DetailTugasModel(
      success: json['success'] as bool? ?? false,
      data: json['data'] is Map<String, dynamic>
          ? TugasModel.fromJson(json['data'] as Map<String, dynamic>)
          : const TugasModel(id: 0, namaLengkap: ''),
    );
  }
}
