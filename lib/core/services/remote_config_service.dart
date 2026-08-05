import 'dart:convert';

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
  static const String _disableServices = 'DISABLE_SERVICES';

  Future<void> initialize() async {
    _remoteConfig = FirebaseRemoteConfig.instance;

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );

    // Default value jika Remote Config tidak tersedia / belum di-fetch.
    // Catatan: Firebase Remote Config setDefaults hanya menerima String, int, double, atau bool.
    await _remoteConfig.setDefaults(const {
      _keyBaseUrl: '',
      _countCetakResi: 10,
      _keySigmaBaseUrl: '',
      _disableServices: '{}',
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

  /// Mendapatkan Map status disable/enable service dari Remote Config.
  Map<String, dynamic> get disableServicesMap {
    try {
      final rawString = _remoteConfig.getString(_disableServices);
      if (rawString.isEmpty) return {};
      final decoded = json.decode(rawString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (e) {
      debugPrint('[RemoteConfig] Error parsing disableServicesMap: $e');
    }
    return {};
  }

  /// Mendapatkan daftar service yang disabled (jika value-nya true atau ada dalam list).
  List<String> get disableServices {
    try {
      final rawString = _remoteConfig.getString(_disableServices);
      if (rawString.isEmpty) return [];
      final decoded = json.decode(rawString);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      } else if (decoded is Map<String, dynamic>) {
        return decoded.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key)
            .toList();
      }
    } catch (e) {
      debugPrint('[RemoteConfig] Error parsing disableServices: $e');
    }
    return [];
  }

  /// Pengecekan apakah service tertentu disabled
  bool isServiceDisabled(String serviceName, {bool defaultIfMissing = false}) {
    final name = serviceName.toLowerCase();
    final map = disableServicesMap;
    if (map.containsKey(name)) {
      return map[name] == true;
    }
    return defaultIfMissing;
  }
}
