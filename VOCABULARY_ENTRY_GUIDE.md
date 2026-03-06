# WordLearn — Vocabulary Entry Structure

**Purpose:** Reference schema for adding new words to the app.
Covers the CSV flat-file format (for asset-bundled vocabulary) and the
SQLite `master_vocabulary` table format (for future server-fed or admin-panel additions).

---

## 1. CSV Format (Asset Files)

Used in `word_learn/assets/data/*.csv`
Named by convention: `{base_lang}_{target_lang}_{cefr}.csv`
Example: `en_de_b2.csv`, `en_es_a1.csv`

### Column Order

```
id, language_pair, target_word, base_meaning, word_type, gender, plural_form, ipa_pronunciation, cefr_level, theme, example_sentence_1, example_translation_1, example_sentence_2, example_translation_2, example_sentence_3, example_translation_3
```

### Field Reference

| # | Column | Required | Type | Description & Rules |
|---|--------|----------|------|---------------------|
| 1 | `id` | ✓ | string | Unique stable ID. Format: `{lang_pair}_{cefr}_{zero-padded-number}`. Example: `de_b2_0042`. Never reuse or reassign. |
| 2 | `language_pair` | ✓ | string | ISO 639-1 codes: base→target. Example: `en-de`, `en-es`, `en-fr`. |
| 3 | `target_word` | ✓ | string | The word in the target language. Include article for German nouns: `der Vertrag`. For verb infinitives include no article: `verhandeln`. |
| 4 | `base_meaning` | ✓ | string | Translation in the base language (English). Keep concise: `contract` not `a legally binding written agreement`. Multiple meanings: `contract / agreement`. |
| 5 | `word_type` | ✓ | string | Part of speech. Allowed values: `noun` · `verb` · `adjective` · `adverb` · `preposition` · `conjunction` · `phrase` · `idiom` |
| 6 | `gender` | — | string | Grammatical gender where applicable. German: `m` / `f` / `n`. French/Spanish: `m` / `f`. Leave blank for verbs, adjectives, and languages without grammatical gender. |
| 7 | `plural_form` | — | string | Plural form for nouns, where meaningful. Example: `die Verträge`. Leave blank for non-nouns or uncountable nouns. |
| 8 | `ipa_pronunciation` | — | string | IPA transcription. Example: `fɛɐ̯ˈtʁaːk`. Leave blank if unsure — a blank is better than a wrong IPA. |
| 9 | `cefr_level` | ✓ | string | One of: `A1` · `A2` · `B1` · `B2` · `C1` · `C2` (uppercase). |
| 10 | `theme` | ✓ | string | Topic category. See **Allowed Themes** below. |
| 11 | `example_sentence_1` | ✓ | string | Example sentence in the target language. Must use the word naturally (not artificially forced). Aim for 8–20 words. |
| 12 | `example_translation_1` | ✓ | string | English translation of example 1. Natural, idiomatic — not word-for-word. |
| 13 | `example_sentence_2` | — | string | Second example sentence. Different context from sentence 1 (different register, different grammar pattern). |
| 14 | `example_translation_2` | — | string | English translation of example 2. |
| 15 | `example_sentence_3` | — | string | Third example (optional). Useful for high-frequency or grammar-heavy words. |
| 16 | `example_translation_3` | — | string | English translation of example 3. |

---

### Allowed Themes

Use exactly one of the following values (case-sensitive, lowercase with hyphens):

```
work-professions
work-skills-qualities
business-finance
legal-rules
education-training
health-body
emotions-psychology
social-society
home-living
nature-environment
travel-transport
food-drink
culture-art
technology
communication
politics-government
science-research
sports-leisure
time-numbers
general
idioms-phrases
```

---

### Example Row (German B2)

```csv
de_b2_0101,en-de,der Vertrag,contract / agreement,noun,m,die Verträge,fɛɐ̯ˈtʁaːk,B2,legal-rules,Der Vertrag wurde gestern unterzeichnet.,The contract was signed yesterday.,Vor dem Unterzeichnen solltest du den Vertrag sorgfältig lesen.,You should read the contract carefully before signing.,Das Unternehmen hat den Vertrag nach zwei Jahren nicht verlängert.,The company did not renew the contract after two years.
```

---

## 2. SQLite `master_vocabulary` Table (Future Admin / Server Path)

When vocabulary is managed via an admin panel or synced from the server
rather than bundled as CSV assets, use this schema.

