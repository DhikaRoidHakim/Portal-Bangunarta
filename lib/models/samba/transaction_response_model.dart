class TransactionResponseModel {
  final bool success;
  final TransactionData data;

  const TransactionResponseModel({
    required this.success,
    required this.data,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      success: json['success'] as bool? ?? false,
      data: TransactionData.fromJson(
        json['data'] is Map<String, dynamic>
            ? json['data']
            : const <String, dynamic>{},
      ),
    );
  }
}

class TransactionData {
  final int id;
  final String kode;
  final String nomorRekening;
  final String namaLengkap;
  final num nominal;
  final String deskripsi;
  final String status;
  final int cetak;
  final String kantorPetugas;
  final String namaPetugas;
  final String? namaPenyetor;
  final String jenisTransaksi;
  final String waktu;

  const TransactionData({
    required this.id,
    required this.kode,
    required this.nomorRekening,
    required this.namaLengkap,
    required this.nominal,
    required this.deskripsi,
    required this.status,
    required this.cetak,
    required this.kantorPetugas,
    required this.namaPetugas,
    this.namaPenyetor,
    required this.jenisTransaksi,
    required this.waktu,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'] as int? ?? 0,
      kode: json['kode']?.toString() ?? '',
      nomorRekening: json['nomor_rekening']?.toString() ?? '',
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      nominal: json['nominal'] as num? ?? 0,
      deskripsi: json['deskripsi']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      cetak: json['cetak'] as int? ?? 0,
      kantorPetugas: json['kantor_petugas']?.toString() ?? '',
      namaPetugas: json['nama_petugas']?.toString() ?? '',
      namaPenyetor: json['nama_penyetor']?.toString(),
      jenisTransaksi: json['jenis_transaksi']?.toString() ?? '',
      waktu: json['waktu']?.toString() ?? '',
    );
  }
}
