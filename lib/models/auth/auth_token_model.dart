class AuthTokenModel {
  const AuthTokenModel({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
  });

  final String tokenType;
  final int expiresIn;
  final String accessToken;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      tokenType: json['token_type'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
      accessToken: json['access_token'] as String? ?? '',
    );
  }
}
