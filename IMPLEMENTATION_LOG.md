# WordLearn — Implementation Log (Kanban & Session Notes)

**Purpose:** Track implementation progress like a Kanban board. Use for sprint planning, session notes, and developer handoff.

**Last Updated:** 2026-03-05 (Session 4)

---

## Kanban Board

### 🔴 To Do

| ID | Item | Epic / Story | Notes |
|----|------|-------------|-------|
| — | Email Sign-Up Flow | WL-001 | P0; **deferred** — auth disabled for testing |
| — | Google OAuth Sign-In | WL-002 | P0; **deferred** |
| — | Apple OAuth Sign-In (iOS) | WL-003 | P0; **deferred** |
| — | JWT Token Management & Refresh | WL-004 | P0; **deferred** |
| — | Logout & Session Termination | WL-005 | P1; **deferred** |
| — | Subscription Paywall (IAP) | WL-016 full | P0; **disabled** — placeholder only, enable later |
| — | In-App Purchase (IAP) Integration | WL-300 | P0; **deferred** |
| — | Receipt Verification (Server-Side) | WL-301 | P0; **deferred** |
| — | Subscription Entitlements & Feature Gating | WL-310 | P0; **deferred** |
| — | Vault Audit & Re-Validation (Quarterly) | WL-190 | P2, 4 pts — **deferred** |


| — | Privacy Controls & Data Management | WL-410 | P2, 2 pts |
| — | Ghost Backup (Cloud Sync) | WL-500 | P0, 5 pts |
| — | Conflict Resolution (Multi-Device Sync) | WL-510 | P1, 3 pts |
| — | ~~Language Configuration & Loading~~ | ~~WL-600~~ | ~~P0, 4 pts~~ |
| — | ~~Multi-Language Study Sessions~~ | ~~WL-610~~ | ~~P1, 4 pts~~ |

---

### 🟡 In Progress

| ID | Item | Owner | Started | Notes |
|----|------|--------|---------|-------|


---

