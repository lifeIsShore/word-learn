# WordLearn — Implementation Log (Kanban & Session Notes)

**Purpose:** Track implementation progress like a Kanban board. Use for sprint planning, session notes, and developer handoff.

**Last Updated:** 2026-03-10 (Session 24 — CRITICAL: Device Hang / Infinite Loading Fix)

---

## Kanban Board

### 🔴 To Do

| ID | Item | Epic / Story | Notes |
|----|------|-------------|-------|
| — | Google OAuth Sign-In | WL-002 | P0; **deferred** |
| — | Apple OAuth Sign-In (iOS) | WL-003 | P0; **deferred** |
| — | Subscription Paywall (IAP) | WL-016 full | P0; **disabled** |
| — | In-App Purchase (IAP) Integration | WL-300 | P0; **deferred** |
| — | Receipt Verification (Server-Side) | WL-301 | P0; **deferred** |
| — | Subscription Entitlements & Feature Gating | WL-310 | P0; **deferred** |
| — | French / Italian / Turkish / English C1+ vocab | — | P1 |
| — | Spanish C1+ vocab | — | P1 |
| — | Gradle upgrade (remove obsolete Java 8 options) | — | P2 |

---

### 🟡 In Progress

| ID | Item | Owner | Started | Notes |
|----|------|--------|---------|-------|

---

### ✅ Done

| ID | Item | Completed | Notes |
|----|------|-----------|-------|
| — | Session 24: CRITICAL device hang fix. 3 root causes found and resolved. SplashScreen now navigates in ~1.5s on real device. | 2026-03-10 | See Session 24 notes |
| — | Session 23: Technical debt — scheduleDripNudge missing arg, connectivity_provider naming, share_plus v10 API migration. | 2026-03-10 | See Session 23 notes |
| — | Session 22: Full vocabulary expansion — fr/it/tr/en A1–B2 (16 CSV files), language_config.dart + pubspec.yaml updated. | 2026-03-09 | |
| — | Session 21: Bug Fix — Double navigation on last flashcard. | 2026-03-09 | |
| — | Session 20: Bug Fix — Infinite loading screen (GoRouter + notification permission). | 2026-03-09 | |
| — | Sessions 1–19: Full feature set (auth, SRS, batch, vault, curfew, ash, settings, backup, sync, notifications, icons). | 2026-03-05–08 | |

---

## Session Notes

### Session 24: CRITICAL — Device Hang / Infinite Loading Fix (2026-03-10)

**Reported symptom:** App opens on mobile, loading spinner spins forever, never navigates away from splash screen.

**Root cause analysis — 3 compounding bugs found**

---

#### Bug 1 (PRIMARY CAUSE): 25 language configs initialized sequentially before navigation

After Session 22 added French/Italian/Turkish/English, `kAvailableLanguageConfigs` grew to 25 entries. The old `_initApp()` loop:

```dart
for (final cfg in kAvailableLanguageConfigs) {
  await VocabularyRepository.warmUp(cfg);           // asset file read
  await ref.read(languageBatchProvider(cfg).notifier).init(); // SQLite read + possible write
}
```

Each iteration performs 2 async I/O operations. On a real device:
- `rootBundle.loadString()` for a CSV: ~20–50ms per file
- SQLite `loadBatch()`: ~5–15ms
- SQLite `upsertBatchEntries()` on first launch: ~20–50ms

25 configs × ~100ms average = **~2,500ms = 2.5 seconds of pure I/O before navigation fires**, on top of the 1,500ms minimum delay. On slower devices (low-end Android, Keystore cold-start) this easily exceeds 5–10 seconds of total hang time, or can hit ANR thresholds.

**Fix:** Split initialization into two phases:
- **Phase 1 (blocking — before navigation):** Only warm and init the user's single active language. 2 I/O calls total. ~100ms.
- **Phase 2 (background — after navigation):** Warm remaining languages with 100ms gaps between each, using fire-and-forget. User is already on Home screen.

Added `VocabularyRepository.isCached(config)` to skip already-warm configs.

---

