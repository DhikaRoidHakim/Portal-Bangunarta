import 'dart:io';
import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:bangunarta_portal/core/network/dio_client.dart';
import 'package:bangunarta_portal/models/simontok/list_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';
import 'package:bangunarta_portal/models/simontok/list_prospek_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_prospek_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_tugas_model.dart';
import 'package:bangunarta_portal/models/simontok/submit_laporan_response_model.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class SimontokRepository {
  SimontokRepository._();

  static final SimontokRepository instance = SimontokRepository._();

  /// List Pinjaman
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
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data pinjaman',
        );
      }

      return ListPinjamanModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// Detail Pinjaman
  Future<DetailPinjamanModel> getDetailPinjaman(String nomorRekening) async {
    try {
      final response = await DioClient.instance.dio.get(
        '${ApiEndpoints.detailPinjaman}/$nomorRekening',
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response detail pinjaman tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil detail data pinjaman',
        );
      }

      return DetailPinjamanModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// List Tugas
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
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data tugas',
        );
      }

      return ListTugasModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// List Prospek
  Future<ListProspekModel> getListProspek({
    required String alias,
    String? search,
  }) async {
    try {
      final response = await DioClient.instance.dio.get(
        ApiEndpoints.listProspek,
        queryParameters: {
          'alias': alias,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response list prospek tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data prospek',
        );
      }

      return ListProspekModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  // Submit Laporan dengan tipe penagihan
  Future<SubmitLaporanResponseModel> submitPenagihanReport({
    required int taskId,
    required String pelaksanaan,
    required String keteranganPelaksanaan,
    required String hasilPelaksanaan,
    required String keteranganHasil,
    required String janjiBayar,
    File? fotoPenanganan,
    required String klasifikasi,
  }) async {
    try {
      MultipartFile? multipartFile;
      if (fotoPenanganan != null) {
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
        multipartFile = await MultipartFile.fromFile(
          fotoPenanganan.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        );
      }

      final formData = FormData.fromMap({
        'pelaksanaan': pelaksanaan,
        'keterangan_pelaksanaan': keteranganPelaksanaan,
        'hasil_pelaksanaan': hasilPelaksanaan,
        'keterangan_hasil': keteranganHasil,
        if (janjiBayar.isNotEmpty) 'janji_bayar': janjiBayar,
        'klasifikasi': klasifikasi,
        if (multipartFile != null) 'foto_penanganan': multipartFile,
      });

      final response = await DioClient.instance.dio.post(
        '${ApiEndpoints.submitPenagihan}/$taskId',
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

  // Submit Laporan dengan tipe verifikasi (pinjaman)
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
    File? fotoPenanganan,
    required String klasifikasi,
  }) async {
    try {
      MultipartFile? multipartFile;
      if (fotoPenanganan != null) {
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
        multipartFile = await MultipartFile.fromFile(
          fotoPenanganan.path,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        );
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
        'klasifikasi': klasifikasi,
        if (multipartFile != null) 'foto_penanganan': multipartFile,
      });

      // final requestUrl = '${DioClient.instance.dio.options.baseUrl}${ApiEndpoints.submitVerifikasi}/$taskId';
      // print('DEBUG SIMONTOK - Request URL: $requestUrl');
      // print('DEBUG SIMONTOK - Form Data fields: ${formData.fields.map((e) => "${e.key}: ${e.value}")}');

      final response = await DioClient.instance.dio.post(
        '${ApiEndpoints.submitVerifikasi}/$taskId',
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

  /// Submit laporan dengan tipe verifikasi (jaminan)
  Future<SubmitLaporanResponseModel> submitVerifikasiJaminanReport({
    required String nomorAgunan,
    required String kondisiJaminan,
    required String penguasaanJaminan,
  }) async {
    try {
      // final requestUrl =
      //     '${DioClient.instance.dio.options.baseUrl}${ApiEndpoints.submitVerifikasiJaminan}/$nomorAgunan';
      // print('DEBUG SIMONTOK - Request URL: $requestUrl');
      // print(
      //   'DEBUG SIMONTOK - Jaminan Data: kondisi_jaminan: $kondisiJaminan, penguasaan_jaminan: $penguasaanJaminan',
      // );

      final response = await DioClient.instance.dio.post(
        '${ApiEndpoints.submitVerifikasiJaminan}/$nomorAgunan',
        data: {
          'kondisi_agunan': kondisiJaminan,
          'penguasaan_agunan': penguasaanJaminan,
        },
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

  // Submit Prospek
  Future<SubmitLaporanResponseModel> submitProspekReport({
    required String alias,
    required String jenisProspek,
    required String namaLengkap,
    required String nomorHp,
    required String keterangan,
    required String statusProspek,
    required File fotoProspek,
  }) async {
    try {
      final originalFileName = fotoProspek.path.split('/').last;
      final fileExtension = originalFileName.split('.').last.toLowerCase();
      final uploadName =
          'prospek_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      String mimeType = 'image/jpeg';
      if (fileExtension == 'png') {
        mimeType = 'image/png';
      } else if (fileExtension == 'gif') {
        mimeType = 'image/gif';
      } else if (fileExtension == 'webp') {
        mimeType = 'image/webp';
      }

      final formData = FormData.fromMap({
        'alias': alias,
        'jenis_prospek': jenisProspek,
        'nama_lengkap': namaLengkap,
        'nomor_hp': nomorHp,
        'keterangan': keterangan,
        'status_prospek': statusProspek,
        'foto_prospek': await MultipartFile.fromFile(
          fotoProspek.path,
          filename: uploadName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await DioClient.instance.dio.post(
        ApiEndpoints.listProspek,
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

  /// Update Prospek
  Future<SubmitLaporanResponseModel> updateProspekReport({
    required int id,
    required String alias,
    required String jenisProspek,
    required String namaLengkap,
    required String nomorHp,
    required String keterangan,
    required String statusProspek,
    File? fotoProspek,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'alias': alias,
        'jenis_prospek': jenisProspek,
        'nama_lengkap': namaLengkap,
        'nomor_hp': nomorHp,
        'keterangan': keterangan,
        'status_prospek': statusProspek,
      };

      if (fotoProspek != null) {
        final originalFileName = fotoProspek.path.split('/').last;
        final fileExtension = originalFileName.split('.').last.toLowerCase();
        final uploadName =
            'prospek_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

        String mimeType = 'image/jpeg';
        if (fileExtension == 'png') {
          mimeType = 'image/png';
        } else if (fileExtension == 'gif') {
          mimeType = 'image/gif';
        } else if (fileExtension == 'webp') {
          mimeType = 'image/webp';
        }

        formMap['foto_prospek'] = await MultipartFile.fromFile(
          fotoProspek.path,
          filename: uploadName,
          contentType: MediaType.parse(mimeType),
        );
      }

      final formData = FormData.fromMap(formMap);

      final response = await DioClient.instance.dio.post(
        '${ApiEndpoints.listProspek}/$id',
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

  /// Delete prospek
  Future<SubmitLaporanResponseModel> deleteProspek(int id) async {
    try {
      final response = await DioClient.instance.dio.delete(
        '${ApiEndpoints.listProspek}/$id',
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

  /// Detail Prospek
  Future<DetailProspekModel> getDetailProspek(int id) async {
    try {
      final response = await DioClient.instance.dio.get(
        '${ApiEndpoints.detailProspek}/$id',
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response detail prospek tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil detail data prospek',
        );
      }

      return DetailProspekModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// Detail Tugas
  Future<DetailTugasModel> getDetailTugas(int id) async {
    try {
      final response = await DioClient.instance.dio.get(
        '${ApiEndpoints.submitPenagihan}/$id',
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response detail tugas tidak valid');
      }

      return DetailTugasModel.fromJson(responseData);
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
