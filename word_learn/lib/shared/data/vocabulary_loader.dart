import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/flashcard_item.dart';
import '../models/language_config.dart';

/// Loads, parses, and caches vocabulary from Flutter asset CSVs.
///
/// This replaces the inline string constants from the pre-WL-600
/// [VocabularyRepository]. All vocab is now loaded via [rootBundle.loadString].
///
/// Usage:
///   final words = await VocabularyLoader.load(config);
class VocabularyLoader {
  VocabularyLoader._();

  // In-memory cache: config.key → parsed word list.
  static final Map<String, List<FlashcardItem>> _cache = {};

  /// Load and parse the CSV for [config].
  /// Returns cached result on subsequent calls.
  /// Throws [FlutterError] if the asset is not found.
  static Future<List<FlashcardItem>> load(LanguageConfig config) async {
    if (_cache.containsKey(config.key)) {
      return _cache[config.key]!;
    }

    final raw = await rootBundle.loadString(config.assetPath);
    final parsed = _parseCsv(raw, config: config);
    _cache[config.key] = parsed;
    return parsed;
  }

  /// Returns cached words for [key] without triggering a load.
  /// Returns null on a cache miss.
  static List<FlashcardItem>? cachedWords(String key) => _cache[key];

  /// Invalidate cache for a single key (for testing / hot-reload).
  static void invalidate(String key) => _cache.remove(key);

  /// Clear entire cache.
  static void clearCache() => _cache.clear();

  // ── CSV parsing ────────────────────────────────────────────────────────────

  static List<FlashcardItem> _parseCsv(
    String csv, {
    required LanguageConfig config,
  }) {
    final lines = csv.split('\n');
    final items = <FlashcardItem>[];
    var lineIndex = 0;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      // Skip header row: matches when the first column equals the known header,
      // or when the line starts with the wordColumnHeader string.
      if (line.startsWith(config.wordColumnHeader)) continue;

      final cols = _splitCsvLine(line);
      if (cols.length < 4) continue;

      items.add(FlashcardItem(
        id: '${config.key}_$lineIndex',
        word: cols[0].trim(),
        meaning: cols[1].trim(),
        exampleSentence: cols[2].trim(),
        exampleTranslation: cols[3].trim(),
      ));
      lineIndex++;
    }

    return items;
  }

  /// RFC 4180-compliant CSV field splitter — handles quoted fields with
  /// embedded commas and escaped double-quotes ("").
  static List<String> _splitCsvLine(String line) {
    final cols = <String>[];
    final buf = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        // Handle escaped quote: "" inside a quoted field → single "
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buf.write('"');
          i++; // skip next "
        } else {
          inQuotes = !inQuotes;
        }
      } else if (ch == ',' && !inQuotes) {
        cols.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    cols.add(buf.toString()); // last field
    return cols;
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────────

/// Async provider: loads vocabulary for a specific [LanguageConfig].
/// Riverpod caches by [config.key] via the family modifier.
final vocabularyLoaderProvider =
    FutureProvider.family<List<FlashcardItem>, LanguageConfig>(
  (ref, config) => VocabularyLoader.load(config),
);