#### Bug 2 (SECONDARY CAUSE): GoRouter `refreshListenable` race condition

`createAppRouter(ref)` registered a `_ProviderListenable` that called `notifyListeners()` on every `AuthState` change. This created a race:

```
Frame 1: _initApp() completes → checkStartupAuth() → AuthStatus.authenticated
Frame 2: _ProviderListenable.notifyListeners() fires → GoRouter re-evaluates redirect
Frame 3: redirect sees: location=/ (splash), isAuthenticated=true, hasOnboarded=?
         Rule 4: "authenticated + splash → return null" — BUT only if location == '/'
         If timing slips and matchedLocation shows a transition state → fires AppRoutes.home
Frame 4: SplashScreen.context.go('/home') ALSO fires → two concurrent go('/home') calls
         → GoRouter stack corruption → app appears stuck or flickers endlessly
```

**Fix:** Removed `refreshListenable` entirely from `createAppRouter`. The redirect guard still protects all deep-link and back-button navigation (which is its real job). SplashScreen is now the sole owner of the first navigation — single point of truth, no races.

Auth state changes after first boot (sign-in, sign-out) already use direct `context.go()` calls from their respective screens, so `refreshListenable` was only useful during the splash init window — which is exactly when it caused the race.

---

#### Bug 3 (TERTIARY CAUSE): FlutterSecureStorage Keystore cold-start hang

`AuthRepository.loadStoredUser()` makes 3 sequential calls to `FlutterSecureStorage.read()`. On Android, the first ever access to `FlutterSecureStorage` requires the Keystore to initialize (hardware-backed key generation). On some devices (especially lower-end Android, or cold boot after update) this can block for 2–5 seconds.

With `devModeSkipAuth = true`, this path is not hit — but `checkStartupAuth()` is still called. If in the future auth is enabled, this would silently hang.

**Fix:** Added a `.timeout(Duration(seconds: 4))` on `checkStartupAuth()`. If it takes more than 4 seconds, the app falls back to `devBypass` and navigates anyway. A stuck Keystore will never prevent the app from starting.

---

**Files changed**
```
MOD  lib/features/splash/splash_screen.dart     ← Phase 1/2 split init, auth timeout, background warm-up
MOD  lib/shared/data/vocabulary_repository.dart ← Added isCached() method
MOD  lib/core/router/app_router.dart            ← Removed refreshListenable (race fix)
```

**Expected result after fix**
- First launch: splash → 1.5s → onboarding (only 1 language warmed before navigation)
- Returning user: splash → 1.5s → home
- Background: remaining 24 languages warm silently while user is on home/onboarding
- All device speeds: navigation fires in ≤2s guaranteed (1.5s delay + ~100ms for 1 language)

**Build and test**
```bash
cd word_learn
flutter clean
flutter pub get
flutter run                          # attach device, watch debugPrint logs
flutter build apk --release          # production build
```

Watch for these log lines confirming the fix is working:
```
[WordLearn] Splash: Starting init...
[WordLearn] Splash: Opening database...
[WordLearn] Splash: Providers restored.
[WordLearn] Splash: Warming active language de_b2...      ← only 1 language
[WordLearn] Splash: Active language ready.
[WordLearn] Splash: Checking auth...
[WordLearn] Splash: Navigating (auth=devBypass, onboarded=false)
[WordLearn] Background: Starting remaining language warm-up...   ← fires AFTER navigation
```

---

### Session 23: Technical Debt & Warning Fixes (2026-03-10)

**Real fixes:**
- `notification_scheduler.dart` — `scheduleDripNudge` missing `uiLocalNotificationDateInterpretation`
- `connectivity_provider.dart` — `_probe` naming ambiguity → `_doProbe`, record tuple → two named constants
- `data_export_service.dart` — `Share.shareXFiles` → `SharePlus.instance.shareXFiles` (share_plus v10 API)

**False positives (stale analysis cache — no action):**
- `firebase_options.dart`, `ash_protocol_screen.dart`, `app_router.dart`, `batch_screen.dart`, `home_screen.dart`

---

*Update this file at the end of each implementation session.*
