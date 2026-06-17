class AppConfigModel {
  const AppConfigModel({
    required this.name,
    required this.forceUpdate,
    required this.androidMinVersion,
    required this.androidCurrentVersion,
    required this.iosMinVersion,
    required this.iosCurrentVersion,
  });

  final String name;
  final int forceUpdate;
  final String androidMinVersion;
  final String androidCurrentVersion;
  final String iosMinVersion;
  final String iosCurrentVersion;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      name: json['name'] as String? ?? '',
      forceUpdate: _toInt(json['force_update']) ?? 0,
      androidMinVersion: (json['android_min_version'] ?? '').toString(),
      androidCurrentVersion: (json['android_current_version'] ?? '').toString(),
      iosMinVersion: (json['ios_min_version'] ?? '').toString(),
      iosCurrentVersion: (json['ios_current_version'] ?? '').toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
