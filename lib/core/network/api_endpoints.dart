class ApiEndpoints {
  static const bool isProduction = false;

  static const String devBaseUrl = 'https://codex.stg.pba.co.id';
  static const String prodBaseUrl = 'https://codex.bprbangunarta.co.id';

  static String get baseUrl => isProduction ? prodBaseUrl : devBaseUrl;

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