### ✅ Done

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| — | WL-610: Multi-Language Study Sessions (per-language batch isolation, language-tagged SRS, multi-language session, per-language stats) | 2026-03-05 | languageBatchProvider family; language badge on flashcard; per-lang breakdown in summary |
| — | WL-600: Language Configuration & Loading (asset CSV loader, VocabularyLoader, LanguageConfig, ActiveLanguageProvider, language switcher) | 2026-03-05 | Asset-based; splash warms cache; drip + settings wired |
| — | WL-400: Settings Screen (Profile · Learning · Appearance · Stats · Privacy · Account) | 2026-03-05 | SettingsState, SettingsNotifier, reactive ThemeMode |
| — | WL-410: Privacy toggles (shareLearningData, allowCrashReports) in Settings | 2026-03-05 | Bundled with WL-400 |
| — | app.dart: reactive theme (ConsumerWidget, themeMode from settingsProvider) | 2026-03-05 | Light → Dark → System toggle live |
| — | Home: settings gear icon in AppBar, displayName greeting | 2026-03-05 | — |
| — | WL-200: Curfew Enforcement (reactive status, streak integration, live countdown) | 2026-03-05 | CurfewStatusProvider, CurfewPhase enum |
| — | WL-210: Ice State (banner, scaffold bg tint, session button colour shift) | 2026-03-05 | IceStateBanner + IceStateScaffoldBackground widgets |
| — | WL-220: Ash Protocol (AshScreen, streak reset on startup, acknowledgeAsh) | 2026-03-05 | /ash route; dark full-screen modal |
| — | StreakState + StreakNotifier (streak, longestStreak, sessionCompletedToday, ashPending) | 2026-03-05 | recordSessionComplete, checkAshOnStartup |
| — | SessionNotifier.completeAndClear() wires streak recording | 2026-03-05 | Replaces clearSession() on session complete |
| — | SessionCompleteScreen: real streak display, curfew banner | 2026-03-05 | — |
| — | HomeScreen: AppLifecycleObserver, 60s timer, ash redirect, ice AppBar tint | 2026-03-05 | — |
| — | WL-140: Active Batch (SRS wired, NEW/DUE badges, sort, detail, actions) | 2026-03-05 | SM-2 algorithm; session ratings update batch |
| — | WL-150: Daily Drip (injectDrip, VocabularyRepository, 50-word B2 dataset) | 2026-03-05 | Drip button on Home; capacity-aware |
| — | WL-160: Batch Capacity Management (200-word cap, near-capacity warning) | 2026-03-05 | Progress bar on Batch; warning banner on Home |
| — | WL-170: Move Words to Vault (Graduate to Vault, snackbar feedback) | 2026-03-05 | Long-press → Graduate; duplicate guard |
| — | WL-180: View Vault (VaultScreen, empty state, word detail sheet) | 2026-03-05 | /vault route; newest-first order |
| — | VocabularyRepository (50-word B2 German dataset, CSV parser) | 2026-03-05 | Replaces sample_vocabulary.dart; extensible for WL-610 |
| — | BatchEntry: copyWith + SM-2 withSm2Update + intervalDays/repetitions/isNewToday | 2026-03-05 | Full SRS model |
| — | Home redesign: stats card, drip button, vault nav, capacity warning | 2026-03-05 | — |
| — | IMPLEMENTATION_LOG.md created | 2026-03-05 | Kanban + session notes structure |
| — | docs/BLUEPRINT.md created | 2026-03-05 | Tabs, pages, connections, panels, functions |
| — | docs/DOCUMENTATION.md created | 2026-03-05 | Project overview, setup, architecture |
| — | Flutter project initialized | 2026-03-05 | word_learn app, Dart 3.x, Flutter 3.x |
| — | Design system (core/theme) | 2026-03-05 | AppColors, AppTypography, AppSpacing, AppTheme (light/dark) |
| — | App router (go_router) | 2026-03-05 | Splash, Auth, Onboarding Welcome, Home routes |
| — | Splash screen | 2026-03-05 | WordLearn title, auto-navigate to onboarding welcome after 1.5s |
| — | Auth screen (placeholder) | 2026-03-05 | Buttons to onboarding / skip to Home (dev) |
| — | Welcome screen (WL-010) | 2026-03-05 | “Scholar, welcome to WordLearn.” + GET STARTED → Home |
| — | Home screen (placeholder) | 2026-03-05 | Greeting, stats placeholders, START SESSION button |
| — | Riverpod + onboarding state | 2026-03-05 | OnboardingState, OnboardingNotifier, ProviderScope |
| — | Base Language screen (WL-011) | 2026-03-05 | Single select, 6 languages, default en |
| — | Target Languages screen (WL-012) | 2026-03-05 | Multi-select 1–6, exclude base, counter |
| — | CEFR screen (WL-013) | 2026-03-05 | Per-language dropdown A1–C2, default B1 |
| — | Curfew screen (WL-014) | 2026-03-05 | Time picker default 22:00, Ash warning |
| — | Drip screen (WL-015) | 2026-03-05 | Slider 5–40, default 20 |
| — | Paywall screen (WL-016) | 2026-03-05 | UI only; "Continue with Free" → Home; IAP disabled |
| — | Auth & Paywall marked disabled | 2026-03-05 | Auth screen note; Paywall subscribe buttons disabled |
| — | Home uses onboarding state | 2026-03-05 | Curfew and drip count from onboarding |
| — | FlashcardItem model + sample vocabulary | 2026-03-05 | 10 sample B2 German words; replace with asset/encrypted later |
| — | Session state + SessionNotifier | 2026-03-05 | startSession(maxCards), submitRating, clearSession |
| — | Daily Session Initialization (WL-050) | 2026-03-05 | Home START SESSION → startSession(10) → /session |
| — | Flashcard Display & Reveal (WL-060) | 2026-03-05 | Front: word; tap → back: meaning, example; card styling |
| — | Difficulty Rating (WL-070) | 2026-03-05 | HARD / FAMILIAR / OK / EASY; submitRating → next card |
| — | Session Completion (WL-075) | 2026-03-05 | Summary: reviewed, mastered, streak; CONTINUE → Home |

---

## Session Notes

### Session: 2026-03-05 (Initial Setup)

**What was done**
- Created `IMPLEMENTATION_LOG.md` with Kanban columns (To Do, In Progress, Done) and full MVP story list from user-stories.md.
- Created `docs/BLUEPRINT.md` with: app structure, tabs, pages, navigation, data connections, panels, key functions/calculations, and dashboard/summary views.
- Created `docs/DOCUMENTATION.md` with: project overview, tech stack, setup, architecture, and references to PRD/user stories.
- Initialized Flutter project (`flutter create word_learn`) for Android, iOS, and later desktop.

**In progress**
- None (foundation complete for this session).

**Blockers / decisions**
- None. PRD (prdv2.md) and user-stories.md are the source of truth.

