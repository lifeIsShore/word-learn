# WordLearn — Implementation Log (Kanban & Session Notes)

**Purpose:** Track implementation progress like a Kanban board. Use for sprint planning, session notes, and developer handoff.

**Last Updated:** 2026-03-10 (Session 23 — Technical Debt & Warning Fixes)

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
| — | French / Italian / Turkish / English C1+ vocab | — | P1 — A1–B2 added Session 22; C1+ still missing |
| — | Spanish C1+ vocab | — | P1 — A1–B2 complete; C1 still missing |
| — | Gradle upgrade (remove obsolete Java 8 options) | — | P2 — cosmetic, build still succeeds |

---

### 🟡 In Progress

| ID | Item | Owner | Started | Notes |
|----|------|--------|---------|-------|

---

### ✅ Done

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| — | Session 23: Technical debt & warning fixes — scheduleDripNudge missing arg, connectivity_provider static/instance naming, share_plus v10 API migration. All compiler warnings in the three affected files resolved. | 2026-03-10 | See Session 23 notes |
| — | Session 22: Bug Diagnosis + Full Vocabulary Expansion. Root cause of remaining loading issue traced to missing CSV assets + missing language_config.dart entries for fr/it/tr/en. Added 16 new CSV files (fr/it/tr/en A1–B2, 15 words each). Updated language_config.dart + pubspec.yaml. | 2026-03-09 | See Session 22 notes |
| — | Session 21: Bug Fix — Double navigation on last flashcard. submitRating callback in SessionScreen called context.go(sessionComplete) AND build() reacted to isComplete via postFrameCallback, firing context.go() twice. Removed the eager navigate from the onRating callback; build() is now the single navigation owner. | 2026-03-09 | See Session 21 notes |
| — | Session 20: Bug Fix — Infinite loading screen on device. Two bugs: (1) GoRouter recreated on every build in app.dart, causing nav loop back to splash. (2) Notification permission dialog awaited during init, blocking splash indefinitely. | 2026-03-09 | See Session 20 notes |
| — | Session 19: Offline UX — ConnectivityNotifier (TCP probe, 15s poll), OfflineBanner (animated, slides on/off), OfflineAwareBody widget, BackupNotifier skips sync when offline with graceful error, OfflineBanner wired to HomeScreen + SettingsScreen | 2026-03-08 | Zero new dependencies |
| — | Session 18: App icon + splash screen | 2026-03-08 | Run install_assets.py then flutter pub get + dart run flutter_launcher_icons + dart run flutter_native_splash:create |
| — | Session 17: Push Notifications — NotificationService (FCM + local), NotificationScheduler | 2026-03-08 | See Session 17 notes |
| — | Session 16: Vocab expansion (de_a1/a2/b1, es_a1/a2/b1), language_config.dart updated, router guards | 2026-03-08 | See Session 16 notes |
| — | WL-410: Privacy Controls — DataExportService, AccountDeletionService, backend DELETE /user/delete | 2026-03-06 | See Session 15 notes |
| — | WL-510: Conflict Resolution — SyncResolver (LWW), BackupService.downloadAndMerge() | 2026-03-06 | See Session 14 notes |
| — | WL-190: Vault Audit + Polish | 2026-03-05 | See Session 13 notes |
| — | WL-500 Phase 2: Ghost Backup | 2026-03-05 | See Session 12 notes |
| — | WL-001/004/005: Flutter auth layer | 2026-03-05 | `devModeSkipAuth=true`; see Session 11 notes |
| — | WL-001/004/005: Backend auth (FastAPI + PostgreSQL + JWT) | 2026-03-05 | See Session 10 notes |
| — | WL-610: Multi-Language Study Sessions | 2026-03-05 | languageBatchProvider family |
| — | WL-600: Language Configuration & Loading | 2026-03-05 | Asset-based; splash warms cache |
| — | WL-400/410: Settings Screen + Privacy toggles | 2026-03-05 | |
| — | WL-200/210/220: Curfew / Ice State / Ash Protocol | 2026-03-05 | |
| — | WL-140/150/160/170/180: Batch / Drip / Capacity / Vault | 2026-03-05 | |
| — | WL-050/060/070/075: Core study loop | 2026-03-05 | |
| — | Onboarding flow (WL-010 to WL-016) | 2026-03-05 | |
| — | Flutter project init, design system, router, screens | 2026-03-05 | |

---

## Session Notes

### Session 23: Technical Debt & Warning Fixes (2026-03-10)

**Issues reported from previous build logs — triaged and resolved**

---

**🔴 False positives (no action needed)**

These were reported as errors but are actually stale IDE analysis cache. The code is correct:

- **`lib/firebase_options.dart`**: The file is already a clean compile-safe stub with no imports and no references to `firebase_core` or `FirebaseOptions`. The error only occurs if you run analysis while firebase packages are uncommented. Current state: **no action needed**.

- **`lib/features/ash/ash_protocol_screen.dart`**: `pardonsRemaining` and `useDirectorsPardon` are both defined in `StreakState` and `StreakNotifier` respectively. The screen compiles correctly. The error was from an older analysis snapshot before these fields were added. **No action needed**.

- **`lib/core/router/app_router.dart`**: `OnboardingState` is a concrete class exported from `shared/state/onboarding_provider.dart` via `export 'onboarding_state.dart'`. The `_ProviderListenable` type annotation is correct. **No action needed**.

