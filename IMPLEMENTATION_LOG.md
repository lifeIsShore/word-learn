# WordLearn — Implementation Log (Kanban & Session Notes)

**Purpose:** Track implementation progress like a Kanban board. Use for sprint planning, session notes, and developer handoff.

**Last Updated:** 2026-03-09 (Session 22 — Bug Diagnosis + Full Vocabulary Expansion)

---

## Kanban Board

### 🔴 To Do

| ID | Item | Epic / Story | Notes |
|----|------|-------------|-------|
| — | Google OAuth Sign-In | WL-002 | P0; **deferred** |
| — | Apple OAuth Sign-In (iOS) | WL-003 | P0; **deferred** |
| — | Subscription Paywall (IAP) | WL-016 full | P0; **disabled** — placeholder only, enable later |
| — | In-App Purchase (IAP) Integration | WL-300 | P0; **deferred** |
| — | Receipt Verification (Server-Side) | WL-301 | P0; **deferred** |
| — | Subscription Entitlements & Feature Gating | WL-310 | P0; **deferred** |
| — | Vault Audit & Re-Validation (Quarterly) | WL-190 | P2, 4 pts — **deferred** |
| — | French / Italian / Turkish / English C1 vocab | — | P1 — A1–B2 added this session; C1+ still missing |
| — | Spanish C1 vocab | — | P1 — A1–B2 complete; C1 still missing |

| — | ~~Conflict Resolution (Multi-Device Sync)~~ | ~~WL-510~~ | ~~P1, 3 pts~~ → **In Progress** |
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
| — | Session 22: Bug Diagnosis + Full Vocabulary Expansion. Root cause of remaining loading issue traced to missing CSV assets + missing language_config.dart entries for fr/it/tr/en. Added 16 new CSV files (fr/it/tr/en A1–B2, 15 words each). Updated language_config.dart + pubspec.yaml. | 2026-03-09 | See Session 22 notes |
| — | Session 21: Bug Fix — Double navigation on last flashcard. submitRating callback in SessionScreen called context.go(sessionComplete) AND build() reacted to isComplete via postFrameCallback, firing context.go() twice. Removed the eager navigate from the onRating callback; build() is now the single navigation owner. | 2026-03-09 | See Session 21 notes |
| — | Session 20: Bug Fix — Infinite loading screen on device. Two bugs: (1) GoRouter recreated on every build in app.dart, causing nav loop back to splash. (2) Notification permission dialog awaited during init, blocking splash indefinitely. | 2026-03-09 | See Session 20 notes |
| — | Session 19: Offline UX — ConnectivityNotifier (TCP probe, 15s poll), OfflineBanner (animated, slides on/off), OfflineAwareBody widget, BackupNotifier skips sync when offline with graceful error, OfflineBanner wired to HomeScreen + SettingsScreen | 2026-03-08 | Zero new dependencies |
| — | Session 18: App icon + splash screen — icon_1024.png (teal W lettermark), icon_foreground_1024.png, all Android mipmap densities, all iOS icon sizes, launch images, flutter_launcher_icons + flutter_native_splash config in pubspec, adaptive icon XML, Android colors.xml + styles.xml updated, iOS LaunchScreen.storyboard updated, CFBundleDisplayName → WordLearn, install_assets.py + wordlearn_assets.zip for one-command install | 2026-03-08 | Run install_assets.py then flutter pub get + dart run flutter_launcher_icons + dart run flutter_native_splash:create |
| — | Session 17: Push Notifications — NotificationService (FCM + local), NotificationScheduler (daily reminder, streak-at-risk warning, drip nudge), main.dart Firebase init, firebase_options.dart placeholder, devModeSkipFirebase flag, Android manifest permissions + FCM channel + boot receiver, iOS AppDelegate + Info.plist background modes, streak warning cancelled on session complete | 2026-03-08 | See Session 17 notes |
| — | Session 16: Vocab expansion (de_a1/a2/b1, es_a1/a2/b1 — 10 words each), language_config.dart updated, de_c1 header fix. Router guards — auth + onboarding redirect logic, _ProviderListenable, createAppRouter(ref) | 2026-03-08 | See Session 16 notes |
| — | WL-410: Privacy Controls — DataExportService (JSON + native share sheet), AccountDeletionService (backend soft-delete + local wipe), backend DELETE /user/delete, Settings ACCOUNT section wired | 2026-03-06 | See Session 15 notes |
| — | WL-510: Conflict Resolution — SyncResolver (LWW), BackupService.downloadAndMerge(), bidirectional sync in BackupNotifier, 30-min background timer in HomeScreen, lastMergedAt in Settings | 2026-03-06 | See Session 14 notes |
| — | WL-190: Vault Audit (quarterly re-validation, AuditNotifier, AuditSessionScreen, AuditCompleteScreen, audit due banner in VaultScreen) + Polish (empty batch guard, snackbar consistency) | 2026-03-05 | See Session 13 notes |
| — | WL-500 Phase 2: Ghost Backup — BackupPayload, BackupService (AES-256-CBC + gzip), BackupNotifier, backend `/api/v1/backup` (POST/GET/DELETE), Settings Sync Now, session-complete trigger | 2026-03-05 | See Session 12 notes |
| — | WL-001/004/005: Flutter auth layer — AuthRepository, AuthNotifier, AuthUser, full sign-in/sign-up UI, dev bypass flag | 2026-03-05 | `devModeSkipAuth=true`; see Session 11 notes |
| — | WL-001/004/005: Backend auth — FastAPI + PostgreSQL + JWT (signup, signin, refresh, logout, /me). Docker Compose stack with PgAdmin. Self-hosted, no Supabase. | 2026-03-05 | `backend/` directory; see Session 10 notes |
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

