import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:bangunarta_portal/core/network/dio_client.dart';
import 'package:bangunarta_portal/models/sigma/list_assets_model.dart';
import 'package:bangunarta_portal/models/sigma/detail_asset_model.dart';
import 'package:dio/dio.dart';

class SigmaRepository {
  SigmaRepository._();

  static final SigmaRepository instance = SigmaRepository._();

  /// Mengambil daftar aset dari Sigma API
  Future<ListAssetsModel> getListAssets({String? search}) async {
    try {
      final sigmaBase = ApiEndpoints.sigmaBaseUrl.trim();
      final String url;
      if (sigmaBase.isNotEmpty) {
        var cleanBase = sigmaBase.endsWith('/')
            ? sigmaBase.substring(0, sigmaBase.length - 1)
            : sigmaBase;
        if (!cleanBase.startsWith('http://') &&
            !cleanBase.startsWith('https://')) {
          cleanBase = 'http://$cleanBase';
        }
        final cleanEndpoint = ApiEndpoints.listAset.startsWith('/')
            ? ApiEndpoints.listAset
            : '/${ApiEndpoints.listAset}';
        url = '$cleanBase$cleanEndpoint';
      } else {
        url = ApiEndpoints.listAset;
      }

      final response = await DioClient.instance.dio.get(
        url,
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response daftar aset tidak valid');
      }

      return ListAssetsModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  /// Mengambil detail aset berdasarkan ID aset
  Future<DetailAssetModel> getDetailAsset(String assetId) async {
    try {
      final sigmaBase = ApiEndpoints.sigmaBaseUrl.trim();
      final String url;
      final endpoint = '/api/public/assets/$assetId';
      if (sigmaBase.isNotEmpty) {
        var cleanBase = sigmaBase.endsWith('/')
            ? sigmaBase.substring(0, sigmaBase.length - 1)
            : sigmaBase;
        if (!cleanBase.startsWith('http://') &&
            !cleanBase.startsWith('https://')) {
          cleanBase = 'http://$cleanBase';
        }
        url = '$cleanBase$endpoint';
      } else {
        url = endpoint;
      }

      final response = await DioClient.instance.dio.get(url);

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response detail aset tidak valid');
      }

      return DetailAssetModel.fromJson(responseData);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  String _getDioErrorMessage(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'].toString();
      }
      return 'Terjadi kesalahan pada server (${error.response?.statusCode})';
    }
    return 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
  }
}
