import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../auth/auth_repository.dart';
import '../backup/backup_service.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum BackupStatus { idle, syncing, success, failed }

class BackupState {
  const BackupState({
    this.status = BackupStatus.idle,
    this.lastSyncedAt,
    this.error,
    this.batchWordCount,
    this.vaultWordCount,
    this.serverStreak,
  });

  final BackupStatus status;
  final DateTime? lastSyncedAt;
  final String? error;
  final int? batchWordCount;
  final int? vaultWordCount;
  final int? serverStreak;

  bool get isSyncing => status == BackupStatus.syncing;
  bool get hasError => error != null;

  BackupState copyWith({
    BackupStatus? status,
    DateTime? lastSyncedAt,
    String? error,
    int? batchWordCount,
    int? vaultWordCount,
    int? serverStreak,
    bool clearError = false,
  }) =>
      BackupState(
        status: status ?? this.status,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        error: clearError ? null : (error ?? this.error),
        batchWordCount: batchWordCount ?? this.batchWordCount,
        vaultWordCount: vaultWordCount ?? this.vaultWordCount,
        serverStreak: serverStreak ?? this.serverStreak,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class BackupNotifier extends Notifier<BackupState> {
  @override
  BackupState build() => const BackupState();

  BackupService get _service => BackupService.instance;
  AuthRepository get _auth => AuthRepository.instance;

  // ── Upload (save to cloud) ────────────────────────────────────────────────

  /// Uploads local SQLite state as an encrypted backup.
  /// [silent] = true → background trigger (no error state on failure).
  Future<bool> sync({bool silent = false}) async {
    if (state.isSyncing) return false;

    // Skip network in dev mode when running silently (e.g. session complete).
    if (AppConfig.devModeSkipAuth && silent) return true;

    final token = await _auth.accessToken;
    final userId = AppConfig.devModeSkipAuth
        ? 'dev-user-001'
        : await _auth.userId;

    if (token == null || userId == null) {
      if (!silent) {
        state = state.copyWith(
          status: BackupStatus.failed,
          error: 'Not signed in. Sign in to enable cloud backup.',
        );
      }
      return false;
    }

    state = state.copyWith(status: BackupStatus.syncing, clearError: true);

    final result = await _service.upload(
      userId: userId,
      accessToken: token,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        status: BackupStatus.success,
        lastSyncedAt: DateTime.now(),
        clearError: true,
      );
      return true;
    }

    if (!silent) {
      state = state.copyWith(
        status: BackupStatus.failed,
        error: result.error,
      );
    } else {
      // Background failure — go back to idle, don't surface to user.
      state = state.copyWith(status: BackupStatus.idle);
    }
    return false;
  }

  // ── Restore (download from cloud) ─────────────────────────────────────────

  /// Downloads and decrypts the server backup then writes it to local SQLite.
  /// Callers should reload all Riverpod providers after a successful restore.
  Future<bool> restore() async {
    final token = await _auth.accessToken;
    final userId = AppConfig.devModeSkipAuth
        ? 'dev-user-001'
        : await _auth.userId;

    if (token == null || userId == null) {
      state = state.copyWith(
        status: BackupStatus.failed,
        error: 'Not signed in.',
      );
      return false;
    }

    state = state.copyWith(status: BackupStatus.syncing, clearError: true);

    final result = await _service.downloadAndRestore(
      userId: userId,
      accessToken: token,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        status: BackupStatus.success,
        lastSyncedAt: DateTime.now(),
        clearError: true,
      );
      return true;
    }

    state = state.copyWith(
      status: BackupStatus.failed,
      error: result.error,
    );
    return false;
  }

  // ── Fetch remote metadata ─────────────────────────────────────────────────

  /// Checks the server for an existing backup and updates state with counts.
  Future<void> loadMeta() async {
    final token = await _auth.accessToken;
    if (token == null) return;

    final meta = await _service.fetchMeta(accessToken: token);
    if (meta != null) {
      state = state.copyWith(
        batchWordCount: meta['batch_word_count'] as int?,
        vaultWordCount: meta['vault_word_count'] as int?,
        serverStreak: meta['streak'] as int?,
      );
    }
  }

  // ── Delete cloud backup ───────────────────────────────────────────────────

  Future<void> deleteCloudBackup() async {
    final token = await _auth.accessToken;
    if (token == null) return;
    await _service.deleteCloudBackup(accessToken: token);
    state = const BackupState();
  }

  void clearError() => state = state.copyWith(clearError: true);
}

// ── Provider ──────────────────────────────────────────────────────────────────

final backupProvider = NotifierProvider<BackupNotifier, BackupState>(
  BackupNotifier.new,
);
