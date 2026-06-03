import 'package:bangunarta_portal/core/auth/auth_provider.dart';
import 'package:bangunarta_portal/core/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bangunarta_portal/core/theme/theme.dart';

// Refresh Profile
Future<void> refreshProfile(WidgetRef ref) async {
  await ref.read(authProvider.notifier).checkAuth();
}

// menampikan Biometric Setting dari auth provider
Future<void> loadBiometricSetting(
  BuildContext context,
  void Function(bool) onSettingLoaded,
) async {
  final isEnabled = await AuthRepository.instance.isBiometricEnabled();

  if (!context.mounted) return;

  onSettingLoaded(isEnabled);
}
