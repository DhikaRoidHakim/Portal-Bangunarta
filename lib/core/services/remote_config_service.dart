import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  late final FirebaseRemoteConfig _remoteConfig;

  /// Key yang digunakan di Firebase Remote Config
  static const String _keyBaseUrl = 'BASE_URL';
  static const String _countCetakResi = 'COUNT_CETAK';
  static const String _keySigmaBaseUrl = 'SIGMA_BASE_URL';

  Future<void> initialize() async {
    _remoteConfig = FirebaseRemoteConfig.instance;

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 1)
            : const Duration(hours: 1),
      ),
    );

    // Default value jika Remote Config tidak tersedia / belum di-fetch
    await _remoteConfig.setDefaults(const {
      _keyBaseUrl: '',
      _countCetakResi: 10,
      _keySigmaBaseUrl: '',
    });

    try {
      await _remoteConfig.fetchAndActivate();
      debugPrint('[RemoteConfig] Fetch & activate berhasil.');
    } catch (e) {
      debugPrint(
        '[RemoteConfig] Gagal fetch: $e. Menggunakan default / cached value.',
      );
    }
  }

  String get baseUrl => _remoteConfig.getString(_keyBaseUrl);
  String get sigmaBaseUrl => _remoteConfig.getString(_keySigmaBaseUrl);
  int get countCetakResi => _remoteConfig.getInt(_countCetakResi);
}
