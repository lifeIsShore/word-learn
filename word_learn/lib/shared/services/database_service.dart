import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Low-level SQLite database manager.
///
/// Single source of truth for table schemas and migrations.
/// Designed for easy upgrade to SQLCipher encryption in WL-500 Phase 2
/// (just swap sqflite → sqflite_sqlcipher and pass a password).
///
/// Tables
/// ──────
///   settings          – key/value store (user prefs, onboarding choices)
///   streak            – streak + last-session tracking
///   batch_entries     – active batch words with SRS state (per language)
///   vault_entries     – mastered / graduated words
class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static const _dbName = 'word_learn.db';
  static const _dbVersion = 3;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  // ── Open / create ──────────────────────────────────────────────────────────

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        // Enable WAL for better concurrent read performance.
        await db.execute('PRAGMA journal_mode=WAL');
        // Enforce FK constraints.
        await db.execute('PRAGMA foreign_keys=ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        key   TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE streak (
        id                      INTEGER PRIMARY KEY CHECK (id = 1),
        current_streak          INTEGER NOT NULL DEFAULT 0,
        longest_streak          INTEGER NOT NULL DEFAULT 0,
        session_completed_today INTEGER NOT NULL DEFAULT 0,
        last_session_date       TEXT,
        ash_pending             INTEGER NOT NULL DEFAULT 0,
        pardons_remaining       INTEGER NOT NULL DEFAULT 0,
        last_director_pardon_used TEXT,
        total_sessions_completed INTEGER DEFAULT 0
      )
    ''');

    // Seed the single streak row.
    await db.execute(
      'INSERT INTO streak (id) VALUES (1) ON CONFLICT DO NOTHING',
    );

    await db.execute('''
      CREATE TABLE batch_entries (
        id                  TEXT PRIMARY KEY,
        language_key        TEXT NOT NULL,
        word                TEXT NOT NULL,
        meaning             TEXT NOT NULL,
        example_sentence    TEXT NOT NULL DEFAULT '',
        example_translation TEXT NOT NULL DEFAULT '',
        next_review_date    TEXT,
        ease_factor         REAL NOT NULL DEFAULT 2.5,
        interval_days       INTEGER NOT NULL DEFAULT 1,
        repetitions         INTEGER NOT NULL DEFAULT 0,
        added_at            TEXT NOT NULL,
        is_new_today        INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_batch_lang ON batch_entries (language_key)',
    );
    await db.execute(
      'CREATE INDEX idx_batch_review ON batch_entries (next_review_date)',
    );

    await db.execute('''
      CREATE TABLE vault_entries (
        id                  TEXT PRIMARY KEY,
        language_key        TEXT NOT NULL,
        word                TEXT NOT NULL,
        meaning             TEXT NOT NULL,
        example_sentence    TEXT NOT NULL DEFAULT '',
        example_translation TEXT NOT NULL DEFAULT '',
        ease_factor         REAL NOT NULL DEFAULT 2.5,
        interval_days       INTEGER NOT NULL DEFAULT 1,
        repetitions         INTEGER NOT NULL DEFAULT 0,
        added_at            TEXT NOT NULL,
        vaulted_at          TEXT NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_vault_lang ON vault_entries (language_key)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE streak ADD COLUMN pardons_remaining INTEGER NOT NULL DEFAULT 0',
      );
      await db.execute(
        'ALTER TABLE streak ADD COLUMN last_director_pardon_used TEXT',
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE streak ADD COLUMN total_sessions_completed INTEGER DEFAULT 0',
      );
    }
  }

  // ── Generic helpers ────────────────────────────────────────────────────────

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  /// Wipe all data — used for "Reset Progress" and tests.
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('batch_entries');
    await db.delete('vault_entries');
    await db.delete('settings');
    await db.execute(
      'UPDATE streak SET '
      'current_streak=0, longest_streak=0, '
      'session_completed_today=0, last_session_date=NULL, ash_pending=0 '
      'WHERE id=1',
    );
  }
}
