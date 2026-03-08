import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../auth/auth_repository.dart';
import '../backup/backup_service.dart';
import 'connectivity_provider.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum BackupStatus { idle, syncing, success, failed }

class BackupState {
  const BackupState({
    this.status = BackupStatus.idle,
    this.lastSyncedAt,
    this.lastMergedAt,
    this.error,
    this.batchWordCount,
    this.vaultWordCount,
    this.serverStreak,
    this.lastAddedFromRemote = 0,
  });

  final BackupStatus status;
  final DateTime? lastSyncedAt;

  /// Timestamp of the most recent successful bidirectional merge (WL-510).
  final DateTime? lastMergedAt;

  final String? error;
  final int? batchWordCount;
  final int? vaultWordCount;
  final int? serverStreak;

  /// Net words received from the remote side during the last merge.
  final int lastAddedFromRemote;

  bool get isSyncing => status == BackupStatus.syncing;
  bool get hasError => error != null;
  bool get hasMerged => lastMergedAt != null;

  BackupState copyWith({
    BackupStatus? status,
    DateTime? lastSyncedAt,
    DateTime? lastMergedAt,
    String? error,
    int? batchWordCount,
    int? vaultWordCount,
    int? serverStreak,
    int? lastAddedFromRemote,
    bool clearError = false,
  }) =>
      BackupState(
        status: status ?? this.status,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        lastMergedAt: lastMergedAt ?? this.lastMergedAt,
        error: clearError ? null : (error ?? this.error),
        batchWordCount: batchWordCount ?? this.batchWordCount,
        vaultWordCount: vaultWordCount ?? this.vaultWordCount,
        serverStreak: serverStreak ?? this.serverStreak,
        lastAddedFromRemote:
            lastAddedFromRemote ?? this.lastAddedFromRemote,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class BackupNotifier extends Notifier<BackupState> {
  @override
  BackupState build() => const BackupState();

  BackupService get _service => BackupService.instance;
  AuthRepository get _auth => AuthRepository.instance;

  // ── Bidirectional sync: merge → upload (WL-510) ───────────────────────────

  /// Bidirectional sync:
  ///   1. Download remote backup → LWW-merge with local SQLite
  ///   2. Write merged state back to local SQLite
  ///   3. Upload merged state to server
  ///
  /// Both devices will converge to the same state on their next sync.
  /// [silent] = true → background trigger (errors swallowed, no UI change).
  Future<bool> sync({bool silent = false}) async {
    if (state.isSyncing) return false;

    // Skip network in dev mode when running silently.
    if (AppConfig.devModeSkipAuth && silent) return true;

    // Session 19: Skip sync entirely when offline — no error noise.
    final isOnline = ref.read(connectivityProvider);
    if (!isOnline) {
      if (!silent) {
        state = state.copyWith(
          status: BackupStatus.failed,
          error: 'No internet connection. Sync will resume automatically.',
        );
      }
      return false;
    }

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

    try {
      // Step 1 + 2: Download, merge with local, write merged state locally.
      final mergeResult = await _service.downloadAndMerge(
        userId: userId,
        accessToken: token,
      );

      final now = DateTime.now();

      if (!mergeResult.noRemoteBackup) {
        state = state.copyWith(
          lastMergedAt: now,
          lastAddedFromRemote: mergeResult.added,
        );
      }

      // Step 3: Upload the merged (or local-only if no remote existed) state.
      final uploadResult = await _service.upload(
        userId: userId,
        accessToken: token,
      );

      if (uploadResult.isSuccess) {
        state = state.copyWith(
          status: BackupStatus.success,
          lastSyncedAt: now,
          clearError: true,
        );
        return true;
      }

      if (!silent) {
        state = state.copyWith(
          status: BackupStatus.failed,
          error: uploadResult.error,
        );
      } else {
        state = state.copyWith(status: BackupStatus.idle);
      }
      return false;
    } catch (e) {
      if (!silent) {
        state = state.copyWith(
          status: BackupStatus.failed,
          error: 'Sync failed: ${e.toString()}',
        );
      } else {
        state = state.copyWith(status: BackupStatus.idle);
      }
      return false;
    }
  }

  // ── Restore (destructive — new device "start fresh") ──────────────────────

  /// Downloads and decrypts the server backup then WIPES and rewrites local
  /// SQLite. Use only on new-device onboarding when the user explicitly
  /// confirms they want to restore from cloud.
  ///
  /// Callers should invalidate all Riverpod providers after a successful
  /// restore (e.g. via ref.invalidate or a full app restart).
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
