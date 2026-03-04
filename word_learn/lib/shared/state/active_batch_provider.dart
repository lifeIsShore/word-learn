import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_vocabulary.dart';
import '../models/batch_entry.dart';
import 'vault_provider.dart';

const int _batchCapacity = 200;

final activeBatchProvider =
    NotifierProvider<ActiveBatchNotifier, List<BatchEntry>>(ActiveBatchNotifier.new);

class ActiveBatchNotifier extends Notifier<List<BatchEntry>> {
  @override
  List<BatchEntry> build() {
    return _seedFromSample();
  }

  List<BatchEntry> _seedFromSample() {
    final now = DateTime.now();
    final sample = getSampleVocabulary();
    return sample.asMap().entries.map((e) {
      final i = e.key;
      final f = e.value;
      return BatchEntry(
        id: f.id,
        word: f.word,
        meaning: f.meaning,
        exampleSentence: f.exampleSentence,
        exampleTranslation: f.exampleTranslation,
        nextReviewDate: now.add(Duration(days: i % 3)),
        easeFactor: 2.0 + (i % 3) * 0.2,
        addedAt: now.subtract(Duration(days: sample.length - i)),
      );
    }).toList();
  }

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void moveToVault(String id) {
    final match = state.where((e) => e.id == id).toList();
    if (match.isNotEmpty) {
      ref.read(vaultProvider.notifier).add(match.first);
      state = state.where((e) => e.id != id).toList();
    }
  }

  int get capacity => _batchCapacity;
}
