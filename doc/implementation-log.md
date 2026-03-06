# Implementation Log

## Project Overview
WordLearn - Academic word learning app with SRT, CEFR alignment, minimalist design.

Tech: Flutter for mobile (Android first), later iOS/desktop.

---

## Current Status
- Project initialized: March 4, 2026
- Last implemented: March 6, 2026
- Implemented Epics: Phase 0 (Foundation), Epic 1 (Auth), Epic 2 (Onboarding)
- General Notes: Project foundation fully scaffolded. Auth + Onboarding screens implemented.

---

## Implemented Features

### Phase 0 — Project Foundation (March 6, 2026)
- [x] `pubspec.yaml` — all dependencies defined (Riverpod, go_router, Supabase, SQLCipher, etc.)
- [x] Folder architecture: `lib/core/`, `lib/features/`, `lib/shared/`
- [x] `assets/` structure: config, images, icons, fonts
- [x] `assets/config/languages.yaml` — all 6 language configs
- [x] **Theme system** — `AppColors`, `AppTextStyles`, `AppSpacing`, `AppTheme` (light + dark)
- [x] **Router** — `app_router.dart` with go_router, all routes defined, auth guard
- [x] **Constants** — `app_constants.dart` (Supabase config, batch limits, SRS params)

### Epic 1 — Authentication (WL-001 to WL-003)
- [x] `AuthRepository` — email signup, email signin, Google OAuth, Apple OAuth, signOut, session restore
- [x] `authStateProvider` — Riverpod stream of Supabase User
- [x] `SplashScreen` — resolves auth state, redirects to SignIn/Welcome/Home
- [x] `SignInScreen` — email + password, client-side validation, server error handling
- [x] `SignUpScreen` — email + password + confirm + display name, password strength indicator, terms checkbox
- [x] `WlTextField` — reusable input with password toggle, error display
- [x] `WlButtons` — `WlPrimaryButton`, `WlOutlinedButton`, `WlSocialButton`
- [x] `WlErrorBanner` — server/network error display
- [x] `WlPasswordStrengthIndicator` — 4-level visual indicator

### Epic 2 — Onboarding (WL-010 to WL-020)
- [x] `OnboardingNotifier` (Riverpod) — state for all onboarding data
- [x] `WelcomeScreen` — clean landing with 3 feature bullets
- [x] `LanguageSelectionScreen` — multi-select language tiles with CEFR level picker per language
- [x] `CurfewSetupScreen` — time picker, Ash Protocol warning, "I Accept" CTA
- [x] `DripSetupScreen` — slider 5–40 words/day with intensity labels
- [x] `PaywallScreen` — plan toggle (monthly/6-month), feature comparison table, free tier option
- [x] `_OnboardingProgressBar` — 4-step progress indicator

---

## Pending Tasks (Next Sprint)

### Code Generation (Must run before building)
- [ ] `flutter pub get`
- [ ] `dart run build_runner build --delete-conflicting-outputs`
  - Generates: `app_router.g.dart`, `auth_provider.g.dart`, `auth_repository.g.dart`, `onboarding_provider.g.dart`, `onboarding_provider.freezed.dart`

### Supabase Setup
- [ ] Create Supabase project at https://app.supabase.com
- [ ] Add URL + anon key to `lib/core/constants/app_constants.dart`
- [ ] Create `users` table (SQL from PRDv2)
- [ ] Enable Google OAuth provider in Supabase Auth

### Epic 3 — Core Study Loop (WL-050 to WL-100) ← NEXT
- [ ] SQLite local DB setup (sqflite_sqlcipher)
- [ ] DatabaseService — create/open/migrate encrypted DB
- [ ] SRS engine (SM-2 algorithm)
- [ ] FlashcardScreen — word display, tap to reveal, difficulty buttons
- [ ] StudySessionNotifier — manages card queue, SRS updates
- [ ] SessionCompleteScreen

### Epic 4 — Active Batch Management (WL-140 to WL-160)
### Epic 5 — The Vault (WL-170 to WL-190)
### Epic 6 — Curfew & Ash Protocol (WL-200 to WL-220)

---

## Architecture Decisions
- **Feature-first structure**: `lib/features/<feature>/presentation|data|providers`
- **Shared UI**: `lib/shared/widgets/` — reusable across features
- **Core**: `lib/core/` — theme, router, constants (no business logic)
- **Code generation**: Riverpod annotations + Freezed (run build_runner before each build)
- **Auth guard**: Router-level redirect based on `authStateProvider`

## Notes
- Futura font files need to be added to `assets/fonts/` (or swap to Google Fonts `Nunito`/`DM Sans` for dev)
- Supabase URL/key are placeholders — replace before first run
- `app_router.g.dart` and other `.g.dart` files are generated — do NOT edit manually
