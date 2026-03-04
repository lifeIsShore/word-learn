# WordLearn — Documentation

**Purpose:** Project overview, setup, architecture, and pointers to PRD and user stories for developers and contributors.

**Last Updated:** 2026-03-05

---

## 1. Project Overview

**WordLearn** is a mobile-first language learning app focused on **vocabulary acquisition** for intermediate to advanced learners (A2–C2 CEFR). It emphasizes:

- **Spaced repetition:** SM-2 algorithm for long-term retention.
- **Multi-language:** Independent language cards (e.g. en-de, en-fr) with separate progress.
- **Swiss Modernist UI:** Minimal, distraction-free, 8px grid, Ligne Claire style.
- **Accountability:** Curfew (daily deadline), Ice State (visual priming), Ash Protocol (streak reset if missed).
- **Local-first:** SQLite + SQLCipher on device; cloud sync for backup and cross-device.
- **Modular languages:** New languages via config + data (e.g. YAML + CSV), no code change.

**Platform:** Flutter (Dart), targeting Android, iOS, and later desktop.

**References:**
- **Product & features:** `prdv2.md` (PRD), `user-stories.md` (stories and tasks).
- **Implementation tracking:** `IMPLEMENTATION_LOG.md` (Kanban, session notes, dev notes).
- **App structure:** `docs/BLUEPRINT.md` (tabs, pages, connections, panels, functions, dashboards).

---

## 2. Tech Stack

| Layer | Technology |
|-------|------------|
| **App** | Flutter 3.x, Dart 3.x |
| **State** | Riverpod (planned) |
| **Local DB** | SQLite + SQLCipher (AES-256) |
| **Backend** | Supabase (Auth, PostgreSQL, Edge Functions, Storage) |
| **HTTP** | Dio (with interceptors for JWT refresh) |
| **Models / serialization** | Freezed + json_serializable (planned) |
| **IAP** | in_app_purchase (iOS/Android) |

---

## 3. Repository Structure

```
word-learn/
├── docs/
│   ├── BLUEPRINT.md      # Tabs, pages, connections, panels, functions, dashboards
│   └── DOCUMENTATION.md  # This file
├── data/                 # Vocabulary CSVs (e.g. B2/C1 German)
├── prdv2.md             # Product requirements (main PRD)
├── prd-word-learn.md    # Long-form PRD
├── user-stories.md      # User stories and developer tasks (WL-001 …)
├── IMPLEMENTATION_LOG.md # Kanban, session notes, dev handoff
└── word_learn/           # Flutter app (created by flutter create)
    ├── lib/
    │   ├── main.dart
    │   ├── app.dart
    │   ├── core/         # Theme, constants, routing
    │   ├── features/     # Auth, onboarding, home, session, batch, vault, settings
    │   └── shared/       # Widgets, models, services
    ├── assets/
    │   └── config/       # languages.yaml, etc.
    ├── test/
    └── pubspec.yaml
```

---

## 4. Setup (Development)

**Prerequisites:**
- Flutter SDK (3.x), Dart 3.x
- Android Studio / Xcode for mobile
- Supabase project (for Auth and API later)

**Steps:**
1. Clone the repo and open the project root.
2. `cd word_learn && flutter pub get`.
3. (Optional) Add `.env` or config for Supabase URL and anon key; do not commit secrets.
4. Run: `flutter run` (choose device).

**Data:**
- Vocabulary CSVs live in `data/`. App may bundle encrypted/processed data; see PRD (word list protection).
- Language config: `assets/config/languages.yaml` (see PRD Modular Language System).

---

## 5. Architecture (High Level)

- **Local-first:** Device is source of truth for progress (active_batch, vault, SRS). Sync to Supabase for backup and multi-device.
- **Auth:** Supabase Auth (email, Google, Apple). JWT stored securely; refresh via interceptor.
- **Study flow:** Home → Start Session → load due + new words from local DB → flashcard loop → rate each card → SM-2 update → on last card submit session complete → server: Curfew check, streak update, backup.
- **Curfew / Ash:** Server compares completion time (UTC) with user Curfew; if missed, streak resets (Ash). Ice State is client-side theme when &lt; 1 hr to Curfew.

---

## 6. Key Documents Quick Reference

| Document | Use |
|----------|-----|
| **prdv2.md** | Product vision, features, data model, design system, API, security. |
| **user-stories.md** | Acceptance criteria and developer tasks per story (WL-001 … WL-610). |
| **IMPLEMENTATION_LOG.md** | What’s to do, in progress, done; session notes; notes for other devs. |
| **docs/BLUEPRINT.md** | Screens, tabs, navigation, panels, formulas, dashboards. |
| **docs/DOCUMENTATION.md** | This file: overview, setup, structure, architecture. |

---

## 7. Conventions

- **User story IDs:** WL-001, WL-002, … (see user-stories.md).
- **Design:** 8px grid, colors and typography from PRD (e.g. Teal, Paper White, Futura/Helvetica).
- **Words:** Encrypted or otherwise protected in-app (see PRD); word list is core IP.

---

*Keep this file updated when project structure or tooling changes.*
