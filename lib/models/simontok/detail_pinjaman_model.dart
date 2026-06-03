class DetailPinjamanModel {
  final bool success;
  final DetailPinjamanData data;

  const DetailPinjamanModel({
    required this.success,
    required this.data,
  });

  factory DetailPinjamanModel.fromJson(Map<String, dynamic> json) {
    return DetailPinjamanModel(
      success: json['success'] as bool? ?? false,
      data: DetailPinjamanData.fromJson(
        json['data'] is Map<String, dynamic>
            ? json['data']
            : const <String, dynamic>{},
      ),
    );
  }
}

class DetailPinjamanData {
  final CreditDetailModel credit;
  final List<CollateralModel> collaterals;
  final List<TaskModel> tasks;

  const DetailPinjamanData({
    required this.credit,
    required this.collaterals,
    required this.tasks,
  });

  factory DetailPinjamanData.fromJson(Map<String, dynamic> json) {
    final creditJson = json['credit'];
    final collsJson = json['collaterals'] as List?;
    final tasksJson = json['tasks'] as List?;

    return DetailPinjamanData(
      credit: CreditDetailModel.fromJson(
        creditJson is Map<String, dynamic>
            ? creditJson
            : const <String, dynamic>{},
      ),
      collaterals: collsJson != null
          ? collsJson
              .map((item) => CollateralModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : const [],
      tasks: tasksJson != null
          ? tasksJson
              .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}

class CreditDetailModel {
  final int id;
  final String? nomorCif;
  final String nomorRekening;
  final String? nomorAlt;
  final String? kodeProduk;
  final String namaDebitur;
  final String? plafondAwal;
  final String? bakiDebet;
  final String? metodeRps;
  final String? jangkaWaktu;
  final String? tglRealisasi;
  final String? tglJatuhTempo;
  final String? rate;
  final String? coll;
  final String? wilayah;
  final String? bidang;
  final String? alamat;
  final String? kolektor;
  final String? resort;
  final String? hariPokok;
  final String? hariBunga;
  final String? tunggakanPokok;
  final String? tunggakanBunga;
  final String? tunggakanDenda;
  final String? tunggakanHari;
  final String? nomorHp;

  const CreditDetailModel({
    required this.id,
    this.nomorCif,
    required this.nomorRekening,
    this.nomorAlt,
    this.kodeProduk,
    required this.namaDebitur,
    this.plafondAwal,
    this.bakiDebet,
    this.metodeRps,
    this.jangkaWaktu,
    this.tglRealisasi,
    this.tglJatuhTempo,
    this.rate,
    this.coll,
    this.wilayah,
    this.bidang,
    this.alamat,
    this.kolektor,
    this.resort,
    this.hariPokok,
    this.hariBunga,
    this.tunggakanPokok,
    this.tunggakanBunga,
    this.tunggakanDenda,
    this.tunggakanHari,
    this.nomorHp,
  });

  factory CreditDetailModel.fromJson(Map<String, dynamic> json) {
    return CreditDetailModel(
      id: json['id'] as int? ?? 0,
      nomorCif: json['nomor_cif']?.toString(),
      nomorRekening: json['nomor_rekening']?.toString() ?? '',
      nomorAlt: json['nomor_alt']?.toString(),
      kodeProduk: json['kode_produk']?.toString(),
      namaDebitur: json['nama_debitur']?.toString() ?? '',
      plafondAwal: json['plafond_awal']?.toString(),
      bakiDebet: json['baki_debet']?.toString(),
      metodeRps: json['metode_rps']?.toString(),
      jangkaWaktu: json['jangka_waktu']?.toString(),
      tglRealisasi: json['tgl_realisasi']?.toString(),
      tglJatuhTempo: json['tgl_jatuh_tempo']?.toString(),
      rate: json['rate']?.toString(),
      coll: json['coll']?.toString(),
      wilayah: json['wilayah']?.toString(),
      bidang: json['bidang']?.toString(),
      alamat: json['alamat']?.toString(),
      kolektor: json['kolektor']?.toString(),
      resort: json['resort']?.toString(),
      hariPokok: json['hari_pokok']?.toString(),
      hariBunga: json['hari_bunga']?.toString(),
      tunggakanPokok: json['tunggakan_pokok']?.toString(),
      tunggakanBunga: json['tunggakan_bunga']?.toString(),
      tunggakanDenda: json['tunggakan_denda']?.toString(),
      tunggakanHari: json['tunggakan_hari']?.toString(),
      nomorHp: json['nomor_hp']?.toString(),
    );
  }
}

class CollateralModel {
  final int id;
  final String? noreg;
  final String? noregAlt;
  final String? nomorRekening;
  final String? nomorAlt;
  final String nama;

  const CollateralModel({
    required this.id,
    this.noreg,
    this.noregAlt,
    this.nomorRekening,
    this.nomorAlt,
    required this.nama,
  });

  factory CollateralModel.fromJson(Map<String, dynamic> json) {
    return CollateralModel(
      id: json['id'] as int? ?? 0,
      noreg: json['noreg']?.toString(),
      noregAlt: json['noreg_alt']?.toString(),
      nomorRekening: json['nomor_rekening']?.toString(),
      nomorAlt: json['nomor_alt']?.toString(),
      nama: json['nama']?.toString() ?? '',
    );
  }
}

class TaskModel {
  final int id;
  final String? kode;
  final String? nomorRekening;
  final String namaLengkap;
  final String? tanggal;
  final String? jenis;
  final String? pelaksanaan;
  final String? pelaksanaanDetail;
  final String? hasil;
  final String? hasilDetail;
  final String? janjiBayar;
  final String? catatan;
  final String? foto;
  final String? tunggakanPokok;
  final String? tunggakanBunga;
  final String? tunggakanDenda;
  final String? klasifikasi;
  final String? status;
  final int? makerId;
  final int? executorId;

  const TaskModel({
    required this.id,
    this.kode,
    this.nomorRekening,
    required this.namaLengkap,
    this.tanggal,
    this.jenis,
    this.pelaksanaan,
    this.pelaksanaanDetail,
    this.hasil,
    this.hasilDetail,
    this.janjiBayar,
    this.catatan,
    this.foto,
    this.tunggakanPokok,
    this.tunggakanBunga,
    this.tunggakanDenda,
    this.klasifikasi,
    this.status,
    this.makerId,
    this.executorId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int? ?? 0,
      kode: json['kode']?.toString(),
      nomorRekening: json['nomor_rekening']?.toString(),
      namaLengkap: json['nama_lengkap']?.toString() ?? '',
      tanggal: json['tanggal']?.toString(),
      jenis: json['jenis']?.toString(),
      pelaksanaan: json['pelaksanaan']?.toString(),
      pelaksanaanDetail: json['pelaksanaan_detail']?.toString(),
      hasil: json['hasil']?.toString(),
      hasilDetail: json['hasil_detail']?.toString(),
      janjiBayar: json['janji_bayar']?.toString(),
      catatan: json['catatan']?.toString(),
      foto: json['foto']?.toString(),
      tunggakanPokok: json['tunggakan_pokok']?.toString(),
      tunggakanBunga: json['tunggakan_bunga']?.toString(),
      tunggakanDenda: json['tunggakan_denda']?.toString(),
      klasifikasi: json['klasifikasi']?.toString(),
      status: json['status']?.toString(),
      makerId: json['maker_id'] as int?,
      executorId: json['executor_id'] as int?,
    );
  }
}