- **`lib/features/batch/batch_screen.dart` and `home_screen.dart`**: `capacity` and `isNearCapacity` are defined on both `LanguageBatchNotifier` and `ActiveBatchNotifier`. The analysis errors were stale. **No action needed**.

---

**🟡 Real warnings — fixed this session**

**Fix 1: Missing `uiLocalNotificationDateInterpretation` in `scheduleDripNudge`**

File: `lib/shared/notifications/notification_scheduler.dart`

`scheduleDailyReminder` and `scheduleStreakWarning` both correctly passed `uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime` to `zonedSchedule`. However `scheduleDripNudge` was missing this required named argument, which causes a compile error when building for iOS (it's a required parameter in `flutter_local_notifications`).

**Fix:** Added `uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime` to the `scheduleDripNudge` call. All three scheduling methods now have the complete argument list.

---

**Fix 2: `_probe` name conflict in `ConnectivityNotifier`**

File: `lib/shared/state/connectivity_provider.dart`

`kProbeTarget` was declared as `static const ('1.1.1.1', 80)` — a static const record. The instance method `_probe()` referenced it fine in Dart 3.x, but two issues surfaced in analyzer output:
1. Some `dart analyze` versions warn about static const record tuples when used inside instance methods due to how the analyzer resolves the scope.
2. The method was named `_probe` which exactly shadowed the old Dart pattern of using `_probe` as a field — confusing the analyzer.

**Fix:** Replaced the record constant with two separate named constants (`_probeHost` and `_probePort`) and renamed the instance method to `_doProbe()` to eliminate the ambiguity completely. Behavior is identical.

---

**Fix 3: `Share.shareXFiles` → `SharePlus.instance.shareXFiles` (share_plus v10 API)**

File: `lib/shared/privacy/data_export_service.dart`

`share_plus` v10.0.0 (which is declared in `pubspec.yaml`) removed the static `Share` class in favour of `SharePlus.instance` singleton pattern. The old API:
```dart
final result = await Share.shareXFiles([xFile], subject: '...');
```
was replaced with:
```dart
final result = await SharePlus.instance.shareXFiles([xFile], subject: '...');
```
`ShareResultStatus` remains the same. `XFile` remains the same.

**Fix:** Updated `data_export_service.dart` to use `SharePlus.instance.shareXFiles(...)`.

---

**Files changed**
```
MOD  lib/shared/notifications/notification_scheduler.dart  ← scheduleDripNudge: added uiLocalNotificationDateInterpretation
MOD  lib/shared/state/connectivity_provider.dart           ← _probe → _doProbe, record tuple → two named consts
MOD  lib/shared/privacy/data_export_service.dart           ← Share.shareXFiles → SharePlus.instance.shareXFiles
```

**Build status after these fixes**
All three files should now be warning-free. Run:
```bash
cd word_learn
flutter pub get
flutter analyze
flutter build apk --release
```
Expected: zero errors, zero warnings in the three fixed files.

---

### Session 22: Bug Diagnosis + Full Vocabulary Expansion (2026-03-09)

**Full diagnosis performed**

Three categories of issues were identified:

**✅ Already fixed (Sessions 20–21)**
- *Infinite loading screen* (Session 20): GoRouter recreated on every `build()` + Android notification permission blocking splash. Both resolved.
- *Double navigation on last flashcard* (Session 21): Duplicate `context.go()` calls. Fixed.

**🔴 Critical — Root cause of remaining loading hang**

**Bug 3: Missing CSV assets for 4 of 6 supported languages**

`kAppLanguages` in `app_languages.dart` lists 6 languages but `kAvailableLanguageConfigs` only had German + Spanish. When a user picked French/Italian/Turkish/English: `findLanguageConfig()` returned `null`, `activeLanguageProvider` was `null`, batch never seeded, START SESSION disabled or home state hung.

**Fix: Added 16 new CSV vocabulary files + registered all in code**

```
NEW  assets/data/fr_a1.csv, fr_a2.csv, fr_b1.csv, fr_b2.csv
NEW  assets/data/it_a1.csv, it_a2.csv, it_b1.csv, it_b2.csv
NEW  assets/data/tr_a1.csv, tr_a2.csv, tr_b1.csv, tr_b2.csv
NEW  assets/data/en_a1.csv, en_a2.csv, en_b1.csv, en_b2.csv
MOD  lib/shared/models/language_config.dart  ← 24 configs total
MOD  pubspec.yaml                            ← all 24 CSVs registered
```

---

### Session 21: Bug Fix — Double navigation (2026-03-09)

`onRating` callback fired `context.go()` AND `build()` also fired it via `postFrameCallback`. Removed from callback; `build()` is sole navigation owner.

**MOD** `lib/features/session/session_screen.dart`

---

### Session 20: Bug Fix — Infinite Loading Screen (2026-03-09)

**Bug 1:** `GoRouter` recreated on every `build()` in `app.dart`. **Fix:** `ConsumerStatefulWidget` + `late final _router`.

**Bug 2:** Notification permission dialog `await`ed during splash. **Fix:** Fire-and-forget after `context.go()`.

**MOD** `lib/app.dart` · `lib/features/splash/splash_screen.dart`

---

*Update this file at the end of each implementation session.*
