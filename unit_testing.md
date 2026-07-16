# Analisis Mendalam & Rancangan Unit Testing - Black Box Method

## Portal Bangunarta (Super App)

Dokumen ini berisi analisis arsitektur proyek **Portal Bangunarta**, penjelasan prinsip pengujian **Black Box**, rancangan skenario pengujian unit (unit testing) untuk masing-masing modul utama, serta contoh implementasi kode tes di Flutter.

---

## 1. Analisis Arsitektur Proyek & Aliran Data

Portal Bangunarta dirancang menggunakan pola **Feature-First Architecture** yang dikombinasikan dengan sebuah **Core Shared Layer**. Struktur ini memisahkan logika bisnis global yang digunakan bersama dari logika fungsional spesifik per modul.

### Komponen Utama Arsitektur:

1. **Core Layer (`lib/core/`)**:
    - [auth_provider.dart](file:///c:/development/project/bangunarta_portal/lib/core/auth/auth_provider.dart): Jantung manajemen status otentikasi global. Menggunakan Riverpod [AuthNotifier](file:///c:/development/project/bangunarta_portal/lib/core/auth/auth_provider.dart#L57) untuk melacak status login pengguna ([AuthState](file:///c:/development/project/bangunarta_portal/lib/core/auth/auth_provider.dart#L14)).
    - [auth_repository.dart](file:///c:/development/project/bangunarta_portal/lib/core/auth/auth_repository.dart): Menangani komunikasi otentikasi dengan backend dan penyimpanan token JWT terenkripsi via `FlutterSecureStorage`.
    - [dio_client.dart](file:///c:/development/project/bangunarta_portal/lib/core/network/dio_client.dart): Klien HTTP tunggal (Singleton) berbasis `Dio` yang otomatis menginjeksikan header `Authorization: Bearer <token>` dan menangani penyegaran token otomatis jika terjadi error `401 Unauthorized`.
2. **Features Layer (`lib/features/`)**:
    - [auth](file:///c:/development/project/bangunarta_portal/lib/features/auth): Halaman login dan verifikasi biometrik.
    - [samba](file:///c:/development/project/bangunarta_portal/lib/features/samba): Modul setoran kolektor tabungan nasabah.
    - [simontok](file:///c:/development/project/bangunarta_portal/lib/features/simontok): Modul pemantauan kredit nasabah, penagihan, verifikasi agunan, dan pengelolaan prospek.
    - [helpdesk](file:///c:/development/project/bangunarta_portal/lib/features/helpdesk): Modul pelaporan kendala infrastruktur dan dukungan IT.
    - [sipebri](file:///c:/development/project/bangunarta_portal/lib/features/sipebri): Modul sistem permohonan kredit (survey dan tracking) yang saat ini berstatus **Under Development**.

---

## 2. Metodologi Black Box Unit Testing

**Black Box Unit Testing** adalah metode pengujian perangkat lunak di mana fungsionalitas dari unit yang diuji (kelas, notifier, repositori, atau fungsi) divalidasi secara murni berdasarkan spesifikasi input dan ekspektasi output-nya, tanpa melihat atau menguji alur eksekusi internal kode (statement coverage, branch logic internal, dsb.).

---

## 3. Skenario Pengujian Unit (Black Box) Per Modul

### 3.1. Modul Otentikasi & Keamanan (Core Auth)

_Target Pengujian_: [AuthNotifier](file:///c:/development/project/bangunarta_portal/lib/core/auth/auth_provider.dart#L57) & [AuthRepository](file:///c:/development/project/bangunarta_portal/lib/core/auth/auth_repository.dart)

| ID Kasus Uji    | Skenario Pengujian                                                         | Input (Parameter / Kondisi Mocks)                                                                                        | Status Awal State            | Ekspektasi Output / State Akhir                                                                                                       |
| :-------------- | :------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------- | :--------------------------- | :------------------------------------------------------------------------------------------------------------------------------------ |
| **UT-AUTH-001** | Pengujian status otentikasi awal saat aplikasi dibuka jika token tersimpan | Mock `SecureStorage` mengembalikan token JWT valid. Mock `AuthRepository.getMe` mengembalikan data profil pengguna.      | `AuthStatus.initial`         | State berubah ke `AuthStatus.loading` kemudian ke `AuthStatus.authenticated` dengan token dan user terisi.                            |
| **UT-AUTH-002** | Pengujian status otentikasi awal jika token kosong/tidak ada               | Mock `SecureStorage` mengembalikan `null` atau `""`.                                                                     | `AuthStatus.initial`         | State berubah ke `AuthStatus.loading` kemudian ke `AuthStatus.unauthenticated`.                                                       |
| **UT-AUTH-003** | Login sukses menggunakan kredensial manual                                 | `username = "kolektor01"`, `password = "Rahasia123"`, device metadata terisi. Mock API login mengembalikan token sukses. | `AuthStatus.unauthenticated` | State berubah ke `AuthStatus.loading` kemudian ke `AuthStatus.authenticated`. Token tersimpan di `SecureStorage`.                     |
| **UT-AUTH-004** | Login gagal karena password salah                                          | `username = "kolektor01"`, `password = "salah"`. Mock API login melempar error `DioException` (401 Unauthorized).        | `AuthStatus.unauthenticated` | State berubah ke `AuthStatus.loading` kemudian ke `AuthStatus.error` dengan pesan error `"Password salah atau akun tidak ditemukan"`. |
| **UT-AUTH-005** | Logout dari aplikasi                                                       | Panggilan fungsi `logout()`. Mock API logout berhasil.                                                                   | `AuthStatus.authenticated`   | State berubah ke `AuthStatus.loading` kemudian ke `AuthStatus.unauthenticated`. Token dihapus dari `SecureStorage`.                   |
| **UT-AUTH-006** | Force logout akibat token kadaluwarsa                                      | Panggilan fungsi `forceUnauthenticated()`.                                                                               | `AuthStatus.authenticated`   | State langsung berubah ke `AuthStatus.unauthenticated` tanpa melalui fase loading.                                                    |

---

### 3.2. Modul SAMBA (Saving Mobile Bangunarta)

_Target Pengujian_: [SambaSimpananNotifier](file:///c:/development/project/bangunarta_portal/lib/features/samba/providers/samba_provider.dart#L72), [SambaTransaksiNotifier](file:///c:/development/project/bangunarta_portal/lib/features/samba/providers/samba_provider.dart#L216), [SambaRepository](file:///c:/development/project/bangunarta_portal/lib/features/samba/repository/samba_repository.dart), & [ThermalPrinterService](file:///c:/development/project/bangunarta_portal/lib/features/samba/services/thermal_printer_service.dart)

| ID Kasus Uji     | Skenario Pengujian                                          | Input (Parameter / Kondisi Mocks)                                                                         | Status Awal / Parameter | Ekspektasi Output / Efek Samping                                                                                      |
| :--------------- | :---------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------- | :---------------------- | :-------------------------------------------------------------------------------------------------------------------- |
| **UT-SAMBA-001** | Pencarian daftar simpanan nasabah                           | `searchQuery = "Budi"`. Mock API mengembalikan list nasabah yang namanya mengandung kata "Budi".          | String pencarian aktif  | `SambaSimpananState` terupdate berisi data nasabah yang sesuai. Indikator `hasMore` sesuai payload API.               |
| **UT-SAMBA-002** | Pengisian nominal setoran valid                             | `nomorRekening = "102.03.0045"`, `nominal = 50000` (Positif). Mock API deposit sukses.                    | Form detail rekening    | Menghasilkan objek `TransactionResponseModel` sukses. Saldo nasabah pada screen ter-refresh secara real-time.         |
| **UT-SAMBA-003** | Pengisian nominal setoran tidak valid                       | `nomorRekening = "102.03.0045"`, `nominal = -10000` atau `0`.                                             | Form detail rekening    | Form validasi lokal menghasilkan error ("Nominal harus lebih besar dari 0"). Request ke API dibatalkan.               |
| **UT-SAMBA-004** | Koneksi dan pencetakan struk transaksi ke printer Bluetooth | Perangkat printer terpasang (paired). Mock `PrintBluetoothThermal` mengembalikan status sukses terhubung. | Transaksi sukses        | Printer mencetak struk format 58mm berisi logo, nomor transaksi, nama nasabah, nominal setoran, dan nama kolektor.    |
| **UT-SAMBA-005** | Penanganan kegagalan pencetakan karena printer terputus     | Printer tiba-tiba mati/out of range. Mock `PrintBluetoothThermal` mengembalikan false saat print.         | Transaksi sukses        | Tampilan dialog peringatan ("Koneksi printer terputus. Pastikan printer menyala dan coba lagi").                      |
| **UT-SAMBA-006** | Ekspor laporan transaksi harian ke PDF                      | Data transaksi terisi. Panggilan fungsi `ExportTransaksiService.exportToPdf`.                             | Tab riwayat transaksi   | Sistem berhasil menulis berkas PDF ke direktori Scoped Storage (`Download/SAMBA/`) dan menampilkan notifikasi sukses. |

---

### 3.3. Modul SIMONTOK (Sistem Monitoring Kredit)

_Target Pengujian_: [SimontokRepository](file:///c:/development/project/bangunarta_portal/lib/features/simontok/providers/simontok_repository.dart) & [SimontokSearchQuery](file:///c:/development/project/bangunarta_portal/lib/features/simontok/providers/simontok_provider.dart#L12)

| ID Kasus Uji   | Skenario Pengujian                                                    | Input (Parameter / Kondisi Mocks)                                                                                                                                | Status Parameter       | Ekspektasi Output / Efek Samping                                                                                              |
| :------------- | :-------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| **UT-MON-001** | Pengiriman laporan penagihan dengan opsi "Janji Bayar"                | `taskId = 45`, `pelaksanaan = "Kunjungan Lapangan"`, `hasilPelaksanaan = "Janji Bayar"`, `janjiBayar = "2026-07-20"`, `fotoPenanganan` berupa file gambar valid. | Form Laporan Penagihan | API mengembalikan `SubmitLaporanResponseModel` dengan status sukses. Tugas terkait berubah status menjadi selesai/dilaporkan. |
| **UT-MON-002** | Validasi input laporan "Janji Bayar" tanpa mencantumkan tanggal janji | `hasilPelaksanaan = "Janji Bayar"`, `janjiBayar = ""` (Kosong).                                                                                                  | Form Laporan Penagihan | Validasi form menolak pengiriman dan memunculkan error ("Tanggal janji bayar wajib diisi jika memilih opsi Janji Bayar").     |
| **UT-MON-003** | Submit laporan verifikasi kelayakan kredit (pinjaman & jaminan)       | `penggunaKredit = "Sendiri"`, `kondisiJaminan = "Sangat Baik"`, `penguasaanJaminan = "Dikuasai Debitur"`. Foto agunan disertakan.                                | Form Verifikasi        | API verifikasi pinjaman dan verifikasi jaminan berhasil diposting. Respon sukses diterima dari server.                        |
| **UT-MON-004** | Pembuatan prospek debitur baru dengan foto wajib                      | `namaLengkap = "Anang"`, `nomorHp = "08123456789"`, `jenisProspek = "Survey"`, `statusProspek = "Proses"`, `fotoProspek` = `File` valid.                         | Tambah Prospek Baru    | Prospek berhasil disimpan di database local/server dan daftar prospek diperbarui.                                             |
| **UT-MON-005** | Validasi pembuatan prospek debitur tanpa melampirkan foto             | Parameter text lengkap, namun `fotoProspek` = `null`.                                                                                                            | Tambah Prospek Baru    | Tombol submit dinonaktifkan atau menampilkan error ("Foto bukti prospek wajib dilampirkan").                                  |
| **UT-MON-006** | Penghapusan prospek debitur aktif                                     | `prospekId = 12`. Mock API delete mengembalikan sukses.                                                                                                          | Halaman Prospek        | Prospek terhapus dari daftar utama secara langsung dan memunculkan SnackBar sukses.                                           |

---

### 3.4. Modul SIPEBRI (Sistem Permohonan Kredit)

> [!IMPORTANT]
> **STATUS: UNDER DEVELOPMENT (Sedang Dalam Pengembangan)**
>
> Modul [sipebri](file:///c:/development/project/bangunarta_portal/lib/features/sipebri) saat ini masih dalam tahap konstruksi awal oleh tim pengembang (meliputi halaman survey dan pelacakan timeline pengajuan).
>
> **Rencana Pengujian Black Box Masa Depan:**
>
> - Rencana uji fungsionalitas dan skenario unit testing untuk modul ini ditunda hingga struktur database, model data, dan kontrak endpoint API diselesaikan oleh tim backend dan mobile.
> - Ketika modul ini siap, pengujian black box utama akan ditargetkan pada:
>     1. Validasi akurasi status visual pada komponen timeline tracking pengajuan kredit (tahap 1 s.d 7).
>     2. Keabsahan pengisian formulir survey kelayakan usaha (input numerik pendapatan, pengeluaran, rasio utang).
>     3. Upload dokumen fisik pendukung survey (KTP, KK, NPWP, Surat Keterangan Usaha) melalui media picker.

---

## 4. Panduan Implementasi Unit Testing di Flutter

Berikut adalah contoh praktis penulisan kode unit testing menggunakan metode Black Box di Flutter. Kita akan mensimulasikan dependensi luar menggunakan paket `mocktail` (paket mock yang populer di Flutter).

### 4.1. Setup Dependencies di `pubspec.yaml`

Tambahkan paket mocking di bagian `dev_dependencies`:

```yaml
dev_dependencies:
    flutter_test:
        sdk: flutter
    mocktail: ^1.0.4 # Digunakan untuk mocking API dan Repositori
```

### 4.2. Contoh Kode Pengujian: `auth_notifier_test.dart`

Buat berkas tes di direktori `test/features/auth/auth_notifier_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/auth/auth_repository.dart';
import 'package:bangunarta_portal/models/auth/auth_token_model.dart';
import 'package:bangunarta_portal/models/auth/auth_me_model.dart';

// Membuat kelas tiruan untuk AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    // Registrasi singleton instance dengan Mock jika arsitekturnya mengizinkan,
    // atau gunakan provider overrides untuk menyisipkan mock ke Riverpod container.
    container = ProviderContainer(
      overrides: [
        // Contoh jika repository diinject lewat provider
        // authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier Black Box Unit Tests', () {
    test('UT-AUTH-002: Status awal harus unauthenticated jika token kosong', () async {
      // Arrange - Setup mock behavior
      // Misalkan getAccessToken mengembalikan null (tidak ada token tersimpan)
      when(() => mockAuthRepository.getAccessToken()).thenAnswer((_) async => null);

      final notifier = container.read(authProvider.notifier);

      // Act - Jalankan fungsi yang diuji
      await notifier.checkAuth();

      // Assert - Verifikasi output / perubahan state
      final finalState = container.read(authProvider);
      expect(finalState.status, equals(AuthStatus.unauthenticated));
      expect(finalState.token, isNull);
    });

    test('UT-AUTH-003: Login Sukses dengan Kredensial Valid', () async {
      // Arrange - Setup data sukses
      final dummyToken = AuthTokenModel(
        accessToken: 'jwt_secret_token_123',
        tokenType: 'Bearer',
        expiresIn: 3600,
      );
      final dummyUser = AuthMeModel(
        success: true,
        user: UserData(
          id: 1,
          username: 'kolektor01',
          name: 'Budi Kolektor',
          collectorCode: 'COL001',
          alias: 'budi_col',
        ),
      );

      when(() => mockAuthRepository.login(
        username: 'kolektor01',
        password: 'Rahasia123',
        deviceIdentifier: 'dev_123',
        deviceName: 'Android Phone',
        deviceOs: 'Android 13',
        fmcToken: '',
      )).thenAnswer((_) async => dummyToken);

      when(() => mockAuthRepository.getMe()).thenAnswer((_) async => dummyUser);

      final notifier = container.read(authProvider.notifier);

      // Act
      await notifier.login(
        username: 'kolektor01',
        password: 'Rahasia123',
        deviceIdentifier: 'dev_123',
        deviceName: 'Android Phone',
        deviceOs: 'Android 13',
      );

      // Assert
      final finalState = container.read(authProvider);
      expect(finalState.status, equals(AuthStatus.authenticated));
      expect(finalState.token?.accessToken, equals('jwt_secret_token_123'));
      expect(finalState.user?.user.name, equals('Budi Kolektor'));
    });

    test('UT-AUTH-004: Login Gagal melempar Exception', () async {
      // Arrange - Simulasikan API melempar error unauthorized
      when(() => mockAuthRepository.login(
        username: 'kolektor01',
        password: 'salah_password',
        deviceIdentifier: 'dev_123',
        deviceName: 'Android Phone',
        deviceOs: 'Android 13',
        fmcToken: '',
      )).thenThrow(Exception('Password salah atau akun tidak ditemukan'));

      final notifier = container.read(authProvider.notifier);

      // Act & Assert
      expect(
        () => notifier.login(
          username: 'kolektor01',
          password: 'salah_password',
          deviceIdentifier: 'dev_123',
          deviceName: 'Android Phone',
          deviceOs: 'Android 13',
        ),
        throwsA(isA<Exception>()),
      );

      final finalState = container.read(authProvider);
      expect(finalState.status, equals(AuthStatus.error));
      expect(finalState.errorMessage, contains('Password salah'));
    });
  });
}
```

### 4.3. Cara Menjalankan Unit Testing

Jalankan perintah berikut di terminal root proyek untuk mengeksekusi semua berkas uji yang telah dibuat:

```bash
flutter test
```

Untuk melihat detail coverage dari tes yang dijalankan:

```bash
flutter test --coverage
```

Hasil file coverage (`coverage/lcov.info`) dapat dibaca menggunakan ekstensi LCOV Viewer di VS Code atau dikonversi menjadi berkas HTML untuk dianalisis lebih lanjut.
