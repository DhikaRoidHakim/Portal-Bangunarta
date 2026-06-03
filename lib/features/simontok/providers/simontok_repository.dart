import 'dart:io';
import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:bangunarta_portal/core/network/dio_client.dart';
import 'package:bangunarta_portal/models/simontok/list_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';
import 'package:bangunarta_portal/models/simontok/submit_laporan_response_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class SimontokRepository {
  SimontokRepository._();

  static final SimontokRepository instance = SimontokRepository._();

  Future<ListPinjamanModel> getListPinjaman({
    required String alias,
    String? search,
  }) async {
    try {
      final response = await DioClient.instance.dio.get(
        ApiEndpoints.listPinjaman,
        queryParameters: {
          'alias': alias,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response list pinjaman tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(responseData['message'] ?? 'Gagal mengambil data pinjaman');
      }

      return ListPinjamanModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  Future<DetailPinjamanModel> getDetailPinjaman(String nomorRekening) async {
    try {
      final response = await DioClient.instance.dio.get(
        '${ApiEndpoints.detailPinjaman}$nomorRekening',
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response detail pinjaman tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(responseData['message'] ?? 'Gagal mengambil detail data pinjaman');
      }

      return DetailPinjamanModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  Future<ListTugasModel> getListTugas({
    required String alias,
    String? search,
  }) async {
    try {
      final response = await DioClient.instance.dio.get(
        ApiEndpoints.listTugas,
        queryParameters: {
          'alias': alias,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response list tugas tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(responseData['message'] ?? 'Gagal mengambil data tugas');
      }

      return ListTugasModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  Future<SubmitLaporanResponseModel> submitPenagihanReport({
    required int taskId,
    required String pelaksanaan,
    required String keteranganPelaksanaan,
    required String hasilPelaksanaan,
    required String keteranganHasil,
    required String janjiBayar,
    required File fotoPenanganan,
  }) async {
    try {
      final originalFileName = fotoPenanganan.path.split('/').last;
      final fileExtension = originalFileName.split('.').last.toLowerCase();
      final fileName = '$taskId.$fileExtension';
      String mimeType = 'image/jpeg';
      if (fileExtension == 'png') {
        mimeType = 'image/png';
      } else if (fileExtension == 'gif') {
        mimeType = 'image/gif';
      } else if (fileExtension == 'webp') {
        mimeType = 'image/webp';
      }

      final formData = FormData.fromMap({
        'pelaksanaan': pelaksanaan,
        'keterangan_pelaksanaan': keteranganPelaksanaan,
        'hasil_pelaksanaan': hasilPelaksanaan,
        'keterangan_hasil': keteranganHasil,
        'janji_bayar': janjiBayar,
        'foto_penanganan': await MultipartFile.fromFile(
          fotoPenanganan.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await DioClient.instance.dio.post(
        '${ApiEndpoints.submitPenagihan}$taskId',
        data: formData,
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response tidak valid');
      }

      return SubmitLaporanResponseModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  Future<SubmitLaporanResponseModel> submitVerifikasiReport({
    required int taskId,
    required String penggunaKredit,
    required String penggunaanKredit,
    required String alamatDebitur,
    required String caraPembayaran,
    required String pekerjaanDebitur,
    required String karakterDebitur,
    required String nomorDebitur,
    required String nomorPendamping,
    required File fotoPenanganan,
  }) async {
    try {
      final originalFileName = fotoPenanganan.path.split('/').last;
      final fileExtension = originalFileName.split('.').last.toLowerCase();
      final fileName = '$taskId.$fileExtension';
      String mimeType = 'image/jpeg';
      if (fileExtension == 'png') {
        mimeType = 'image/png';
      } else if (fileExtension == 'gif') {
        mimeType = 'image/gif';
      } else if (fileExtension == 'webp') {
        mimeType = 'image/webp';
      }

      final formData = FormData.fromMap({
        'pengguna_kredit': penggunaKredit,
        'penggunaan_kredit': penggunaanKredit,
        'alamat_debitur': alamatDebitur,
        'cara_pembayaran': caraPembayaran,
        'pekerjaan_debitur': pekerjaanDebitur,
        'karakter_debitur': karakterDebitur,
        'nomor_debitur': nomorDebitur,
        'nomor_pendamping': nomorPendamping,
        'foto_penanganan': await MultipartFile.fromFile(
          fotoPenanganan.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await DioClient.instance.dio.post(
        '${ApiEndpoints.submitVerifikasi}$taskId',
        data: formData,
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response tidak valid');
      }

      return SubmitLaporanResponseModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  Future<SubmitLaporanResponseModel> submitVerifikasiJaminanReport({
    required int taskId,
    required String kondisiJaminan,
    required String penguasaanJaminan,
    required File fotoPenanganan,
  }) async {
    try {
      final originalFileName = fotoPenanganan.path.split('/').last;
      final fileExtension = originalFileName.split('.').last.toLowerCase();
      final fileName = '$taskId.$fileExtension';
      String mimeType = 'image/jpeg';
      if (fileExtension == 'png') {
        mimeType = 'image/png';
      } else if (fileExtension == 'gif') {
        mimeType = 'image/gif';
      } else if (fileExtension == 'webp') {
        mimeType = 'image/webp';
      }

      final formData = FormData.fromMap({
        'kondisi_jaminan': kondisiJaminan,
        'penguasaan_jaminan': penguasaanJaminan,
        'foto_penanganan': await MultipartFile.fromFile(
          fotoPenanganan.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await DioClient.instance.dio.post(
        '${ApiEndpoints.submitVerifikasiJaminan}$taskId',
        data: formData,
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response tidak valid');
      }

      return SubmitLaporanResponseModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  String _getDioErrorMessage(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Koneksi ke server timeout';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Tidak dapat terhubung ke server';
    }

    return 'Terjadi kesalahan saat memuat data pinjaman';
  }
}
