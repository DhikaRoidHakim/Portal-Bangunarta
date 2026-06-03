import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/models/simontok/list_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/detail_pinjaman_model.dart';
import 'package:bangunarta_portal/models/simontok/list_tugas_model.dart';
import 'simontok_repository.dart';

/// Notifier to manage the search query for the Simontok loans list.
class SimontokSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider for the search query.
final simontokSearchQueryProvider =
    NotifierProvider<SimontokSearchQuery, String>(() {
  return SimontokSearchQuery();
});

/// FutureProvider that fetches the list of loans from the repository,
/// reactive to both user authentication state (alias) and search queries.
final listPinjamanProvider = FutureProvider.autoDispose<ListPinjamanModel>((ref) async {
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

/// FutureProvider.family that fetches details for a specific loan account.
final detailPinjamanProvider =
    FutureProvider.autoDispose.family<DetailPinjamanModel, String>((ref, noRekening) async {
  return SimontokRepository.instance.getDetailPinjaman(noRekening);
});

/// Notifier to manage the search query for the Simontok tasks list.
class SimontokTugasSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider for the tugas search query.
final simontokTugasSearchQueryProvider =
    NotifierProvider<SimontokTugasSearchQuery, String>(() {
  return SimontokTugasSearchQuery();
});

/// FutureProvider that fetches the list of tasks from the repository,
/// reactive to both user authentication state (alias) and search queries.
final listTugasProvider = FutureProvider.autoDispose<ListTugasModel>((ref) async {
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
