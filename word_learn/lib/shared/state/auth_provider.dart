import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../auth/auth_repository.dart';
import '../auth/auth_user.dart';

// ── Auth state ────────────────────────────────────────────────────────────────

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
    this.isLoading = false,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? error;
  final bool isLoading;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
    bool? isLoading,
    bool clearError = false,
    bool clearUser = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: clearUser ? null : (user ?? this.user),
        error: clearError ? null : (error ?? this.error),
        isLoading: isLoading ?? this.isLoading,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  AuthRepository get _repo => AuthRepository.instance;

  // ── Called from SplashScreen ────────────────────────────────────────────────

  /// Returns the destination route after startup checks.
  /// Respects [AppConfig.devModeSkipAuth].
  Future<AuthStartupResult> checkStartupAuth() async {
    if (AppConfig.devModeSkipAuth) {
      // Dev bypass — act as if a mock user is always signed in.
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: AuthUser.devMock(),
      );
      return AuthStartupResult.devBypass;
    }

    // Try to restore session from secure storage.
    final storedUser = await _repo.loadStoredUser();
    if (storedUser == null) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      );
      return AuthStartupResult.noSession;
    }

    // Session exists — mark authenticated with cached data, then refresh
    // from server in the background (non-blocking).
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: storedUser,
    );
    _refreshUserInBackground();
    return AuthStartupResult.sessionRestored;
  }

  void _refreshUserInBackground() async {
    final fresh = await _repo.fetchMe();
    if (fresh != null) {
      state = state.copyWith(user: fresh);
    }
  }

  // ── Sign Up ──────────────────────────────────────────────────────────────────

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repo.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
    if (result.isSuccess) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        isLoading: false,
      );
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: result.error,
    );
    return false;
  }

  // ── Sign In ──────────────────────────────────────────────────────────────────

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repo.signIn(email: email, password: password);
    if (result.isSuccess) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        isLoading: false,
      );
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: result.error,
    );
    return false;
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await _repo.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// ignore: library_private_types_in_public_api
enum AuthStartupResult { devBypass, sessionRestored, noSession }

// ── Provider ──────────────────────────────────────────────────────────────────

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
