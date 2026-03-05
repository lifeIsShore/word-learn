import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/batch_entry.dart';
import '../services/local_storage_service.dart';

final vaultProvider = NotifierProvider<VaultNotifier, List<BatchEntry>>(
  VaultNotifier.new,
);

class VaultNotifier extends Notifier<List<BatchEntry>> {
  final _storage = LocalStorageService.instance;

  @override
  List<BatchEntry> build() => [];

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Load persisted vault from SQLite. Called once on startup.
  Future<void> init() async {
    final entries = await _storage.loadVault();
    state = entries;
  }

  // ── Mutations ──────────────────────────────────────────────────────────────

  /// Add a word to the Vault (called by LanguageBatchNotifier.moveToVault). WL-170.
  Future<void> add(BatchEntry entry) async {
    if (state.any((e) => e.id == entry.id)) return; // duplicate guard
    state = [entry, ...state]; // newest first
    await _storage.upsertVaultEntry(entry);
  }

  int get count => state.length;

  /// Remove a word from the vault. Used by AuditNotifier when demoting. WL-190.
  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _storage.deleteVaultEntry(id);
  }
}
