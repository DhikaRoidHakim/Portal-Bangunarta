import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:bangunarta_portal/core/network/dio_client.dart';
import 'package:bangunarta_portal/models/samba/list_simpanan_model.dart';
import 'package:bangunarta_portal/models/samba/detail_simpanan_model.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';
import 'package:bangunarta_portal/models/samba/list_transaksi_model.dart';
import 'package:dio/dio.dart';

class SambaRepository {
  SambaRepository._();

  static final SambaRepository instance = SambaRepository._();

  /// Mengambil daftar simpanan berdasarkan kode kolektor
  Future<ListSimpananModel> getListSimpanan({
    required String collectorCode,
    String? search,
    String? cursor,
  }) async {
    try {
      final response = await DioClient.instance.dio.get(
        ApiEndpoints.listSimpanan,
        queryParameters: {
          'kode_kolektor': collectorCode,
          if (search != null && search.isNotEmpty) 'search': search,
          if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response list simpanan tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data simpanan',
        );
      }

      return ListSimpananModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// Mengambil detail simpanan berdasarkan nomor rekening
  Future<DetailSimpananModel> getDetailSimpanan(String nomorRekening) async {
    try {
      final response = await DioClient.instance.dio.get(
        '${ApiEndpoints.listSimpanan}/$nomorRekening',
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response detail simpanan tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil detail simpanan',
        );
      }

      return DetailSimpananModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// Mengirim transaksi simpanan baru
  Future<TransactionResponseModel> submitTransaksiSimpanan({
    required String collectorCode,
    required String nomorRekening,
    required num nominal,
  }) async {
    try {
      final response = await DioClient.instance.dio.post(
        ApiEndpoints.transaksiSimpanan,
        data: {
          'kode_kolektor': collectorCode,
          'nomor_rekening': nomorRekening,
          'nominal': nominal,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response transaksi simpanan tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal memproses transaksi simpanan',
        );
      }

      return TransactionResponseModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// Mengambil daftar transaksi simpanan berdasarkan kode kolektor
  Future<ListTransaksiModel> getListTransaksi({
    required String collectorCode,
    String? search,
    String? cursor,
  }) async {
    try {
      final response = await DioClient.instance.dio.get(
        ApiEndpoints.transaksiSimpanan,
        queryParameters: {
          'kode_kolektor': collectorCode,
          if (search != null && search.isNotEmpty) 'search': search,
          if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response list transaksi tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil data transaksi',
        );
      }

      return ListTransaksiModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// Mengambil detail transaksi berdasarkan ID
  Future<TransactionResponseModel> getDetailTransaksi(int transactionId) async {
    try {
      final response = await DioClient.instance.dio.get(
        '${ApiEndpoints.transaksiSimpanan}/$transactionId',
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response detail transaksi tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      if (!isSuccess) {
        throw Exception(
          responseData['message'] ?? 'Gagal mengambil detail transaksi',
        );
      }

      return TransactionResponseModel.fromJson(responseData);
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

    return 'Terjadi kesalahan saat memuat data simpanan';
  }
}
