import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bangunarta_portal/models/sigma/list_assets_model.dart';
import 'package:bangunarta_portal/models/sigma/detail_asset_model.dart';
import 'package:bangunarta_portal/features/sigma/repository/sigma_repository.dart';

class SigmaSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

final sigmaSearchQueryProvider = NotifierProvider<SigmaSearchQuery, String>(() {
  return SigmaSearchQuery();
});

class SigmaOfficeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectOffice(String? officeName) {
    state = officeName;
  }
}

final sigmaOfficeFilterProvider =
    NotifierProvider<SigmaOfficeFilterNotifier, String?>(() {
  return SigmaOfficeFilterNotifier();
});

class SigmaAssetsState {
  final List<AssetsModel> items;
  final String? message;
  final int code;

  const SigmaAssetsState({
    required this.items,
    this.message,
    this.code = 200,
  });
}

class SigmaAssetsNotifier extends AsyncNotifier<SigmaAssetsState> {
  @override
  FutureOr<SigmaAssetsState> build() async {
    final searchQuery = ref.watch(sigmaSearchQueryProvider);

    final model = await SigmaRepository.instance.getListAssets(
      search: searchQuery.trim().isEmpty ? null : searchQuery,
    );

    return SigmaAssetsState(
      items: model.data,
      message: model.message,
      code: model.code,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final searchQuery = ref.read(sigmaSearchQueryProvider);
      final model = await SigmaRepository.instance.getListAssets(
        search: searchQuery.trim().isEmpty ? null : searchQuery,
      );
      return SigmaAssetsState(
        items: model.data,
        message: model.message,
        code: model.code,
      );
    });
  }
}

final sigmaAssetsNotifierProvider =
    AsyncNotifierProvider<SigmaAssetsNotifier, SigmaAssetsState>(() {
  return SigmaAssetsNotifier();
});

/// FutureProvider family untuk mengambil detail aset berdasarkan ID
final sigmaDetailAssetProvider =
    FutureProvider.family<DetailAssetModel, String>((ref, id) async {
  return await SigmaRepository.instance.getDetailAsset(id);
});