**Completed this session**
- Design system: `lib/core/theme/` (AppColors, AppTypography, AppSpacing, AppTheme light/dark).
- Router: go_router with routes `/`, `/auth`, `/onboarding/welcome`, `/home`.
- Screens: Splash (auto → welcome), Auth (placeholder), Welcome (WL-010), Home (placeholder). Tests updated and passing.

**Next session**
- Implement auth screens (sign-up, sign-in) and Supabase Auth wiring.
- Implement onboarding flow: Base Language (WL-011) → Target Languages (WL-012) → CEFR (WL-013) → Curfew (WL-014) → Drip (WL-015) → Paywall (WL-016).

---

### Session: 2026-03-05 (Onboarding flow; Auth/Payment deferred)

**What was done**
- **Auth & payment deferred:** Auth screen and IAP/Paywall are implemented as placeholders and **disabled for testing**. Auth screen shows “Auth is disabled for easier testing.” Paywall shows tier cards but only “Continue with Free” is active; Subscribe buttons disabled. To be enabled later.
- **Riverpod:** Added `flutter_riverpod`; app wrapped in `ProviderScope`. Created `OnboardingState` and `OnboardingNotifier` for base language, target languages, CEFR per language, curfew, daily drip.
- **Onboarding flow:** Welcome → Base Language → Target Languages → CEFR → Curfew → Drip → Paywall → Home. All screens implemented; back/next navigation wired.
- **Screens:** Base Language (WL-011), Target Languages (WL-012), CEFR (WL-013), Curfew (WL-014), Drip (WL-015), Paywall (WL-016 placeholder). Home now reads onboarding state for curfew time and drip count.

**In progress**
- None.

**Next session**
- Daily Session Initialization (WL-050), then Flashcard display (WL-060), Difficulty rating (WL-070), Session completion (WL-075).

---

### Session: 2026-03-05 (Core study loop — WL-050, 060, 070, 075)

**What was done**
- **Vocabulary:** `FlashcardItem` model and `getSampleVocabulary()` with 10 B2 German words (from b2-work-professions). Can be replaced later with asset CSV or encrypted bundle.
- **Session state:** `SessionState`, `SessionCardResult`, `DifficultyRating`; `SessionNotifier` with `startSession(maxCards)`, `submitRating(rating)`, `clearSession()`.
- **WL-050:** Home "START SESSION" starts a session (10 cards, shuffled) and navigates to `/session`.
- **WL-060:** Session screen shows flashcard front (word); tap to reveal back (meaning, example sentence, translation). Card styling per design system.
- **WL-070:** After reveal, four difficulty buttons (HARD, FAMILIAR, OK, EASY); on tap, submit rating and show next card. Progress: "Card X of Y".
- **WL-075:** When all cards rated, navigate to Session Complete screen: words reviewed, words mastered (EASY count), streak placeholder, Curfew reminder; CONTINUE clears session and goes to Home.

**In progress**
- None.

**Next session**
- Active Batch Status & Word List (WL-140), or Language Configuration & Loading (WL-600).

---

### Session: 2026-03-05 (Session 4 — Batch/Drip/Vault sprint)

**What was done**
- **WL-140 (Active Batch — closed):** Wired session difficulty ratings to SM-2 SRS updates in `BatchEntry`. Added `withSm2Update(quality)`, `copyWith()`, `intervalDays`, `repetitions`, `isNewToday` fields. Batch screen now shows NEW/DUE badges, capacity progress bar, SRS metadata in detail sheet, 4-way sort (due/hard/oldest/newest), improved long-press actions with snackbar feedback.
- **WL-150 (Daily Drip):** Created `VocabularyRepository` with 50-word B2 German dataset and CSV parser. `ActiveBatchNotifier.injectDrip()` pulls new words, skips duplicates, respects capacity cap, marks words as `isNewToday`. Home screen has "DAILY DRIP" button with snackbar confirmation.
- **WL-160 (Capacity Management):** `isNearCapacity` (≥90%) triggers warning banner on Home and orange progress bar on Batch screen. `isFull` blocks drip injection.
- **WL-170 (Move to Vault):** Long-press → "Graduate to Vault" action; `VaultNotifier.add()` with duplicate guard; snackbar confirmation.
- **WL-180 (View Vault):** New `VaultScreen` at `/vault` with empty state, mastered-word count header, newest-first list, word detail bottom sheet with MASTERED badge.
- **Home redesign:** Stats card (batch/due/new/vault/streak/curfew), drip button, VIEW BATCH + VIEW VAULT row, capacity warning banner.
- **Router:** Added `/vault` route and `AppRoutes.vault` constant.