---

## Session Notes

### Session 22: Bug Diagnosis + Full Vocabulary Expansion (2026-03-09)

**Full diagnosis performed**

Three categories of issues were identified:

**✅ Already fixed (Sessions 20–21)**
- *Infinite loading screen* (Session 20): Two root causes — GoRouter recreated on every `build()` call, and Android notification permission dialog blocking splash init. Both resolved.
- *Double navigation on last flashcard* (Session 21): `submitRating` callback was firing `context.go()` in addition to `build()`'s reactive `postFrameCallback`. Removed duplicate navigation from callback.

**🔴 Critical — Root cause of remaining loading hang on device (this session)**

**Bug 3: Missing CSV assets for 4 of 6 supported languages**

`kAppLanguages` in `app_languages.dart` lists 6 languages: English, German, French, Spanish, Italian, Turkish. The onboarding target-language picker shows all 6. However, `kAvailableLanguageConfigs` in `language_config.dart` only registered German (A1–C1) and Spanish (A1–B2).

When a user selected French, Italian, Turkish, or English as a target language during onboarding:
- `findLanguageConfig(languageCode: 'fr', cefrLevel: 'B1')` → returned `null`
- `activeLanguageProvider.build()` → state set to `null`
- `SplashScreen._initApp()` → `languageBatchProvider(cfg).notifier.init()` and `VocabularyRepository.warmUp(cfg)` only ran for registered configs (de + es) — but the active language was null or unregistered
- `LanguageBatchNotifier.build()` for the selected language was never called → batch stays empty `[]`
- On `HomeScreen`, `START SESSION` was disabled (empty batch guard) and drip button wouldn't inject words
- In some flows, the null activeLanguageProvider caused the home screen to spin indefinitely waiting for state that never arrived

**Fix: Added 16 new CSV vocabulary files + registered all in code**

New CSV files created (15 words each, A1–B2 per language):
- `fr_a1.csv`, `fr_a2.csv`, `fr_b1.csv`, `fr_b2.csv` — French
- `it_a1.csv`, `it_a2.csv`, `it_b1.csv`, `it_b2.csv` — Italian
- `tr_a1.csv`, `tr_a2.csv`, `tr_b1.csv`, `tr_b2.csv` — Turkish
- `en_a1.csv`, `en_a2.csv`, `en_b1.csv`, `en_b2.csv` — English (as target language)

All files follow the `VOCABULARY_ENTRY_GUIDE.md` format exactly: header row `Target Word,English Meaning,Example Sentence,English Translation`, UTF-8, RFC 4180 quoting.

