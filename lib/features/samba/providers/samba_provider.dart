import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/models/samba/list_simpanan_model.dart';
import 'package:bangunarta_portal/models/samba/detail_simpanan_model.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';
import 'package:bangunarta_portal/models/samba/list_transaksi_model.dart';
import 'package:bangunarta_portal/features/samba/repository/samba_repository.dart';

// State untuk daftar simpanan Samba yang mendukung pagination
class SambaSimpananState {
  final List<SimpananModel> items;
  final int total;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;

  const SambaSimpananState({
    required this.items,
    required this.total,
    this.nextCursor,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  SambaSimpananState copyWith({
    List<SimpananModel>? items,
    int? total,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SambaSimpananState(
      items: items ?? this.items,
      total: total ?? this.total,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// Notifier untuk mengelola query pencarian untuk daftar simpanan Samba.
class SambaSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider untuk query pencarian Samba.
final sambaSearchQueryProvider = NotifierProvider<SambaSearchQuery, String>(() {
  return SambaSearchQuery();
});

/// Notifier Async yang mengelola pengambilan data halaman per halaman (pagination)
class SambaSimpananNotifier extends AsyncNotifier<SambaSimpananState> {
  @override
  FutureOr<SambaSimpananState> build() async {
    final authState = ref.watch(authProvider);
    final collectorCode = authState.user?.user.collectorCode;

    if (collectorCode == null || collectorCode.isEmpty) {
      return const SambaSimpananState(
        items: [],
        total: 0,
        hasMore: false,
        isLoadingMore: false,
      );
    }

    final searchQuery = ref.watch(sambaSearchQueryProvider);

    final model = await SambaRepository.instance.getListSimpanan(
      collectorCode: collectorCode,
      search: searchQuery.trim().isEmpty ? null : searchQuery,
    );

    return SambaSimpananState(
      items: model.data,
      total: model.total,
      nextCursor: model.nextCursor,
      hasMore: model.hasMore,
      isLoadingMore: false,
    );
  }

  /// Memuat halaman berikutnya berdasarkan cursor saat ini
  Future<void> loadMore() async {
    final currentState = state.asData?.value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    // Set status loading more
    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final authState = ref.read(authProvider);
      final collectorCode = authState.user?.user.collectorCode;

      if (collectorCode == null || collectorCode.isEmpty) {
        throw Exception(
          'Kode kolektor tidak ditemukan. Silakan login kembali.',
        );
      }

      final searchQuery = ref.read(sambaSearchQueryProvider);

      final model = await SambaRepository.instance.getListSimpanan(
        collectorCode: collectorCode,
        search: searchQuery.trim().isEmpty ? null : searchQuery,
        cursor: currentState.nextCursor,
      );

      final updatedItems = <SimpananModel>[
        ...currentState.items,
        ...model.data,
      ];

      state = AsyncValue.data(
        SambaSimpananState(
          items: updatedItems,
          total: model.total,
          nextCursor: model.nextCursor,
          hasMore: model.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Kembalikan status loading more ke false jika terjadi error
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }
}

/// Provider untuk mengelola status list simpanan Samba dengan pagination.
final sambaSimpananNotifierProvider =
    AsyncNotifierProvider<SambaSimpananNotifier, SambaSimpananState>(() {
      return SambaSimpananNotifier();
    });

/// Provider untuk mengambil detail simpanan berdasarkan nomor rekening
final detailSimpananProvider = FutureProvider.autoDispose
    .family<DetailSimpananModel, String>((ref, nomorRekening) async {
      return SambaRepository.instance.getDetailSimpanan(nomorRekening);
    });

// State untuk daftar transaksi Samba yang mendukung pagination
class SambaTransaksiState {
  final List<SambaTransactionModel> items;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;

  const SambaTransaksiState({
    required this.items,
    this.nextCursor,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  SambaTransaksiState copyWith({
    List<SambaTransactionModel>? items,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SambaTransaksiState(
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// Notifier untuk mengelola query pencarian untuk daftar transaksi Samba.
class SambaTransaksiSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

/// Provider untuk query pencarian transaksi Samba.
final sambaTransaksiSearchQueryProvider =
    NotifierProvider<SambaTransaksiSearchQuery, String>(() {
      return SambaTransaksiSearchQuery();
    });

/// Notifier Async yang mengelola pengambilan daftar transaksi (pagination)
class SambaTransaksiNotifier extends AsyncNotifier<SambaTransaksiState> {
  @override
  FutureOr<SambaTransaksiState> build() async {
    final authState = ref.watch(authProvider);
    final collectorCode = authState.user?.user.collectorCode;

    if (collectorCode == null || collectorCode.isEmpty) {
      return const SambaTransaksiState(
        items: [],
        hasMore: false,
        isLoadingMore: false,
      );
    }

    final searchQuery = ref.watch(sambaTransaksiSearchQueryProvider);

    final model = await SambaRepository.instance.getListTransaksi(
      collectorCode: collectorCode,
      search: searchQuery.trim().isEmpty ? null : searchQuery,
    );

    return SambaTransaksiState(
      items: model.data,
      nextCursor: model.nextCursor,
      hasMore: model.hasMore,
      isLoadingMore: false,
    );
  }

  /// Memuat halaman berikutnya berdasarkan cursor saat ini
  Future<void> loadMore() async {
    final currentState = state.asData?.value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    // Set status loading more
    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    try {
      final authState = ref.read(authProvider);
      final collectorCode = authState.user?.user.collectorCode;

      if (collectorCode == null || collectorCode.isEmpty) {
        throw Exception(
          'Kode kolektor tidak ditemukan. Silakan login kembali.',
        );
      }

      final searchQuery = ref.read(sambaTransaksiSearchQueryProvider);

      final model = await SambaRepository.instance.getListTransaksi(
        collectorCode: collectorCode,
        search: searchQuery.trim().isEmpty ? null : searchQuery,
        cursor: currentState.nextCursor,
      );

      final updatedItems = <SambaTransactionModel>[
        ...currentState.items,
        ...model.data,
      ];

      state = AsyncValue.data(
        SambaTransaksiState(
          items: updatedItems,
          nextCursor: model.nextCursor,
          hasMore: model.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Kembalikan status loading more ke false jika terjadi error
      state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
    }
  }
}

/// Provider untuk mengelola daftar transaksi Samba.
final sambaTransaksiNotifierProvider =
    AsyncNotifierProvider<SambaTransaksiNotifier, SambaTransaksiState>(() {
      return SambaTransaksiNotifier();
    });

/// Provider untuk mengambil detail transaksi berdasarkan ID
final detailSimpananTransactionProvider = FutureProvider.autoDispose
    .family<TransactionResponseModel, int>((ref, transactionId) async {
      return SambaRepository.instance.getDetailTransaksi(transactionId);
    });

/// Provider untuk cetak transaksi berdasarkan ID
final cetakTransactionProvider = FutureProvider.autoDispose
    .family<TransactionResponseModel, int>((ref, transactionId) async {
      return SambaRepository.instance.getCetakTransaksi(transactionId);
    });
