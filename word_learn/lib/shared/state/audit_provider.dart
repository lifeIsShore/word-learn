import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/batch_entry.dart';
import '../models/language_config.dart';
import '../services/local_storage_service.dart';
import 'active_batch_provider.dart';
import 'audit_state.dart';
import 'session_state.dart';
import 'vault_provider.dart';

final auditProvider = NotifierProvider<AuditNotifier, AuditState>(
  AuditNotifier.new,
);

class AuditNotifier extends Notifier<AuditState> {
  final _storage = LocalStorageService.instance;

  @override
  AuditState build() => const AuditState();

  // ── Init ──────────────────────────────────────────────────────────────────

  /// Load last audit date from SQLite, then check if an audit is due.
  /// Called from SplashScreen during startup.
  Future<void> init() async {
    final raw = await _storage.getSetting(_kLastAuditDate);
    final lastAudit = raw != null ? DateTime.tryParse(raw) : null;

    state = state.copyWith(
      lastAuditDate: lastAudit,
      // Mark as due only if vault has enough words and interval passed.
      status: _shouldMarkDue(lastAudit) ? AuditStatus.due : AuditStatus.idle,
    );
  }

  bool _shouldMarkDue(DateTime? lastAudit) {
    final vault = ref.read(vaultProvider);
    if (vault.isEmpty) return false;
    if (lastAudit == null) {
      // First time: mark due only if vault has at least kAuditCardCount words.
      return vault.length >= kAuditCardCount;
    }
    return DateTime.now().difference(lastAudit) >= kAuditInterval;
  }

  // ── Start audit session ────────────────────────────────────────────────────

  /// Randomly sample up to [kAuditCardCount] words from the vault.
  void startAudit() {
    final vault = List<BatchEntry>.from(ref.read(vaultProvider));
    if (vault.isEmpty) return;

    vault.shuffle(Random());
    final sample = vault.take(kAuditCardCount).toList();

    state = state.copyWith(
      status: AuditStatus.inProgress,
      cards: sample,
      currentIndex: 0,
      results: [],
    );
  }

  // ── Submit verdict for current card ───────────────────────────────────────

  /// EASY / OK → retained in vault.
  /// HARD / FAMILIAR → demoted back to active batch with reset SRS.
  void submitVerdict(DifficultyRating rating) {
    final card = state.currentCard;
    if (card == null) return;

    final verdict = (rating == DifficultyRating.easy ||
            rating == DifficultyRating.ok)
        ? AuditVerdict.retained
        : AuditVerdict.demoted;

    final newResults = List<AuditCardResult>.from(state.results)
      ..add(AuditCardResult(entry: card, verdict: verdict));

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      results: newResults,
    );
  }

  // ── Complete audit ─────────────────────────────────────────────────────────

  /// Applies all verdicts: removes demoted words from vault, adds them back
  /// to their language's active batch with reset SRS state.
  Future<void> completeAudit() async {
    final now = DateTime.now();

    // 1. Demote words: remove from vault, re-add to batch with reset SRS.
    for (final entry in state.demotedEntries) {
      // Remove from vault provider + SQLite.
      await ref.read(vaultProvider.notifier).remove(entry.id);

      // Reset SRS and add back to the correct language batch.
      final resetEntry = entry.copyWith(
        easeFactor: 2.5,
        intervalDays: 1,
        repetitions: 0,
        nextReviewDate: now,
        isNewToday: false,
      );

      final config = kAvailableLanguageConfigs
          .cast<LanguageConfig?>()
          .firstWhere(
            (c) => c?.key == entry.languageKey,
            orElse: () => null,
          );

      if (config != null) {
        await ref
            .read(languageBatchProvider(config).notifier)
            .addEntry(resetEntry);
      } else {
        await ref
            .read(activeBatchProvider.notifier)
            .addEntry(resetEntry);
      }
    }

    // 2. Persist last audit date.
    await _storage.saveSetting(_kLastAuditDate, now.toIso8601String());

    // 3. Update state to complete.
    state = state.copyWith(
      status: AuditStatus.complete,
      lastAuditDate: now,
    );
  }

  // ── Dismiss / reset ───────────────────────────────────────────────────────

  /// Called after the complete screen is acknowledged.
  void dismiss() {
    state = state.copyWith(
      status: AuditStatus.idle,
      cards: [],
      results: [],
      currentIndex: 0,
    );
  }

  static const _kLastAuditDate = 'audit.last_audit_date';
}
