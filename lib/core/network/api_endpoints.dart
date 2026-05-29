class ApiEndpoints {
  static const bool isProduction = true;

  static const String devBaseUrl = 'http://192.168.2.9:8000';
  static const String prodBaseUrl = 'https://codex.pba.co.id';

  static String get baseUrl => isProduction ? prodBaseUrl : devBaseUrl;

  static const String login = '/api/jwt/auth';
  static const String me = '/api/jwt/me';
  static const String refresh = '/api/jwt/refresh';
  static const String destroy = '/api/jwt/destroy';
}
