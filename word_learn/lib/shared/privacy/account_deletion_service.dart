import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../auth/auth_repository.dart';
import '../services/database_service.dart';

/// WL-410: Account deletion — GDPR "Right to Erasure".
///
/// Deletion sequence:
///   1. Call DELETE /api/v1/user/delete on the backend.
///      → Server soft-deletes the user row (is_active=false, deletion scheduled
///        in 30 days) and deletes the backup blob immediately.
///   2. Clear all local SQLite data.
///   3. Wipe all tokens from Flutter Secure Storage.
///
/// The caller (SettingsScreen) is responsible for navigating to the Auth
/// screen after a successful deletion.
class AccountDeletionService {
  AccountDeletionService._();
  static final AccountDeletionService instance = AccountDeletionService._();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Returns `null` on success, or an error string on failure.
  Future<String?> deleteAccount() async {
    // ── 1. Tell the server ────────────────────────────────────────────────
    // In dev mode we skip the network call — there's no real user to delete.
    if (!AppConfig.devModeSkipAuth) {
      final token = await AuthRepository.instance.accessToken;
      if (token == null) {
        return 'Not signed in. Please sign in and try again.';
      }

      try {
        final resp = await http
            .delete(
              Uri.parse('${AppConfig.apiBaseUrl}/user/delete'),
              headers: {'Authorization': 'Bearer $token'},
            )
            .timeout(const Duration(seconds: 20));

        if (resp.statusCode != 200 && resp.statusCode != 204) {
          return 'Server error (${resp.statusCode}). Please try again later.';
        }
      } catch (e) {
        return 'Network error: ${e.toString()}';
      }
    }

    // ── 2. Wipe local SQLite ──────────────────────────────────────────────
    try {
      await DatabaseService.instance.clearAll();
    } catch (_) {
      // Non-fatal — carry on to wipe tokens.
    }

    // ── 3. Wipe all secure-storage tokens ────────────────────────────────
    try {
      await _storage.deleteAll();
    } catch (_) {}

    return null; // success
  }
}
