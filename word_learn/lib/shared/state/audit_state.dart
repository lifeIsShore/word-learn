import '../models/batch_entry.dart';

/// How long between vault audits.
const Duration kAuditInterval = Duration(days: 90); // ~quarterly

/// How many vault words are sampled per audit session.
const int kAuditCardCount = 10;

enum AuditStatus {
  idle, // no audit running
  due, // audit is overdue / never done
  inProgress, // audit session active
  complete, // just finished
}

/// Result of auditing one vault word.
enum AuditVerdict {
  retained, // EASY or OK — stays in vault
  demoted, // HARD or FAMILIAR — sent back to active batch
}

class AuditCardResult {
  const AuditCardResult({
    required this.entry,
    required this.verdict,
  });
  final BatchEntry entry;
  final AuditVerdict verdict;
}

/// Full state of the vault audit system.
class AuditState {
  const AuditState({
    this.status = AuditStatus.idle,
    this.lastAuditDate,
    this.cards = const [],
    this.currentIndex = 0,
    this.results = const [],
  });

  final AuditStatus status;
  final DateTime? lastAuditDate;

  /// The vault words selected for this audit session.
  final List<BatchEntry> cards;
  final int currentIndex;
  final List<AuditCardResult> results;

  bool get isComplete =>
      cards.isNotEmpty && currentIndex >= cards.length;

  BatchEntry? get currentCard =>
      (currentIndex >= 0 && currentIndex < cards.length)
          ? cards[currentIndex]
          : null;

  int get retainedCount =>
      results.where((r) => r.verdict == AuditVerdict.retained).length;

  int get demotedCount =>
      results.where((r) => r.verdict == AuditVerdict.demoted).length;

  List<BatchEntry> get demotedEntries => results
      .where((r) => r.verdict == AuditVerdict.demoted)
      .map((r) => r.entry)
      .toList();

  /// Whether an audit is due based on last audit date.
  bool get isDue {
    if (lastAuditDate == null) return false; // never triggered until vault has words
    return DateTime.now().difference(lastAuditDate!) >= kAuditInterval;
  }

  AuditState copyWith({
    AuditStatus? status,
    DateTime? lastAuditDate,
    List<BatchEntry>? cards,
    int? currentIndex,
    List<AuditCardResult>? results,
  }) =>
      AuditState(
        status: status ?? this.status,
        lastAuditDate: lastAuditDate ?? this.lastAuditDate,
        cards: cards ?? this.cards,
        currentIndex: currentIndex ?? this.currentIndex,
        results: results ?? this.results,
      );
}
