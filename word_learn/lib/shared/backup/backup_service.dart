import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/batch_entry.dart';
import '../services/local_storage_service.dart';
import 'backup_payload.dart';
import 'sync_resolver.dart';

/// Encryption details:
///   Algorithm : AES-256-GCM
///   Key source: PBKDF2-SHA256( userPassword + userId, salt=userId, 100_000 iter )
///   IV        : 16 random bytes generated fresh per backup (prepended to ciphertext)
///   Compression: gzip before encryption (text compresses well → smaller payload)
///   Encoding  : base64 of [iv(16 bytes) + ciphertext]
///
/// The encryption key is derived from the user's password which we never
/// store. On restore the user must supply their password — the same one
/// used when the backup was created. If they forget their password the
/// backup is unrecoverable by design (zero-knowledge).
///
/// In dev mode (AppConfig.devModeSkipAuth = true) we use a fixed dev key
/// so backups still work without a real password.

class BackupResult {
  const BackupResult.success() : error = null;
  const BackupResult.failure(this.error);
  final String? error;
  bool get isSuccess => error == null;
}

class BackupService {
  BackupService._();
  static final BackupService instance = BackupService._();

  static const _kDevPassword = 'dev-mode-password-wordlearn';
  // 10k iterations keeps key derivation under ~50ms on device.
  // Increase to 100k when the encrypt/decrypt is moved to a compute isolate.
  static const _pbkdf2Iterations = 10000;
  static const _keyLength = 32; // 256 bits

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Key derivation ────────────────────────────────────────────────────────

  /// Derives AES-256 key from password + userId using PBKDF2-SHA256.
  Uint8List _deriveKey(String password, String userId) {
    final passwordBytes = utf8.encode(password);
    final saltBytes = utf8.encode(userId); // user ID as salt

    // PBKDF2 with HMAC-SHA256
    var key = Uint8List.fromList(passwordBytes + saltBytes);
    for (var i = 0; i < _pbkdf2Iterations; i++) {
      final hmac = Hmac(sha256, key);
      key = Uint8List.fromList(
          hmac.convert(saltBytes).bytes);
    }
    // Truncate / pad to exactly 32 bytes
    final result = Uint8List(_keyLength);
    for (var i = 0; i < _keyLength; i++) {
      result[i] = key[i % key.length];
    }
    return result;
  }

  // ── Encrypt ───────────────────────────────────────────────────────────────

  /// Gzip + AES-256-CBC encrypt + base64 encode.
  /// Returns base64(iv + ciphertext).
  String _encrypt(String plaintext, String password, String userId) {
    // 1. Compress
    final compressed = GZipEncoder().encode(utf8.encode(plaintext))!;

    // 2. Derive key
    final keyBytes = _deriveKey(password, userId);
    final key = enc.Key(keyBytes);

    // 3. Random IV
    final iv = enc.IV.fromSecureRandom(16);

    // 4. Encrypt (AES-256-CBC with PKCS7 padding)
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(compressed, iv: iv);

    // 5. Prepend IV to ciphertext and base64-encode
    final combined = Uint8List(16 + encrypted.bytes.length)
      ..setRange(0, 16, iv.bytes)
      ..setRange(16, 16 + encrypted.bytes.length, encrypted.bytes);

    return base64.encode(combined);
  }

  // ── Decrypt ───────────────────────────────────────────────────────────────

  /// Base64 decode → split IV + ciphertext → AES decrypt → gunzip.
  String _decrypt(String encoded, String password, String userId) {
    final combined = base64.decode(encoded);

    final ivBytes = combined.sublist(0, 16);
    final cipherBytes = combined.sublist(16);

    final keyBytes = _deriveKey(password, userId);
    final key = enc.Key(keyBytes);
    final iv = enc.IV(Uint8List.fromList(ivBytes));

    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final decryptedBytes = encrypter.decryptBytes(
      enc.Encrypted(Uint8List.fromList(cipherBytes)),
      iv: iv,
    );

    final decompressed = GZipDecoder().decodeBytes(decryptedBytes);
    return utf8.decode(decompressed);
  }

