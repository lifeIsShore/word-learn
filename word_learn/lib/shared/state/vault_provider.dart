import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/batch_entry.dart';

final vaultProvider =
    NotifierProvider<VaultNotifier, List<BatchEntry>>(VaultNotifier.new);

class VaultNotifier extends Notifier<List<BatchEntry>> {
  @override
  List<BatchEntry> build() => [];

  /// Add a word to the Vault (called by ActiveBatchNotifier.moveToVault). WL-170.
  void add(BatchEntry entry) {
    // Avoid duplicates
    if (state.any((e) => e.id == entry.id)) return;
    state = [...state, entry];
  }

  int get count => state.length;
}