**Files changed**
```
NEW  assets/data/fr_a1.csv          ← French A1 (15 words)
NEW  assets/data/fr_a2.csv          ← French A2 (15 words)
NEW  assets/data/fr_b1.csv          ← French B1 (15 words)
NEW  assets/data/fr_b2.csv          ← French B2 (15 words)
NEW  assets/data/it_a1.csv          ← Italian A1 (15 words)
NEW  assets/data/it_a2.csv          ← Italian A2 (15 words)
NEW  assets/data/it_b1.csv          ← Italian B1 (15 words)
NEW  assets/data/it_b2.csv          ← Italian B2 (15 words)
NEW  assets/data/tr_a1.csv          ← Turkish A1 (15 words)
NEW  assets/data/tr_a2.csv          ← Turkish A2 (15 words)
NEW  assets/data/tr_b1.csv          ← Turkish B1 (15 words)
NEW  assets/data/tr_b2.csv          ← Turkish B2 (15 words)
NEW  assets/data/en_a1.csv          ← English as target A1 (15 words)
NEW  assets/data/en_a2.csv          ← English as target A2 (15 words)
NEW  assets/data/en_b1.csv          ← English as target B1 (15 words)
NEW  assets/data/en_b2.csv          ← English as target B2 (15 words)
MOD  lib/shared/models/language_config.dart  ← Added fr/it/tr/en to kAvailableLanguageConfigs (24 configs total)
MOD  pubspec.yaml                   ← Registered all 24 CSV files under flutter.assets
```

**Testing checklist**
- Select French / Italian / Turkish / English as target language in onboarding
- Splash completes without hanging — all 24 language configs warm and init
- HomeScreen shows correct language badge (e.g. "French B1")
- Daily Drip injects French/Italian/Turkish/English words correctly
- START SESSION works and flashcards display correct target language
- Language switcher in Settings shows all user-selected languages

**Remaining vocabulary gaps (next session)**
- C1 level for: French, Italian, Turkish, English (as target)
- C2 level for all languages
- Spanish C1 (existing gap carried forward)
- German has C1 complete; no C2 yet

---

### Session 21: Bug Fix — Double navigation on last flashcard (2026-03-09)

**Bug found**
`SessionScreen` was firing `context.go(AppRoutes.sessionComplete)` **twice** when the user rated the final card:

1. **First call** — inside the `onRating` callback in `_DifficultyButtons`:
   ```dart
   ref.read(sessionProvider.notifier).submitRating(rating);
   setState(() => _revealed = false);
   final next = ref.read(sessionProvider);
   if (next.isComplete && mounted) {
     context.go(AppRoutes.sessionComplete);  // ← call #1
   }
   ```

2. **Second call** — in `build()`, which is triggered by the state change from `submitRating`:
   ```dart
   if (session.isComplete) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
       if (mounted) context.go(AppRoutes.sessionComplete);  // ← call #2
     });
     ...
   }
   ```

**Fix**
Removed the eager `context.go` from the `onRating` callback entirely.

**File changed**
```
MOD  lib/features/session/session_screen.dart
```

---

### Session 20: Bug Fix — Infinite Loading Screen on Device (2026-03-09)

**Bug 1 (Critical): GoRouter recreated on every build — `lib/app.dart`**

`WordLearnApp` was a `ConsumerWidget`. Its `build()` method called `createAppRouter(ref)` directly. Every time any provider changed, Flutter called `build()` again, constructing a brand new `GoRouter` instance, resetting navigation back to splash.

**Fix:** Converted to `ConsumerStatefulWidget`. Router cached via `late final _router = createAppRouter(ref)`.

**Bug 2 (Secondary): Notification permission dialog blocked splash — `lib/features/splash/splash_screen.dart`**

`requestNotificationsPermission()` on Android stalls for user input, blocking `_initApp()` entirely.

**Fix:** Notifications deferred to fire-and-forget after `context.go()`.

**Files changed**
```
MOD  lib/app.dart
MOD  lib/features/splash/splash_screen.dart
```

---

*Update this file at the end of each implementation session. Move items between To Do / In Progress / Done and add a new Session Notes block.*