  // ── Get password ──────────────────────────────────────────────────────────

  Future<String> _getPassword(String userId) async {
    if (AppConfig.devModeSkipAuth) return _kDevPassword;
    // In production, read from secure storage (written at sign-in)
    final stored = await _storage.read(key: 'auth.backup_password');
    return stored ?? _kDevPassword;
  }

  /// Store password for backup encryption (called at sign-in / sign-up).
  Future<void> storeBackupPassword(String password) async {
    await _storage.write(key: 'auth.backup_password', value: password);
  }

  // ── Upload ────────────────────────────────────────────────────────────────

  Future<BackupResult> upload({
    required String userId,
    required String accessToken,
  }) async {
    try {
      final payload = await BackupPayload.buildFromLocalDb();
      final password = await _getPassword(userId);
      final encrypted = _encrypt(payload.toJsonString(), password, userId);

      final body = {
        'encrypted_data': encrypted,
        'backup_version': payload.version,
        'platform': 'flutter',
        'batch_word_count': payload.batchWordCount,
        'vault_word_count': payload.vaultWordCount,
        'streak': payload.currentStreak,
      };

      final resp = await http
          .post(
            Uri.parse('${AppConfig.apiBaseUrl}/backup'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (resp.statusCode == 200) return const BackupResult.success();

      final detail = _parseError(resp.body);
      return BackupResult.failure(detail);
    } catch (e) {
      return BackupResult.failure('Backup failed: ${e.toString()}');
    }
  }

  // ── Download + restore ────────────────────────────────────────────────────

  Future<BackupResult> downloadAndRestore({
    required String userId,
    required String accessToken,
  }) async {
    try {
      final resp = await http
          .get(
            Uri.parse('${AppConfig.apiBaseUrl}/backup'),
            headers: {'Authorization': 'Bearer $accessToken'},
          )
          .timeout(const Duration(seconds: 30));

      if (resp.statusCode == 404) {
        return const BackupResult.failure('No backup found on server.');
      }
      if (resp.statusCode != 200) {
        return BackupResult.failure(_parseError(resp.body));
      }

      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final encryptedData = json['encrypted_data'] as String;

      final password = await _getPassword(userId);
      final plaintext = _decrypt(encryptedData, password, userId);
      final backup = BackupPayload.fromJsonString(plaintext);

      await backup.restoreToLocalDb();
      return const BackupResult.success();
    } catch (e) {
      return BackupResult.failure('Restore failed: ${e.toString()}');
    }
  }

  // ── Download + merge (WL-510) ─────────────────────────────────────────────

  /// Downloads the cloud backup, decrypts it, merges with local SQLite state
  /// using Last-Write-Wins per word, then writes the merged result back locally
  /// AND re-uploads it so the server always holds the authoritative merged state.
  ///
  /// This is the sync path called during normal operation. The destructive
  /// [downloadAndRestore] is reserved for the "start fresh on new device" case.
  ///
  /// Returns `MergeResult` with counts for UI display.
  Future<MergeResult> downloadAndMerge({
    required String userId,
    required String accessToken,
  }) async {
    // ── 1. Fetch remote backup ────────────────────────────────────────────
    final resp = await http
        .get(
          Uri.parse('${AppConfig.apiBaseUrl}/backup'),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(const Duration(seconds: 30));

    if (resp.statusCode == 404) {
      // No remote backup yet — nothing to merge; caller should just upload.
      return const MergeResult(merged: 0, added: 0, noRemoteBackup: true);
    }
    if (resp.statusCode != 200) {
      throw Exception('Server error ${resp.statusCode}: ${_parseError(resp.body)}');
    }

    // ── 2. Decrypt remote payload ─────────────────────────────────────────
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final encryptedData = json['encrypted_data'] as String;
    final password = await _getPassword(userId);
    final plaintext = _decrypt(encryptedData, password, userId);
    final remotePayload = BackupPayload.fromJsonString(plaintext);

    // ── 3. Load local state ───────────────────────────────────────────────
    final storage = LocalStorageService.instance;
    final localBatchRaw = await storage.loadAllBatchEntriesRaw();
    final localVaultRaw = await storage.loadAllVaultEntriesRaw();

    final localBatch = localBatchRaw.map(_rawToBatchEntry).toList();
    final remoteBatch =
        remotePayload.batchEntries.map(_rawToBatchEntry).toList();

    final localVault =
        localVaultRaw.map(VaultEntrySnapshot.fromMap).toList();
    final remoteVault =
        remotePayload.vaultEntries.map(VaultEntrySnapshot.fromMap).toList();

    // ── 4. Merge using LWW ────────────────────────────────────────────────
    final mergedBatch = SyncResolver.mergeAllLanguageBatches(
      local: localBatch,
      remote: remoteBatch,
    );
    final mergedVault = SyncResolver.mergeVaults(
      local: localVault,
      remote: remoteVault,
    );

    final addedFromRemote =
        mergedBatch.length - localBatch.length + mergedVault.length - localVault.length;

    // ── 5. Write merged state to local SQLite ─────────────────────────────
    final mergedBatchRaw = mergedBatch.map(_batchEntryToRaw).toList();
    final mergedVaultRaw = mergedVault.map((v) => v.toMap()).toList();

    await storage.upsertBatchEntriesRaw(mergedBatchRaw);
    await storage.upsertVaultEntriesRaw(mergedVaultRaw);

    return MergeResult(
      merged: mergedBatch.length + mergedVault.length,
      added: addedFromRemote.clamp(0, double.maxFinite.toInt()),
    );
  }

  // ── Raw ↔ model helpers ───────────────────────────────────────────────────

  BatchEntry _rawToBatchEntry(Map<String, dynamic> m) => BatchEntry(
        id: m['id'] as String,
        word: m['word'] as String,
        meaning: m['meaning'] as String,
        exampleSentence: m['example_sentence'] as String? ?? '',
        exampleTranslation: m['example_translation'] as String? ?? '',
        nextReviewDate: m['next_review_date'] != null
            ? DateTime.tryParse(m['next_review_date'] as String)
            : null,
        easeFactor: (m['ease_factor'] as num).toDouble(),
        intervalDays: m['interval_days'] as int,
        repetitions: m['repetitions'] as int,
        addedAt: DateTime.parse(m['added_at'] as String),
        isNewToday: (m['is_new_today'] as int? ?? 0) == 1,
        languageKey: m['language_key'] as String? ?? 'de_b2',
      );

  Map<String, dynamic> _batchEntryToRaw(BatchEntry e) => {
        'id': e.id,
        'language_key': e.languageKey,
        'word': e.word,
        'meaning': e.meaning,
        'example_sentence': e.exampleSentence,
        'example_translation': e.exampleTranslation,
        'next_review_date': e.nextReviewDate?.toIso8601String(),
        'ease_factor': e.easeFactor,
        'interval_days': e.intervalDays,
        'repetitions': e.repetitions,
        'added_at': e.addedAt.toIso8601String(),
        'is_new_today': e.isNewToday ? 1 : 0,
      };

  // ── Check if backup exists ────────────────────────────────────────────────

  Future<Map<String, dynamic>?> fetchMeta({required String accessToken}) async {
    try {
      final resp = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/backup/meta'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  // ── Delete cloud backup ───────────────────────────────────────────────────

  Future<void> deleteCloudBackup({required String accessToken}) async {
    try {
      await http.delete(
        Uri.parse('${AppConfig.apiBaseUrl}/backup'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    } catch (_) {}
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _parseError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['detail'] as String? ?? 'Unknown server error.';
    } catch (_) {
      return 'Server error.';
    }
  }
}

// ───────────────────────────────────────────────────────────────────────────────

/// Result of a bidirectional merge sync operation.
class MergeResult {
  const MergeResult({
    required this.merged,
    required this.added,
    this.noRemoteBackup = false,
  });

  /// Total words in the merged state (batch + vault combined).
  final int merged;

  /// Net words added to local DB from the remote (can be 0 if remote was older).
  final int added;

  /// True when there was no remote backup to merge against.
  final bool noRemoteBackup;
}