**Blockers / decisions**
- `VocabularyRepository` embeds B2 German data inline (no asset loading). When WL-600 is implemented, replace with `rootBundle.loadString()` from `assets/data/*.csv`.
- SM-2 quality mapping: HARD=0, FAMILIAR=1, OK=2, EASY=3. Min ease factor clamped at 1.3.
- Session now draws cards from batch (due-first priority) rather than always using sample data.

**Next session**
- WL-200: The Curfew (daily deadline enforcement — check if session done before curfew time).
- WL-210: The Ice State (visual priming at curfew-1hr).
- WL-220: The Ash Protocol (streak reset on missed curfew).

---

### Session: 2026-03-05 (Session 5 — Curfew / Ice State / Ash Protocol)

**What was done**
- **StreakState + StreakNotifier:** Full streak model — `currentStreak`, `longestStreak`, `sessionCompletedToday`, `lastSessionDate`, `ashPending`. Methods: `recordSessionComplete()` (consecutive-day logic), `checkAshOnStartup()` (detects missed curfew), `acknowledgeAsh()`.
- **CurfewStatusProvider (WL-200):** Reactive `Provider<CurfewStatus>` computing `CurfewPhase` (normal / ice / pastCurfew) from onboarding curfew time + streak state. Used by all screens via `ref.watch(curfewStatusProvider)`.
- **IceStateBanner + IceStateScaffoldBackground (WL-210):** Animated banner slides in during Ice window (within 60 min of curfew, session not done). Scaffold background shifts to ice-teal tint (ice) or faint-red tint (past curfew). AppBar colour also reacts.
- **AshScreen (WL-220):** Full-screen dark modal on `/ash` route. Shows burned-streak message, resets streak visually, CTA: "I UNDERSTAND. BEGIN AGAIN." → acknowledges ash and navigates to Home.
- **HomeScreen:** Now a `ConsumerStatefulWidget` with `WidgetsBindingObserver`. Runs `checkAshOnStartup()` on init and on `AppLifecycleState.resumed`. 60-second `Timer` invalidates `curfewStatusProvider` for live countdown. START SESSION button text/colour shifts with curfew phase. Session-done green badge shown when `sessionCompletedToday`.
- **SessionCompleteScreen:** Uses `completeAndClear()` (not `clearSession()`) so streak increments on CONTINUE. Displays real streak preview. Curfew banner adapts to ice/past-curfew states.
- **SessionNotifier:** Added `completeAndClear()` — records streak before clearing session. Old `clearSession()` preserved for mid-session abandonment.
- **Router:** Added `/ash` route.

**Blockers / decisions**
- Ash check uses `lastSessionDate` compared to yesterday (UTC-local day boundary). On devices with DST transitions this is correct because `DateTime.now()` is always local time.
- `curfewStatusProvider` is a plain `Provider` (not `StreamProvider`) for simplicity. Live updates via 60s timer in HomeScreen is sufficient for the countdown display.
- Streak is in-memory only. Will be persisted to SQLite in WL-500.

**Next session**
- WL-400: User Profile & Settings Screen (curfew edit, drip slider, theme toggle, language management).

---

### Session: 2026-03-05 (Session 6 — Settings Screen)

**What was done**
- **SettingsState + SettingsNotifier (WL-400):** Owns `displayName`, `themeMode`, `shareLearningData`, `allowCrashReports`. Clean `copyWith` pattern, Riverpod `NotifierProvider`.
- **SettingsScreen (WL-400):** Six grouped sections — Profile (display name edit dialog, base/target lang read-only), Learning (curfew time picker, drip slider — both write back to `onboardingProvider`), Appearance (3-way theme segmented button: Light/Dark/System), Stats (streak, longest streak, CEFR per language), Privacy (WL-410: two toggle switches), Account (subscription status, Reset Progress, Delete Account with confirmation dialogs).
- **Reactive theme (app.dart):** `WordLearnApp` converted to `ConsumerWidget`; `themeMode` from `settingsProvider` passed directly to `MaterialApp.router`. Dark mode (Deep Navy) activates immediately on toggle with zero restarts.
- **WL-410 bundled:** Privacy toggles (`shareLearningData`, `allowCrashReports`) live in the Privacy section. Delete Account shows correct deferred-auth message.
- **Home AppBar:** Settings gear icon (⚙) navigates to `/settings`. Greeting reads `settings.displayName` instead of hardcoded "Scholar".
- **Router:** `/settings` route added.

