import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/models/simontok/list_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';
import 'package:bangunarta_portal/models/simontok/list_prospek_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_prospek_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_tugas_model.dart';
import 'simontok_repository.dart';

// Notifier untuk mengelola query pencarian untuk daftar pinjaman Simontok.
class SimontokSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider untuk query pencarian.
final simontokSearchQueryProvider =
    NotifierProvider<SimontokSearchQuery, String>(() {
      return SimontokSearchQuery();
    });

// FutureProvider yang mengambil daftar pinjaman dari repository,
final listPinjamanProvider = FutureProvider.autoDispose<ListPinjamanModel>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final alias = authState.user?.user.alias;

  if (alias == null || alias.isEmpty) {
    throw Exception('User alias tidak ditemukan. Silakan login kembali.');
  }

  final searchQuery = ref.watch(simontokSearchQueryProvider);

  return SimontokRepository.instance.getListPinjaman(
    alias: alias,
    search: searchQuery.trim().isEmpty ? null : searchQuery,
  );
});

// FutureProvider.family yang mengambil detail untuk akun pinjaman tertentu.
final detailPinjamanProvider = FutureProvider.autoDispose
    .family<DetailPinjamanModel, String>((ref, noRekening) async {
      return SimontokRepository.instance.getDetailPinjaman(noRekening);
    });

// Notifier untuk mengelola query pencarian untuk daftar tugas Simontok.
class SimontokTugasSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

// Provider untuk query pencarian tugas.
final simontokTugasSearchQueryProvider =
    NotifierProvider<SimontokTugasSearchQuery, String>(() {
      return SimontokTugasSearchQuery();
    });

// FutureProvider yang mengambil daftar tugas dari repository,
final listTugasProvider = FutureProvider.autoDispose<ListTugasModel>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final alias = authState.user?.user.alias;

  if (alias == null || alias.isEmpty) {
    throw Exception('User alias tidak ditemukan. Silakan login kembali.');
  }

  final searchQuery = ref.watch(simontokTugasSearchQueryProvider);

  return SimontokRepository.instance.getListTugas(
    alias: alias,
    search: searchQuery.trim().isEmpty ? null : searchQuery,
  );
});

// Notifier untuk mengelola query pencarian untuk daftar prospek Simontok.
class SimontokProspekSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

// Provider untuk query pencarian prospek.
final simontokProspekSearchQueryProvider =
    NotifierProvider<SimontokProspekSearchQuery, String>(() {
      return SimontokProspekSearchQuery();
    });

// FutureProvider yang mengambil daftar prospek dari repository,
final listProspekProvider = FutureProvider.autoDispose<ListProspekModel>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final alias = authState.user?.user.alias;

  if (alias == null || alias.isEmpty) {
    throw Exception('User alias tidak ditemukan. Silakan login kembali.');
  }

  final searchQuery = ref.watch(simontokProspekSearchQueryProvider);

  return SimontokRepository.instance.getListProspek(
    alias: alias,
    search: searchQuery.trim().isEmpty ? null : searchQuery,
  );
});

// FutureProvider.family yang mengambil detail prospek dari repository.
final detailProspekProvider = FutureProvider.autoDispose
    .family<DetailProspekModel, int>((ref, id) async {
      return SimontokRepository.instance.getDetailProspek(id);
    });

// FutureProvider.family yang mengambil detail tugas dari repository.
final detailTugasProvider = FutureProvider.autoDispose
    .family<DetailTugasModel, int>((ref, id) async {
      return SimontokRepository.instance.getDetailTugas(id);
    });
