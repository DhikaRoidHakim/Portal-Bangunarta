class AuthMeModel {
  const AuthMeModel({
    required this.employee,
    this.codes,
  });

  final EmployeeModel employee;
  final dynamic codes;

  factory AuthMeModel.fromJson(Map<String, dynamic> json) {
    final employee = json['employee'];

    return AuthMeModel(
      employee: EmployeeModel.fromJson(
        employee is Map<String, dynamic> ? employee : <String, dynamic>{},
      ),
      codes: json['codes'],
    );
  }
}

class EmployeeModel {
  const EmployeeModel({
    this.id,
    this.userId,
    this.nomorKtp,
    this.nomorNpwp,
    this.namaLengkap,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.alamatLengkap,
    this.kodePos,
    this.statusPerkawinan,
    this.jumlahPasangan,
    this.jumlahAnak,
    this.ibuKandung,
    this.pendidikanFormal,
    this.jurusanPendidikanFormal,
    this.pendidikanNonformal1,
    this.pendidikanNonformal2,
    this.pendidikanNonformal3,
    this.nomorAbsen,
    this.nomorKaryawan,
    this.nomorCif,
    this.tanggalBekerja,
    this.tanggalKontrak,
    this.tanggalMutasi,
    this.tanggalKeluar,
    this.jabatan,
    this.nomorSk,
    this.statusBekerja,
    this.kantor,
    this.teleponRumah,
    this.nomorHandphone,
    this.nomorWhatsapp,
    this.alamatEmail,
    this.createdBy,
    this.updatedBy,
    this.authorizedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.authorizedAt,
    this.deletedAt,
  });

  final int? id;
  final int? userId;
  final String? nomorKtp;
  final String? nomorNpwp;
  final String? namaLengkap;
  final String? jenisKelamin;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? alamatLengkap;
  final String? kodePos;
  final String? statusPerkawinan;
  final String? jumlahPasangan;
  final String? jumlahAnak;
  final String? ibuKandung;
  final String? pendidikanFormal;
  final String? jurusanPendidikanFormal;
  final String? pendidikanNonformal1;
  final String? pendidikanNonformal2;
  final String? pendidikanNonformal3;
  final String? nomorAbsen;
  final String? nomorKaryawan;
  final String? nomorCif;
  final String? tanggalBekerja;
  final String? tanggalKontrak;
  final String? tanggalMutasi;
  final String? tanggalKeluar;
  final String? jabatan;
  final String? nomorSk;
  final String? statusBekerja;
  final String? kantor;
  final String? teleponRumah;
  final String? nomorHandphone;
  final String? nomorWhatsapp;
  final String? alamatEmail;
  final String? createdBy;
  final String? updatedBy;
  final String? authorizedBy;
  final String? deletedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? authorizedAt;
  final String? deletedAt;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      nomorKtp: _toString(json['nomor_ktp']),
      nomorNpwp: _toString(json['nomor_npwp']),
      namaLengkap: _toString(json['nama_lengkap']),
      jenisKelamin: _toString(json['jenis_kelamin']),
      tempatLahir: _toString(json['tempat_lahir']),
      tanggalLahir: _toString(json['tanggal_lahir']),
      alamatLengkap: _toString(json['alamat_lengkap']),
      kodePos: _toString(json['kode_pos']),
      statusPerkawinan: _toString(json['status_perkawinan']),
      jumlahPasangan: _toString(json['jumlah_pasangan']),
      jumlahAnak: _toString(json['jumlah_anak']),
      ibuKandung: _toString(json['ibu_kandung']),
      pendidikanFormal: _toString(json['pendidikan_formal']),
      jurusanPendidikanFormal: _toString(json['jurusan_pendidikan_formal']),
      pendidikanNonformal1: _toString(json['pendidikan_nonformal_1']),
      pendidikanNonformal2: _toString(json['pendidikan_nonformal_2']),
      pendidikanNonformal3: _toString(json['pendidikan_nonformal_3']),
      nomorAbsen: _toString(json['nomor_absen']),
      nomorKaryawan: _toString(json['nomor_karyawan']),
      nomorCif: _toString(json['nomor_cif']),
      tanggalBekerja: _toString(json['tanggal_bekerja']),
      tanggalKontrak: _toString(json['tanggal_kontrak']),
      tanggalMutasi: _toString(json['tanggal_mutasi']),
      tanggalKeluar: _toString(json['tanggal_keluar']),
      jabatan: _toString(json['jabatan']),
      nomorSk: _toString(json['nomor_sk']),
      statusBekerja: _toString(json['status_bekerja']),
      kantor: _toString(json['kantor']),
      teleponRumah: _toString(json['telepon_rumah']),
      nomorHandphone: _toString(json['nomor_handphone']),
      nomorWhatsapp: _toString(json['nomor_whatsapp']),
      alamatEmail: _toString(json['alamat_email']),
      createdBy: _toString(json['created_by']),
      updatedBy: _toString(json['updated_by']),
      authorizedBy: _toString(json['authorized_by']),
      deletedBy: _toString(json['deleted_by']),
      createdAt: _toString(json['created_at']),
      updatedAt: _toString(json['updated_at']),
      authorizedAt: _toString(json['authorized_at']),
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
