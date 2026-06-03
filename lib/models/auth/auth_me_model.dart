class AuthMeModel {
  const AuthMeModel({
    required this.user,
    this.device,
  });

  final UserModel user;
  final DeviceModel? device;

  factory AuthMeModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final deviceJson = json['device'];

    return AuthMeModel(
      user: UserModel.fromJson(
        userJson is Map<String, dynamic> ? userJson : <String, dynamic>{},
      ),
      device: deviceJson is Map<String, dynamic>
          ? DeviceModel.fromJson(deviceJson)
          : null,
    );
  }
}

class UserModel {
  const UserModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.role,
    this.office,
    this.alias,
    this.msoCode,
    this.collectorCode,
    this.deletedAt,
  });

  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final String? role;
  final String? office;
  final String? alias;
  final String? msoCode;
  final String? collectorCode;
  final String? deletedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      username: _toString(json['username']),
      email: _toString(json['email']),
      role: _toString(json['role']),
      office: _toString(json['office']),
      alias: _toString(json['alias']),
      msoCode: _toString(json['mso_code']),
      collectorCode: _toString(json['collector_code']),
      deletedAt: _toString(json['deleted_at']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _toString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}

class DeviceModel {
  const DeviceModel({
    this.deviceIdentifier,
    this.deviceName,
    this.deviceOs,
    this.fmcToken,
  });

  final String? deviceIdentifier;
  final String? deviceName;
  final String? deviceOs;
  final String? fmcToken;

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceIdentifier: _toString(json['device_identifier']),
      deviceName: _toString(json['device_name']),
      deviceOs: _toString(json['device_os']),
      fmcToken: _toString(json['fmc_token']),
    );
  }

  static String? _toString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}
