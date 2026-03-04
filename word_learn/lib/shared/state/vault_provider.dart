import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/batch_entry.dart';

final vaultProvider =
    NotifierProvider<VaultNotifier, List<BatchEntry>>(VaultNotifier.new);

class VaultNotifier extends Notifier<List<BatchEntry>> {
  @override
  List<BatchEntry> build() => [];

  void add(BatchEntry entry) {
    state = [...state, entry];
  }
}