**Decisions**
- Drip slider in Settings writes directly to `onboardingProvider.setDailyDrip()` — single source of truth, no duplication.
- Curfew edit in Settings reuses `showTimePicker` + `onboardingProvider.setCurfew()` — same path as onboarding flow.
- "Delete Account" is guarded with a deferred-auth message; no destructive action fires until auth is enabled (WL-001–005).
- WL-410 (Privacy Controls) is fully implemented within WL-400 — closing both stories.

**Next session**
- WL-610: Multi-Language Study Sessions (per-language batch isolation, language-scoped SRS).

---

### Session: 2026-03-05 (Session 7 — WL-600: Language Configuration & Loading)

**What was done**
- **`LanguageConfig` model** (`shared/models/language_config.dart`): Describes a language × CEFR asset entry (languageCode, cefrLevel, assetPath, languageName, wordColumnHeader). Central registry `kAvailableLanguageConfigs` lists all 3 currently available CSVs (de_B2, de_C1, es_B2). `findLanguageConfig()` utility for lookup.
- **`VocabularyLoader`** (`shared/data/vocabulary_loader.dart`): Async asset-based CSV loader using `rootBundle.loadString()`. In-memory cache keyed by `config.key`. RFC 4180-compliant CSV parser (handles embedded commas, escaped double-quotes). Exposes `cachedWords()` for synchronous read-after-warm. Riverpod `FutureProvider.family<List<FlashcardItem>, LanguageConfig>` for Riverpod-native consumers.
- **`VocabularyRepository` (updated)**: Now a thin synchronous facade over `VocabularyLoader` cache. `warmUp(config)` delegates to loader. `getWords()` returns from cache (empty + assert on miss). Backward-compatible API; no changes needed in `ActiveBatchNotifier` or `SessionNotifier`.
- **`pubspec.yaml`**: Registered `assets/data/de_b2.csv`, `assets/data/de_c1.csv`, `assets/data/es_b2.csv`.
- **`SplashScreen` (updated)**: Converted to `ConsumerStatefulWidget`. During splash delay, warms cache for all `kAvailableLanguageConfigs` in parallel (`Future.wait`). Subtle `CircularProgressIndicator` shown during load.
- **`ActiveLanguageProvider`** (`shared/state/active_language_provider.dart`): `NotifierProvider<ActiveLanguageNotifier, LanguageConfig?>`. Derives initial state from `onboardingProvider` (first target language + its CEFR level). `switchTo(config)`, `switchToByKey()`. `availableForUser()` filters `kAvailableLanguageConfigs` to the user's chosen target languages.
- **`HomeScreen` (updated)**: Watches `activeLanguageProvider`. Language switcher chips rendered above stats card — single-language users see a pill label; multi-language users see animated tappable chips. Drip button now passes `config: activeLang` to `injectDrip()`. Snackbar includes language name. Stats card shows "Studying: German B2" row.
- **`SettingsScreen` (updated)**: Profile section shows Active Study Language. Multi-language users get a `DropdownButton` picker; single-language users get a read-only row. Writes to `activeLanguageProvider` via `switchTo()`.
- **`ActiveBatchNotifier.injectDrip` (updated)**: Accepts `LanguageConfig? config` param. Derives `langCode`/`level` from config, falls back to legacy string params for backward compatibility.

