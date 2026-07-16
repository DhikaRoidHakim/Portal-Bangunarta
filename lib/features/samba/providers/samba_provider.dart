import 'dart:async';
import 'package:bangunarta_portal/features/samba/services/samba_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/models/samba/list_simpanan_model.dart';
import 'package:bangunarta_portal/models/samba/detail_simpanan_model.dart';
import 'package:bangunarta_portal/models/samba/transaction_response_model.dart';
import 'package:bangunarta_portal/models/samba/list_transaksi_model.dart';
import 'package:bangunarta_portal/models/samba/cetak_simpanan_model.dart';
import 'package:bangunarta_portal/features/samba/repository/samba_repository.dart';

/// Provider untuk menginject ExportTransaksiService
final exportTransaksiServiceProvider = Provider<ExportTransaksiService>((ref) {
  return ExportTransaksiService();
});

// Provider untuk menginject ExportKelolaanService
final exportKelolaanServiceProvider = Provider<ExportKelolaanService>((ref) {
  return ExportKelolaanService();
});

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
  final List<SambaSummaryModel> summary;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;

  const SambaTransaksiState({
    required this.items,
    required this.summary,
    this.nextCursor,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  SambaTransaksiState copyWith({
    List<SambaTransactionModel>? items,
    List<SambaSummaryModel>? summary,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return SambaTransaksiState(
      items: items ?? this.items,
      summary: summary ?? this.summary,
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
        summary: [],
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
      summary: model.dataSummary,
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
          summary: model.dataSummary,
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

// Notifer untuk export data kelolaan
class ExportKeloaanNotifier extends AsyncNotifier<bool?> {
  @override
  Future<bool?> build() async => null;

  Future<bool> exportToPdf(BuildContext context) async {
    try {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        final authState = ref.read(authProvider);
        final collectorCode = authState.user?.user.collectorCode;

        if (collectorCode == null || collectorCode.isEmpty) {
          throw Exception('Kode Kolektor Tidak ditemukan');
        }

        final searchQuery = ref.read(sambaSearchQueryProvider);

        // Fetch Semua data dari API untuk list Kelolaan
        final kelolaan = await _fetchAllKelolaan(
          collectorCode: collectorCode,
          search: searchQuery.trim().isEmpty ? null : searchQuery,
        );

        if (kelolaan.isEmpty) {
          throw Exception('Daftar kelolaan Kosong');
        }

        final pdfService = ref.read(exportKelolaanServiceProvider);
        final pdfBytes = await pdfService.generatePdfKelolaan(kelolaan);
        final fileName =
            'listkelolaan_${collectorCode}_${DateTime.now().second}.pdf';

        if (!context.mounted) {
          throw Exception('Halaman Sudah Tidak Tersedia');
        }

        final sucess = await pdfService.savePdfToDownloads(
          context,
          pdfBytes,
          fileName,
        );

        if (!sucess) {
          throw Exception('Gagal Menyimpan PDF ke folder Download');
        }

        return true;
      });

      if (state.hasError) {
        debugPrint('Export error: ${state.error}\n${state.stackTrace}');
      }

      return state.hasError == false && state.value == true;
    } catch (e, stackTrace) {
      debugPrint('Export error: $e\n$stackTrace');
      return false;
    }
  }

  /// Mengambil seluruh data kelolaan dengan mengikuti nextCursor sampai habis
  Future<List<SimpananModel>> _fetchAllKelolaan({
    required String collectorCode,
    String? search,
  }) async {
    final List<SimpananModel> allItems = [];
    String? cursor;
    bool hasMore = true;

    while (hasMore) {
      final model = await SambaRepository.instance.getListSimpanan(
        collectorCode: collectorCode,
        search: search,
        cursor: cursor,
      );
      allItems.addAll(model.data);
      cursor = model.nextCursor;
      hasMore = model.hasMore;
    }
    return allItems;
  }
}

// notifier untuk export data transaksi
class ExportTransaksiNotifier extends AsyncNotifier<bool?> {
  @override
  Future<bool?> build() async => null;

  Future<bool> exportToPdf(BuildContext context) async {
    try {
      state = const AsyncValue.loading();

      state = await AsyncValue.guard(() async {
        final authState = ref.read(authProvider);
        final collectorCode = authState.user?.user.collectorCode;

        if (collectorCode == null || collectorCode.isEmpty) {
          throw Exception('Kode kolektor tidak ditemukan');
        }

        final searchQuery = ref.read(sambaTransaksiSearchQueryProvider);

        // Fetch SEMUA data dari API, bukan cuma yang sudah ke-load di UI
        final transactions = await _fetchAllTransaksi(
          collectorCode: collectorCode,
          search: searchQuery.trim().isEmpty ? null : searchQuery,
        );

        if (transactions.isEmpty) {
          throw Exception('Daftar transaksi kosong');
        }

        final pdfService = ref.read(exportTransaksiServiceProvider);
        final pdfBytes = await pdfService.generatePdf(transactions);
        final fileName =
            'transaksi_${collectorCode}_${DateTime.now().millisecondsSinceEpoch}.pdf';

        if (!context.mounted) {
          throw Exception('Halaman sudah ditutup');
        }

        final success = await pdfService.savePdfToDownloads(
          context,
          pdfBytes,
          fileName,
        );

        if (!success) {
          throw Exception('Gagal menyimpan PDF ke folder Download');
        }

        return true;
      });

      if (state.hasError) {
        debugPrint('Export PDF Error: ${state.error}\n${state.stackTrace}');
      }

      return state.hasError == false && state.value == true;
    } catch (e, stackTrace) {
      debugPrint('Export PDF Catch Error: $e\n$stackTrace');
      return false;
    }
  }

  /// Mengambil seluruh data transaksi dengan mengikuti nextCursor sampai habis.
  Future<List<SambaTransactionModel>> _fetchAllTransaksi({
    required String collectorCode,
    String? search,
  }) async {
    final List<SambaTransactionModel> allItems = [];
    String? cursor;
    bool hasMore = true;

    while (hasMore) {
      final model = await SambaRepository.instance.getListTransaksi(
        collectorCode: collectorCode,
        search: search,
        cursor: cursor,
      );

      allItems.addAll(model.data);
      cursor = model.nextCursor;
      hasMore = model.hasMore;
    }

    return allItems;
  }
}

/// Provider untuk export transaksi ke pdf.
final exportTransaksiNotifierProvider =
    AsyncNotifierProvider<ExportTransaksiNotifier, bool?>(() {
      return ExportTransaksiNotifier();
    });

final exportKelolaanNotifierProvider =
    AsyncNotifierProvider<ExportKeloaanNotifier, bool?>(() {
      return ExportKeloaanNotifier();
    });

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
    .family<CetakSimpananModel, int>((ref, transactionId) async {
      return SambaRepository.instance.getCetakTransaksi(transactionId);
    });