```sql
CREATE TABLE master_vocabulary (
  id                    TEXT PRIMARY KEY,          -- e.g. de_b2_0101
  language_pair         TEXT NOT NULL,             -- e.g. en-de
  target_word           TEXT NOT NULL,             -- e.g. der Vertrag
  base_meaning          TEXT NOT NULL,             -- e.g. contract / agreement
  word_type             TEXT NOT NULL,             -- noun | verb | adjective | ...
  gender                TEXT,                      -- m | f | n | NULL
  plural_form           TEXT,                      -- die Verträge | NULL
  ipa_pronunciation     TEXT,                      -- IPA string | NULL
  cefr_level            TEXT NOT NULL,             -- A1 | A2 | B1 | B2 | C1 | C2
  theme                 TEXT NOT NULL,             -- see Allowed Themes above
  example_sentence_1    TEXT NOT NULL,
  example_translation_1 TEXT NOT NULL,
  example_sentence_2    TEXT,
  example_translation_2 TEXT,
  example_sentence_3    TEXT,
  example_translation_3 TEXT,
  created_at            TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at            TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Fast lookups by language + CEFR (used by daily drip)
CREATE INDEX idx_vocab_lang_cefr
  ON master_vocabulary (language_pair, cefr_level);

-- Fast lookups by theme (used by future thematic sessions)
CREATE INDEX idx_vocab_theme
  ON master_vocabulary (language_pair, theme);
```

---

## 3. Quick-Add Checklist

Before adding any new word, run through this list:

- [ ] **ID is unique** — check existing CSV/DB; never reuse an ID
- [ ] **ID format correct** — `{lang_pair}_{cefr}_{4-digit-number}` e.g. `de_b2_0101`
- [ ] **language_pair** matches the file name (`en-de` for `en_de_*.csv`)
- [ ] **target_word** includes article for German nouns (`der`, `die`, `das`)
- [ ] **base_meaning** is concise and natural
- [ ] **word_type** is one of the allowed values (see above)
- [ ] **cefr_level** is uppercase and matches the file's CEFR level
- [ ] **theme** is one of the allowed values (lowercase, hyphens)
- [ ] **example_sentence_1 + translation_1** are present and natural
- [ ] No comma in any field **without** being quoted — wrap the whole field in `"double quotes"` if it contains a comma
- [ ] File saved as **UTF-8** (not UTF-8-BOM, not Windows-1252)

---

## 4. CSV Quoting Rules (Avoid Parser Errors)

Standard RFC 4180. Key rules:

1. If a field contains a **comma**, wrap the entire field in double quotes:
   `"contract, agreement"` → OK

2. If a field contains a **double quote**, escape it by doubling:
   `"He said ""Guten Morgen"" to the class."` → OK

3. Never use single quotes as delimiters.

4. The header row must always be present and match the column order exactly.

---

## 5. Minimal Entry (Only Required Fields)

If you only have the essentials, leave optional fields blank (empty string between commas):

```csv
de_b2_0102,en-de,verhandeln,to negotiate,verb,,,vɛɐ̯ˈhandl̩n,B2,work-professions,Die beiden Firmen verhandeln über einen neuen Vertrag.,The two companies are negotiating a new contract.,,,,
```

The app will display the word + meaning + example 1 only if examples 2/3 are blank. IPA and gender are hidden when blank.

---

## 6. Bulk SQL Insert (Admin Panel / Migration Script)

If feeding words directly into PostgreSQL or SQLite via a script:

```sql
INSERT INTO master_vocabulary (
  id, language_pair, target_word, base_meaning,
  word_type, gender, plural_form, ipa_pronunciation,
  cefr_level, theme,
  example_sentence_1, example_translation_1,
  example_sentence_2, example_translation_2,
  example_sentence_3, example_translation_3
) VALUES
  ('de_b2_0101', 'en-de', 'der Vertrag', 'contract / agreement',
   'noun', 'm', 'die Verträge', 'fɛɐ̯ˈtʁaːk',
   'B2', 'legal-rules',
   'Der Vertrag wurde gestern unterzeichnet.', 'The contract was signed yesterday.',
   'Vor dem Unterzeichnen solltest du den Vertrag sorgfältig lesen.', 'You should read the contract carefully before signing.',
   'Das Unternehmen hat den Vertrag nach zwei Jahren nicht verlängert.', 'The company did not renew the contract after two years.'),

  ('de_b2_0102', 'en-de', 'verhandeln', 'to negotiate',
   'verb', NULL, NULL, 'vɛɐ̯ˈhandl̩n',
   'B2', 'work-professions',
   'Die beiden Firmen verhandeln über einen neuen Vertrag.', 'The two companies are negotiating a new contract.',
   NULL, NULL, NULL, NULL)

ON CONFLICT (id) DO UPDATE SET
  target_word           = excluded.target_word,
  base_meaning          = excluded.base_meaning,
  example_sentence_1    = excluded.example_sentence_1,
  example_translation_1 = excluded.example_translation_1,
  updated_at            = datetime('now');
```

The `ON CONFLICT … DO UPDATE` (upsert) pattern is safe for re-running
migration scripts — existing words get their examples updated without
duplicating rows.

---

*Last updated: 2026-03-06*
*Maintained alongside `user-stories.md` and `IMPLEMENTATION_LOG.md`.*