**Decisions**
- Cache warm-up happens at splash for all registered configs (not just user's chosen ones). Overhead is minimal (~3 CSVs, <100 words each). This ensures zero-latency on first drip.
- `VocabularyRepository` kept as a sync facade (not deleted) to avoid refactoring `ActiveBatchNotifier._seedInitialBatch()` which runs synchronously during Riverpod build. Seed will be async-refactored in WL-610.
- `activeLanguageProvider` re-derives from `onboardingProvider` on build — so if the user changes target languages in onboarding, active language resets correctly.
- Batch isolation per language (separate 200-word pools per lang) is deferred to WL-610. Currently all languages share one batch pool; language config controls which words are *injected* via drip.

**Next session**
- WL-610: Multi-Language Study Sessions (per-language batch isolation, language-scoped SRS).

---

### Session: 2026-03-05 (Session 8 — WL-610: Multi-Language Study Sessions)

**What was done**
- **`BatchEntry.languageKey`**: New field (default `'de_b2'`). Tags every batch word with its source language config key. `copyWith` updated.
- **`FlashcardItem.languageKey`**: New field (default `''`). Carried through from `BatchEntry` into the session card so the session screen can display the language badge and route SRS updates correctly.
- **`LanguageBatchNotifier` + `languageBatchProvider` (family)**: Core of WL-610. `NotifierProviderFamily<LanguageBatchNotifier, List<BatchEntry>, LanguageConfig>` — one independent 200-word Active Batch with isolated SRS state per `LanguageConfig`. `injectDrip()`, `applyRating()`, `moveToVault()`, `remove()`, `clearNewTodayFlags()` all operate on the correct per-language pool. Seeds 10 words from the cache for each language on first build.
- **`ActiveBatchNotifier` (refactored)**: Now a thin delegation wrapper pointing to the `de_b2` language batch via `languageBatchProvider`. All pre-WL-610 call sites (`HomeScreen`, `BatchScreen`, `SessionNotifier` fallback) continue to compile and work without changes.
- **`SessionState` (updated)**: `SessionCardResult` gains `languageKey`. `perLanguageStats` computed property returns `Map<String, LanguageSessionStats>`. `isMultiLanguage` bool. `LanguageSessionStats` value object (languageKey, languageName, reviewed, mastered).
- **`SessionNotifier` (updated)**: `startSession()` accepts `config` (single language) or `configs` (multi-language list). Per-language batches drawn from `languageBatchProvider(cfg)`, interleaved, shuffled, capped at `maxCards`. `submitRating()` now routes SRS update to the correct `languageBatchProvider` by matching card's `languageKey` against `kAvailableLanguageConfigs`.
- **`SessionScreen` (updated)**: `_FrontContent` uses a `Stack`; `_LanguageBadge` positioned top-right shows 'DE B2' / 'ES B2' etc. Only rendered when `card.languageKey` is non-empty.
- **`SessionCompleteScreen` (updated)**: Shows `_LanguageBreakdown` (per-language reviewed/mastered) for multi-language sessions. Shows `_SingleLanguageNote` (language pill) for single-language sessions.
- **`HomeScreen` (updated)**: `startSession()` call now passes `config: activeLang`. Stats card reads from `languageBatchProvider(activeLang)` when active language is set.
- **`BatchScreen` (updated)**: Reads `languageBatchProvider(activeLang)` when active language is set. AppBar title shows `'Batch · German B2'`.

**Decisions**
- `ActiveBatchNotifier` kept as a delegation wrapper (not removed) to avoid breaking any remaining legacy references. The wrapper mirrors `languageBatchProvider(de_b2)` via `ref.watch`, so it stays reactive.
- Per-language batch capacity is 200 words each — not shared across languages. A user with German B2 + Spanish B2 can have up to 400 words total across both pools.
- Multi-language session mode (`configs: [de, es]`) is wired in `SessionNotifier` but not yet exposed in the UI as a toggle — that is intentional per PRD priority order. The toggle can be added as a follow-on with zero changes to the session logic.
- SRS routing in `submitRating` uses `kAvailableLanguageConfigs` as the lookup table; unknown language keys fall back to the legacy `activeBatchProvider` gracefully.

**Next session**
- WL-500: Ghost Backup / Data Persistence (SQLite + SQLCipher local storage; persist batch, vault, streak, settings across restarts).

---

## Notes from Developers (Handoff)

### For future devs

- **PRD:** Use `prdv2.md` for product/feature spec; `prd-word-learn.md` is the long-form version.
- **Stories:** All acceptance criteria and tasks are in `user-stories.md` (WL-001 … WL-610). Map Kanban items to these IDs.
- **Data:** Vocabulary lives in `data/*.csv`. Format: `German Word, English Meaning, German Example Sentence, English Translation`. Design for encrypted/obfuscated word list in app (per PRD).
- **Design:** Swiss Modernist, 8px grid, Ligne Claire. Colors/typography in PRD Design System section; reuse in Flutter theme.
- **State:** Riverpod in use; `onboardingProvider` holds onboarding choices. Auth and subscription state to be added when auth/IAP are enabled.
- **Auth & payment:** Deferred and disabled for easier testing. Auth screen and Paywall (IAP) are placeholders; enable when ready (WL-001–005, WL-016 full, WL-300, WL-301, WL-310).
- **Backend:** Supabase (Auth, DB, Edge Functions). Local-first: SQLite + SQLCipher for progress; sync via “Ghost Backup” protocol.

---

*Update this file at the end of each implementation session. Move items between To Do / In Progress / Done and add a new Session Notes block.*
