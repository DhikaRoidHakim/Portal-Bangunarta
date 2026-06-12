class DetailSimpananModel {
  final bool success;
  final DetailSimpananData data;

  const DetailSimpananModel({
    required this.success,
    required this.data,
  });

  factory DetailSimpananModel.fromJson(Map<String, dynamic> json) {
    return DetailSimpananModel(
      success: json['success'] as bool? ?? false,
      data: DetailSimpananData.fromJson(
        json['data'] is Map<String, dynamic>
            ? json['data']
            : const <String, dynamic>{},
      ),
    );
  }
}

class DetailSimpananData {
  final String nomorCif;
  final String nomorRekening;
  final String produkSimpanan;
  final String namaLengkap;
  final String alamatKtp;
  final String? nomorHp;
  final String? tujuanPembukaan;
  final String? namaAhliWaris;
  final String? statusAhliWaris;
  final String? kontakAhliWaris;
  final String namaKolektor;

  const DetailSimpananData({
    required this.nomorCif,
    required this.nomorRekening,
    required this.produkSimpanan,
    required this.namaLengkap,
    required this.alamatKtp,
    this.nomorHp,
    this.tujuanPembukaan,
    this.namaAhliWaris,
    this.statusAhliWaris,
    this.kontakAhliWaris,
    required this.namaKolektor,
  });

  factory DetailSimpananData.fromJson(Map<String, dynamic> json) {
    return DetailSimpananData(
      nomorCif: json['nomor_cif']?.toString() ?? '',
      nomorRekening: json['nomor_rekening']?.toString() ?? '',
      produkSimpanan: json['produk_simpanan']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      alamatKtp: json['alamat_ktp']?.toString() ?? '',
      nomorHp: json['nomor_hp']?.toString(),
      tujuanPembukaan: json['tujuan_pembukaan']?.toString(),
      namaAhliWaris: json['nama_ahli_waris']?.toString(),
      statusAhliWaris: json['status_ahli_waris']?.toString(),
      kontakAhliWaris: json['kontak_ahli_waris']?.toString(),
      namaKolektor: json['nama_kolektor']?.toString() ?? '',
    );
  }
}
