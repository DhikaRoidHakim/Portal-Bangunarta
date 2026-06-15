import 'package:bangunarta_portal/core/services/remote_config_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static const bool isProduction = false;

  /// URL dari .env sebagai fallback
  static String get _devBaseUrl => dotenv.env['DEV_BASE_URL'] ?? '';
  static String get _prodBaseUrl => dotenv.env['PROD_BASE_URL'] ?? '';

  static String get baseUrl {
    final remoteUrl = RemoteConfigService().baseUrl;
    if (remoteUrl.isNotEmpty) {
      return remoteUrl;
    }
    return isProduction ? _prodBaseUrl : _devBaseUrl;
  }

  // Endpoints Authentication
  static const String login = '/api/jwt-auth';
  static const String me = '/api/jwt-me';
  static const String refresh = '/api/jwt-refresh';
  static const String destroy = '/api/jwt-destroy';

  // Endpoints Simontok
  static const String listPinjaman = '/api/simontok/pinjaman';
  static const String detailPinjaman = '/api/simontok/pinjaman';
  static const String listTugas = '/api/simontok/tugas';
  static const String submitPenagihan = '/api/simontok/tugas';
  static const String submitVerifikasi = '/api/simontok/verifikasi-pinjaman';
  static const String submitVerifikasiJaminan =
      '/api/simontok/verifikasi-jaminan';
  static const String listProspek = '/api/simontok/prospek';
  static const String detailProspek = '/api/simontok/prospek';

  // Endpoints Samba
  static const String listSimpanan = '/api/samba/simpanan';
  static const String transaksiSimpanan = '/api/samba/transaksi';
}
