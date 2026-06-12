import 'package:bangunarta_portal/core/network/api_endpoints.dart';
import 'package:bangunarta_portal/core/network/dio_client.dart';
import 'package:bangunarta_portal/models/auth/auth_me_model.dart';
import 'package:bangunarta_portal/models/auth/auth_token_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  AuthRepository._();

  static final AuthRepository instance = AuthRepository._();

  static const String _accessTokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresInKey = 'expires_in';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _savedUsernameKey = 'saved_username';
  static const String _savedPasswordKey = 'saved_password';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<AuthTokenModel> login({
    required String username,
    required String password,
    required String deviceIdentifier,
    required String deviceName,
    required String deviceOs,
    String fmcToken = '',
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
          'device_identifier': deviceIdentifier,
          'device_name': deviceName,
          'device_os': deviceOs,
          'fmc_token': fmcToken,
        },
      );

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response login tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      final data = responseData['data'];

      if (!isSuccess || data is! Map<String, dynamic>) {
        throw Exception('Login gagal');
      }

      final token = AuthTokenModel.fromJson(data);
      await saveAuthToken(token);

      return token;
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  Future<void> saveAuthToken(AuthTokenModel token) async {
    await _storage.write(key: _accessTokenKey, value: token.accessToken);
    await _storage.write(key: _tokenTypeKey, value: token.tokenType);
    await _storage.write(key: _expiresInKey, value: token.expiresIn.toString());
  }

  Future<AuthTokenModel> refreshToken() async {
    final token = await getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await _dio.post(
      ApiEndpoints.refresh,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final responseData = response.data;

    if (responseData is! Map<String, dynamic>) {
      throw Exception('Format response refresh token tidak valid');
    }

    final isSuccess = responseData['success'] == true;
    final data = responseData['data'];

    if (!isSuccess || data is! Map<String, dynamic>) {
      throw Exception('Refresh token gagal');
    }

    final refreshedToken = AuthTokenModel.fromJson(data);
    await saveAuthToken(refreshedToken);

    return refreshedToken;
  }

  Future<AuthMeModel> getMe() async {
    final token = await getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    try {
      final response = await DioClient.instance.dio.get(ApiEndpoints.me);

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Format response profile tidak valid');
      }

      final isSuccess = responseData['success'] == true;
      final data = responseData['data'];

      if (!isSuccess || data is! Map<String, dynamic>) {
        throw Exception('Gagal mengambil data profile');
      }

      return AuthMeModel.fromJson(data);
    } on DioException catch (error) {
      final message = _getDioErrorMessage(error);
      throw Exception(message);
    }
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);

    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool isEnabled) {
    return _storage.write(
      key: _biometricEnabledKey,
      value: isEnabled.toString(),
    );
  }

  Future<void> saveCredentials(String username, String password) async {
    await _storage.write(key: _savedUsernameKey, value: username);
    await _storage.write(key: _savedPasswordKey, value: password);
  }

  Future<Map<String, String>?> getCredentials() async {
    final username = await _storage.read(key: _savedUsernameKey);
    final password = await _storage.read(key: _savedPasswordKey);
    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _savedUsernameKey);
    await _storage.delete(key: _savedPasswordKey);
  }

  Future<void> logout() async {
    final token = await getAccessToken();

    if (token != null && token.isNotEmpty) {
      try {
        await _dio.post(
          ApiEndpoints.destroy,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      } catch (_) {}
    }

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _tokenTypeKey);
    await _storage.delete(key: _expiresInKey);
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

    return 'Terjadi kesalahan saat login';
  }
}
