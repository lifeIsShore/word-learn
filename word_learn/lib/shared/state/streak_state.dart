/// Streak and daily session completion tracking.
/// Persisted in-memory for now; swap for SQLite/shared_prefs in WL-500.
class StreakState {
  const StreakState({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.sessionCompletedToday = false,
    this.lastSessionDate,
    this.ashPending = false,
    this.pardonsRemaining = 0,
    this.lastDirectorPardonUsed,
    this.totalSessionsCompleted = 0,
  });

  /// Consecutive days with a completed session before curfew.
  final int currentStreak;

  /// All-time best streak.
  final int longestStreak;

  /// True if at least one session has been completed today.
  final bool sessionCompletedToday;

  /// Date of the most recently completed session.
  final DateTime? lastSessionDate;

  /// True when the app detects a missed curfew on startup — Ash must fire.
  final bool ashPending;

  /// Number of Director's Pardons available to avoid streak reset.
  final int pardonsRemaining;

  /// The timestamp of when the last Director's Pardon was used.
  final DateTime? lastDirectorPardonUsed;

  /// All-time total sessions completed across all streaks.
  final int totalSessionsCompleted;

  StreakState copyWith({
    int? currentStreak,
    int? longestStreak,
    bool? sessionCompletedToday,
    DateTime? lastSessionDate,
    bool? ashPending,
    int? pardonsRemaining,
    DateTime? lastDirectorPardonUsed,
    int? totalSessionsCompleted,
  }) {
    return StreakState(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      sessionCompletedToday:
          sessionCompletedToday ?? this.sessionCompletedToday,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      ashPending: ashPending ?? this.ashPending,
      pardonsRemaining: pardonsRemaining ?? this.pardonsRemaining,
      lastDirectorPardonUsed:
          lastDirectorPardonUsed ?? this.lastDirectorPardonUsed,
      totalSessionsCompleted:
          totalSessionsCompleted ?? this.totalSessionsCompleted,
    );
  }
}
