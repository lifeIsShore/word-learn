import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    supabaseClient: Supabase.instance.client,
    secureStorage: const FlutterSecureStorage(),
  );
}

/// Wraps all authentication operations.
/// Throws [AuthException] on Supabase errors — callers handle them.
class AuthRepository {
  AuthRepository({
    required SupabaseClient supabaseClient,
    required FlutterSecureStorage secureStorage,
  })  : _client = supabaseClient,
        _storage = secureStorage;

  final SupabaseClient _client;
  final FlutterSecureStorage _storage;

  /// Email + password sign up
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: displayName != null ? {'display_name': displayName} : null,
    );
    await _persistSession(response.session);
    return response;
  }

  /// Email + password sign in
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    await _persistSession(response.session);
    return response;
  }

  /// Google OAuth sign in
  Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'wordlearn://auth/callback',
    );
  }

  /// Apple OAuth sign in
  Future<bool> signInWithApple() async {
    return await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'wordlearn://auth/callback',
    );
  }

  /// Sign out and clear stored tokens
  Future<void> signOut() async {
    await _client.auth.signOut();
    await _clearSession();
  }

  /// Restore session from secure storage (called at app start)
  Future<void> restoreSession() async {
    final accessToken = await _storage.read(key: AppConstants.keyAccessToken);
    final refreshToken = await _storage.read(key: AppConstants.keyRefreshToken);

    if (accessToken != null && refreshToken != null) {
      await _client.auth.setSession(accessToken);
    }
  }

  Future<void> _persistSession(Session? session) async {
    if (session == null) return;
    await _storage.write(
      key: AppConstants.keyAccessToken,
      value: session.accessToken,
    );
    await _storage.write(
      key: AppConstants.keyRefreshToken,
      value: session.refreshToken ?? '',
    );
  }

  Future<void> _clearSession() async {
    await _storage.delete(key: AppConstants.keyAccessToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
  }

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => _client.auth.currentUser != null;
}
