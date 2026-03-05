import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import 'auth_user.dart';

/// Result wrapper so callers don't have to catch exceptions.
class AuthResult {
  const AuthResult.success(this.user) : error = null;
  const AuthResult.failure(this.error) : user = null;

  final AuthUser? user;
  final String? error;

  bool get isSuccess => user != null;
}

/// All network + secure-storage operations for auth.
/// Providers call this — UI never touches it directly.
class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Token accessors ─────────────────────────────────────────────────────────

  Future<String?> get accessToken =>
      _storage.read(key: AppConfig.kAccessTokenKey);

  Future<String?> get refreshToken =>
      _storage.read(key: AppConfig.kRefreshTokenKey);

  Future<bool> get hasStoredSession async =>
      (await accessToken) != null;

  /// Loads a user from secure storage without hitting the network.
  /// Returns null if no session is stored.
  Future<AuthUser?> loadStoredUser() async {
    final id = await _storage.read(key: AppConfig.kUserIdKey);
    final email = await _storage.read(key: AppConfig.kUserEmailKey);
    final name = await _storage.read(key: AppConfig.kDisplayNameKey);
    if (id == null || email == null) return null;
    return AuthUser(
      id: id,
      email: email,
      displayName: name ?? 'Scholar',
      subscriptionTier: 'free',   // refreshed from /me on next full load
      isEmailVerified: false,
    );
  }

  // ── Sign Up ──────────────────────────────────────────────────────────────────

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final resp = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'display_name': displayName,
        }),
      );
      return _handleAuthResponse(resp);
    } catch (e) {
      return AuthResult.failure('No internet connection. Check your network.');
    }
  }

  // ── Sign In ──────────────────────────────────────────────────────────────────

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final resp = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return _handleAuthResponse(resp);
    } catch (e) {
      return AuthResult.failure('No internet connection. Check your network.');
    }
  }

  // ── Refresh ───────────────────────────────────────────────────────────────────

  Future<bool> refreshTokens() async {
    final token = await refreshToken;
    if (token == null) return false;
    try {
      final resp = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': token}),
      );
      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        await _storeTokens(
          access: body['access_token'] as String,
          refresh: body['refresh_token'] as String,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  // ── Logout ────────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    // Best-effort server call — we clear locally regardless.
    try {
      final token = await accessToken;
      if (token != null) {
        await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/auth/logout'),
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    } catch (_) {}
    await _clearStorage();
  }

  // ── Fetch current user from server ────────────────────────────────────────────

  Future<AuthUser?> fetchMe() async {
    final token = await accessToken;
    if (token == null) return null;
    try {
      final resp = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp.statusCode == 200) {
        return AuthUser.fromJson(
            jsonDecode(resp.body) as Map<String, dynamic>);
      }
      if (resp.statusCode == 401) {
        // Try a token refresh then retry once.
        final refreshed = await refreshTokens();
        if (refreshed) return fetchMe();
      }
    } catch (_) {}
    return null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  AuthResult _handleAuthResponse(http.Response resp) {
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final user = AuthUser.fromJson(body['user'] as Map<String, dynamic>);
      final tokens = body['tokens'] as Map<String, dynamic>;
      _storeTokens(
        access: tokens['access_token'] as String,
        refresh: tokens['refresh_token'] as String,
      );
      _storeUserMeta(user);
      return AuthResult.success(user);
    }

    // Parse error detail from FastAPI response.
    try {
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final detail = body['detail'];
      if (detail is String) return AuthResult.failure(detail);
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first as Map<String, dynamic>;
        return AuthResult.failure(first['msg'] as String? ?? 'Unknown error.');
      }
    } catch (_) {}

    return AuthResult.failure('Something went wrong (${resp.statusCode}).');
  }

  Future<void> _storeTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: AppConfig.kAccessTokenKey, value: access);
    await _storage.write(key: AppConfig.kRefreshTokenKey, value: refresh);
  }

  Future<void> _storeUserMeta(AuthUser user) async {
    await _storage.write(key: AppConfig.kUserIdKey, value: user.id);
    await _storage.write(key: AppConfig.kUserEmailKey, value: user.email);
    await _storage.write(
        key: AppConfig.kDisplayNameKey, value: user.displayName);
  }

  Future<void> _clearStorage() async {
    await _storage.deleteAll();
  }
}
