import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/local_storage_service.dart';

/// WL-410: GDPR Data Export.
///
/// Collects all user data stored in local SQLite and serialises it to a
/// human-readable JSON file the user can save / share from the native share
/// sheet.
///
/// What is included:
///   - User settings (display name, preferences)
///   - Onboarding configuration (languages, CEFR, curfew, drip)
///   - Streak state
///   - Active Batch entries (all languages)
///   - Vault entries
///   - Export metadata (app version, timestamp)
///
/// What is NOT included:
///   - Passwords, tokens, or any authentication secrets
///   - Encrypted cloud backup blob (the user already has that via backup sync)
class DataExportService {
  DataExportService._();
  static final DataExportService instance = DataExportService._();

  /// Builds the export JSON, writes it to a temp file, and opens the native
  /// share sheet so the user can save it to Files, email it, etc.
  ///
  /// Returns `true` on success, `false` if the export failed for any reason.
  Future<bool> exportAndShare() async {
    try {
      final storage = LocalStorageService.instance;

      // ── 1. Collect all data ───────────────────────────────────────────────
      final settings = await storage.getAllSettings();
      final streakRow = await storage.loadStreak();
      final batchRows = await storage.loadAllBatchEntriesRaw();
      final vaultRows = await storage.loadAllVaultEntriesRaw();

      // Scrub any sensitive keys from settings before export.
      final safeSettings = Map<String, String>.from(settings)
        ..remove('auth.backup_password')
        ..remove('auth.access_token')
        ..remove('auth.refresh_token');

      // ── 2. Build export document ──────────────────────────────────────────
      final export = {
        'export_metadata': {
          'app': 'WordLearn',
          'format_version': 1,
          'exported_at': DateTime.now().toUtc().toIso8601String(),
          'note':
              'This file contains your personal learning data exported from WordLearn. '
              'It does not contain passwords or authentication tokens.',
        },
        'settings': safeSettings,
        'streak': streakRow,
        'active_batch': {'count': batchRows.length, 'entries': batchRows},
        'vault': {'count': vaultRows.length, 'entries': vaultRows},
      };

      // ── 3. Write to temp file ─────────────────────────────────────────────
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .substring(0, 19);
      final file = File('${dir.path}/wordlearn_export_$timestamp.json');

      const encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(export), encoding: utf8);

      // ── 4. Open native share sheet ────────────────────────────────────────
      final xFile = XFile(
        file.path,
        mimeType: 'application/json',
        name: 'wordlearn_export_$timestamp.json',
      );

      final result = await Share.shareXFiles([
        xFile,
      ], subject: 'WordLearn — My Learning Data');

      // ShareResultStatus.dismissed means the user cancelled — still a success
      // from our perspective (data was prepared; they just didn't pick a target).
      return result.status != ShareResultStatus.unavailable;
    } catch (_) {
      return false;
    }
  }
}
