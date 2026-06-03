import 'package:bangunarta_portal/core/auth/auth_repository.dart';
import 'package:bangunarta_portal/models/auth/auth_me_model.dart';
import 'package:bangunarta_portal/models/auth/auth_token_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final AuthTokenModel? token;
  final AuthMeModel? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.token,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(AuthTokenModel token, AuthMeModel user) =>
      AuthState(
        status: AuthStatus.authenticated,
        token: token,
        user: user,
      );
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  AuthState copyWith({
    AuthStatus? status,
    AuthTokenModel? token,
    AuthMeModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState.initial();
  }

  Future<void> checkAuth() async {
    state = AuthState.loading();
    try {
      final token = await AuthRepository.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        state = AuthState.unauthenticated();
        return;
      }
      final user = await AuthRepository.instance.getMe();
      final tokenModel = AuthTokenModel(
        accessToken: token,
        tokenType: 'Bearer',
        expiresIn: 0,
      );
      state = AuthState.authenticated(tokenModel, user);
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String username,
    required String password,
    required String deviceIdentifier,
    required String deviceName,
    required String deviceOs,
    String fmcToken = '',
  }) async {
    state = AuthState.loading();
    try {
      final token = await AuthRepository.instance.login(
        username: username,
        password: password,
        deviceIdentifier: deviceIdentifier,
        deviceName: deviceName,
        deviceOs: deviceOs,
        fmcToken: fmcToken,
      );
      final user = await AuthRepository.instance.getMe();
      state = AuthState.authenticated(token, user);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      state = AuthState.error(message);
      throw Exception(message);
    }
  }

  Future<void> logout() async {
    state = AuthState.loading();
    try {
      await AuthRepository.instance.logout();
    } finally {
      state = AuthState.unauthenticated();
    }
  }

  void forceUnauthenticated() {
    state = AuthState.unauthenticated();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
