# WordLearn PRDv2: Comprehensive Product Requirements Document
## The Detailed Operational Briefing for Development & Product Management

**Document Version:** 2.0  
**Status:** Ready for Development  
**Created:** March 2, 2026  
**Last Updated:** March 2, 2026  

---

## TABLE OF CONTENTS

1. [Executive Summary](#executive-summary)
2. [Product Vision & Positioning](#product-vision--positioning)
3. [Target Personas & User Segments](#target-personas--user-segments)
4. [Core Product Principles](#core-product-principles)
5. [Feature Overview](#feature-overview)
6. [Technical Architecture & Stack](#technical-architecture--stack)
7. [Data Models & Database Schema](#data-models--database-schema)
8. [Modular Language System](#modular-language-system)
9. [Design System & Visual Language](#design-system--visual-language)
10. [User Flows & Interactions](#user-flows--interactions)
11. [Core Modules & Features (Detailed)](#core-modules--features-detailed)
12. [API Specifications](#api-specifications)
13. [Monetization & Subscription Tiers](#monetization--subscription-tiers)
14. [Security, Privacy & Compliance](#security-privacy--compliance)
15. [Performance & Scalability Requirements](#performance--scalability-requirements)
16. [Quality Assurance & Testing Strategy](#quality-assurance--testing-strategy)
17. [Deployment & Release Strategy](#deployment--release-strategy)
18. [FAQ & Decision Log](#faq--decision-log)

---

## EXECUTIVE SUMMARY

**WordLearn** is a mobile-first language learning platform focused on **vocabulary acquisition** for intermediate to advanced learners (A2–C2 CEFR levels). Unlike entertainment-driven competitors, WordLearn prioritizes:

- **Spaced Repetition Theory (SRT)** with SM-2 algorithm for long-term retention
- **Multi-language simultaneous learning** via independent language cards
- **Swiss Modernist design aesthetic** for a premium, distraction-free experience
- **Accountability-based gamification** (The Curfew, The Ash Protocol)
- **Local-first architecture** with cloud sync for offline reliability
- **Modular language system** for effortless expansion to new languages

**Target Users:** Busy professionals, dedicated students, and language learners seeking high-efficiency vocabulary mastery without entertainment fluff.

**Monetization:** Monthly ($9.99) and 6-month ($49.99) subscription tiers with freemium baseline.

**Platform:** Native mobile apps (iOS 14+, Android 10+) built with Flutter/Dart.

---

## PRODUCT VISION & POSITIONING

### Ethos: "Academic Rigor Meets Minimalist Design"

WordLearn rejects the "gamified entertainment" paradigm prevalent in language learning. We assume our user is:
- A **high-functioning professional** or **dedicated student**
- **Value-conscious** about time over entertainment
- **Privacy-focused** and data-aware
- **Discipline-oriented** and willing to commit to daily practice

### Core Value Proposition

> **"A distraction-free, precision-engineered workstation for vocabulary mastery. Study smarter with spaced repetition, not longer with engagement mechanics."**

### Key Differentiators

| Feature | WordLearn | Competitors (Duolingo, Babbel) |
|---------|-----------|--------------------------------|
| **Target Level** | A2–C2 (Intermediate+) | A1–B1 (Beginner) |
| **Focus** | Vocabulary only | Grammar + Vocabulary |
| **SRS Algorithm** | SM-2 (refined) | Proprietary (opaque) |
| **Design** | Swiss Modernist (minimal) | Dopamine-driven (colorful) |
| **Offline Support** | Full (local-first) | Limited |
| **Multi-Language** | Simultaneous independent tracking | Sequential switching |
| **Accountability** | Hard streak reset (Ash Protocol) | Streak freezes (soft) |

---

## TARGET PERSONAS & USER SEGMENTS

### Persona 1: The Professional Scholar
**Profile:**
- Age: 25–55
- Education: University degree or equivalent
- Motivation: Career advancement, relocation, professional communication
- Time: 15–30 min/day (consistency valued over volume)
- Language Background: Native English speaker learning 1–2 languages
- Tech Comfort: High
- Pain Points: Limited time, need for visible progress, privacy concerns

**Goals:**
- Reach B2/C1 level for business communication
- Integrate learning into busy schedule without "app addiction"
- Export credentials for LinkedIn/professional networks

### Persona 2: The Dedicated Student
**Profile:**
- Age: 16–25
- Education: High school or university
- Motivation: Exams (DELF, DELE, Goethe-Zertifikat), academic excellence, travel
- Time: 30–60 min/day (highly consistent)
- Language Background: Multilingual or heritage language learner
- Tech Comfort: Very high
- Pain Points: Exam prep timing, competing with multiple subjects

**Goals:**
- Achieve C1+ vocabulary for standardized language exams
- Learn multiple languages simultaneously for multilingual fluency
- Track long-term progress with detailed metrics

### Persona 3: The Polyglot Adventurer
**Profile:**
- Age: 20–45
- Education: Variable
- Motivation: Travel, cultural immersion, hobby
- Time: 20–45 min/day (sporadic consistency)
- Language Background: Already fluent in 2+ languages
- Tech Comfort: High
- Pain Points: Context relevance (travel-specific vocab), motivation durability

**Goals:**
- Learn vocabulary for 3–6 languages simultaneously
- Focus on contextual/thematic vocabulary (travel, food, culture)
- Maintain streak and show progress without guilt mechanics

---

## CORE PRODUCT PRINCIPLES

### 1. **Academic Rigor**
- All vocabulary aligned to CEFR A1–C2 standards
- Example sentences sourced from authentic, published materials
- Spaced Repetition based on cognitive science (SM-2 algorithm)

### 2. **Minimalist Design**
- No animations purely for engagement
- No sound effects or haptic feedback (unless explicitly enabled)
- Swiss Modernist visual language (Helvetica/Futura, 8px grid, Ligne Clare illustrations)
- Distraction-free study environment

### 3. **User Data Sovereignty**
- Local-first: Progress stored on device with local SQLite + SQLCipher
- Server sync only for backup and cross-device persistence
- Transparent encryption: User controls what is synced
- No behavioral tracking or algorithmic recommendation feeds

### 4. **Accountability-Based Discipline**
- Curfew system: User-defined daily study deadline
- Ash Protocol: Hard streak reset at midnight if Curfew is missed
- No streak freezes; consistency is the only path to progress
- Ice State: UI palette shift one hour before Curfew (psychological priming)

### 5. **Modular Extensibility**
- Language system designed for effortless addition of new languages
- Single YAML config + CSV data = new language live
- No code changes required to add languages
- Validation pipeline ensures data integrity across all languages

### 6. **Privacy by Default**
- No user tracking, no ads, no third-party analytics
- Encrypted local storage + TLS 1.3 for syncs
- GDPR/CCPA compliant with explicit data minimization
- One-tap "Right to Erasure"

### 7. all the words are encripted
- with that nobody will extract the word list from the application. that is curicial because preparing the word list is the hard part of that application and word list is the monetery value of the application.

---

## FEATURE OVERVIEW

### Phase 1 (MVP - Weeks 1–12)

| Feature | Priority | Status | User Stories |
|---------|----------|--------|--------------|
| User Authentication (Email + SSO) | P0 | — | WL-001 to WL-003 |
| Onboarding Flow (L1/L2 Selection, Curfew) | P0 | — | WL-010 to WL-015 |
| Study Session (Flashcard Loop) | P0 | — | WL-050 to WL-075 |
| Spaced Repetition Engine (SM-2) | P0 | — | WL-080 to WL-090 |
| The Vault (Mastered Words Archive) | P0 | — | WL-100 to WL-110 |
| Curfew + Ash Protocol | P0 | — | WL-120 to WL-130 |
| Multi-Language Card System | P0 | — | WL-140 to WL-155 |
| Local Sync (SQLite + SQLCipher) | P0 | — | WL-160 to WL-170 |
| Subscription Paywall (Monthly + 6-Month) | P0 | — | WL-200 to WL-210 |
| Basic Settings (Language, Curfew, Drip) | P1 | — | WL-300 to WL-310 |

### Phase 2 (Post-MVP - Weeks 13–24)

| Feature | Priority | Status | Description |
|---------|----------|--------|-------------|
| Global Directory (Search & Manual Injection) | P1 | — | Full-text search across all active languages + manual word injection |
| Peer Mnemonics (Endorsements) | P1 | — | User-submitted memory hacks with quality control |
| Intelligence Reports (Export/LinkedIn) | P1 | — | Automated milestone-triggered proficiency reports |
| Vault Audit (Re-validation Drills) | P2 | — | Quarterly review of archived words |
| Advanced Cloze-Deletion Mode | P2 | — | Context-aware word removal from sentences |
| Rapid Recognition Drills | P2 | — | High-speed flashcard mode for reflex building |
| Custom Deck Creation | P2 | — | Users upload their own CSV vocabularies |
| Dark Mode (Deep Navy) | P2 | — | Night-optimized UI theme |
| Educator Dashboard (B2B) | P3 | — | Class management, progress tracking for professors |
| Corporate Admin Portal | P3 | — | LMS integration, SCIM provisioning, Okta SSO |

---

## TECHNICAL ARCHITECTURE & STACK

### Frontend (Client)

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| **Language** | Dart | Type-safe, compiled to native code for both iOS/Android |
| **Framework** | Flutter 3.x | Pixel-perfect UI rendering, 8px grid precision, strong animation support |
| **State Management** | Riverpod | Testable, modular, supports providers + families for language-specific state |
| **Local Storage** | SQLite + SQLCipher | AES-256 encryption, offline support, fast queries |
| **HTTP Client** | Dio | Retry logic, interceptors for JWT token refresh |
| **Serialization** | Freezed + JSON Serializable | Type-safe code generation, reduces boilerplate |

### Backend (Server)

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| **Database** | Supabase (PostgreSQL) | Managed service, built-in Auth, Row-Level Security (RLS) |
| **Auth** | Supabase Auth (JWT) | SSO support (Google, Apple, Okta), secure token management |
| **Real-Time Sync** | Supabase Realtime + Custom Sync Protocol | Handles conflict resolution (LWW), efficient bandwidth |
| **Edge Functions** | Supabase Edge Functions (Deno) | Server-side Curfew logic, NTP time verification, Ash Protocol |
| **Storage** | Supabase Storage (S3-compatible) | Media assets (audio, illustrations) with CDN |
| **Analytics** | Plausible Analytics (privacy-first) | Anonymized telemetry, no user tracking |

### Infrastructure

| Component | Specification | Notes |
|-----------|---------------|-------|
| **Deployment** | Vercel + Supabase | Auto-scaling, global CDN, zero-downtime deploys |
| **API Protocol** | GraphQL + REST | GraphQL for complex queries (SRS state), REST for simple CRUD |
| **Time Verification** | Cloudflare Time API (NTP) | Prevents local time manipulation for Ash Protocol |
| **Backup & DR** | Automated daily snapshots | Redundant storage in separate data centers |
| **Monitoring** | Sentry + LogRocket (anonymized) | Error tracking, session replay (no PII) |

### Third-Party Integrations

| Service | Purpose | Data Handled |
|---------|---------|--------------|
| **Apple App Store** | iOS distribution + IAP | App metadata, subscription receipts |
| **Google Play Store** | Android distribution + IAP | App metadata, subscription receipts |
| **LinkedIn OAuth** | Professional credential export | User email + name (user-initiated share) |
| **Okta / Azure AD** | Enterprise SSO (Phase 2) | Email + org identity (B2B only) |

---

## DATA MODELS & DATABASE SCHEMA

### User & Authentication

```sql
-- users (Supabase Auth managed)
CREATE TABLE users (
  id UUID PRIMARY KEY (FROM auth.users),
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  base_language VARCHAR(5) NOT NULL, -- e.g., 'en', 'tr', 'fr'
  target_languages VARCHAR(5)[] NOT NULL, -- e.g., ['de', 'it', 'es']
  daily_curfew_utc TIME NOT NULL, -- e.g., 22:00
  daily_drip_count INT DEFAULT 20,
  subscription_tier VARCHAR(20), -- 'free', 'monthly', 'sixmonth'
  streak_count INT DEFAULT 0,
  last_session_date DATE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  is_active BOOLEAN DEFAULT true
);
```

### Vocabulary & Knowledge Base

```sql
-- master_vocabulary (Master Lexicon - sourced from CSVs)
CREATE TABLE master_vocabulary (
  id BIGSERIAL PRIMARY KEY,
  asset_id VARCHAR(20) UNIQUE NOT NULL, -- e.g., 'EN-DE-A2-001'
  cefr_level VARCHAR(2) NOT NULL, -- A1, A2, B1, B2, C1, C2
  category VARCHAR(50), -- e.g., 'work', 'travel', 'daily_life'
  created_at TIMESTAMP
);

-- language_variants (Translations across all 6 languages)
CREATE TABLE language_variants (
  id BIGSERIAL PRIMARY KEY,
  vocabulary_id BIGINT REFERENCES master_vocabulary(id),
  language_code VARCHAR(5) NOT NULL, -- 'en', 'de', 'fr', 'es', 'it', 'tr'
  word TEXT NOT NULL,
  pronunciation TEXT, -- IPA or phonetic spelling
  part_of_speech VARCHAR(20), -- noun, verb, adjective, etc.
  example_sentence TEXT NOT NULL,
  example_translation TEXT NOT NULL,
  image_url TEXT, -- Ligne Claire illustration
  audio_url TEXT, -- TTS-generated or recorded
  created_at TIMESTAMP,
  UNIQUE(vocabulary_id, language_code)
);
```

### User Learning Progress

```sql
-- active_batch (200-word working set per user per language)
CREATE TABLE active_batch (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  vocabulary_id BIGINT REFERENCES master_vocabulary(id),
  language_pair VARCHAR(11), -- e.g., 'en-de', 'en-fr'
  
  -- SRS SM-2 state
  ease_factor DECIMAL(3,2) DEFAULT 2.5, -- Range: 1.3 to 2.5
  interval_days INT DEFAULT 1,
  next_review_date DATE,
  repetitions INT DEFAULT 0,
  
  -- Learning state
  last_reviewed_at TIMESTAMP,
  difficulty_history VARCHAR(20), -- e.g., 'HARD,FAMILIAR,OK'
  
  -- Metadata
  added_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  position_in_batch INT, -- Order in the 200-word batch
  
  UNIQUE(user_id, vocabulary_id, language_pair),
  CONSTRAINT batch_size_per_pair CHECK (
    -- Enforced via trigger; max 200 per (user, language_pair)
  )
);

-- vault (Mastered words - long-term archive)
CREATE TABLE vault (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  vocabulary_id BIGINT REFERENCES master_vocabulary(id),
  language_pair VARCHAR(11),
  
  -- Archive metadata
  mastered_at TIMESTAMP DEFAULT NOW(),
  vault_entry_ease_factor DECIMAL(3,2), -- Final ease when archived
  times_reviewed INT,
  
  -- Re-validation schedule
  last_audit_date TIMESTAMP,
  next_audit_date TIMESTAMP,
  audit_status VARCHAR(20) -- 'pending', 'passed', 'failed'
);
```

### Study Sessions & History

```sql
-- study_sessions (Record of each study session)
CREATE TABLE study_sessions (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  language_pair VARCHAR(11),
  session_start_time TIMESTAMP DEFAULT NOW(),
  session_end_time TIMESTAMP,
  words_reviewed INT DEFAULT 0,
  words_mastered INT DEFAULT 0,
  total_duration_seconds INT,
  is_offline_completed BOOLEAN DEFAULT false,
  offline_proof_signature TEXT, -- Cryptographic signature
  offline_completion_timestamp TIMESTAMP,
  
  created_at TIMESTAMP
);

-- review_log (Detailed card-by-card review history)
CREATE TABLE review_log (
  id BIGSERIAL PRIMARY KEY,
  session_id BIGINT REFERENCES study_sessions(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  vocabulary_id BIGINT REFERENCES master_vocabulary(id),
  language_pair VARCHAR(11),
  
  difficulty_rating VARCHAR(20), -- 'hard', 'familiar', 'ok', 'easy'
  time_to_answer_seconds INT,
  
  -- State snapshot (for SRS recalculation)
  ease_before DECIMAL(3,2),
  interval_before INT,
  ease_after DECIMAL(3,2),
  interval_after INT,
  
  created_at TIMESTAMP
);
```

### Subscription & Monetization

```sql
-- subscriptions
CREATE TABLE subscriptions (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  app_store_subscription_id TEXT UNIQUE, -- Apple: bundle_id + token
  play_store_subscription_id TEXT UNIQUE, -- Google: SKU + order ID
  tier VARCHAR(20) NOT NULL, -- 'monthly', 'sixmonth'
  status VARCHAR(20) DEFAULT 'active', -- 'active', 'expired', 'cancelled'
  start_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  renewal_date DATE,
  receipt_data TEXT, -- Encrypted receipt for Apple/Google verification
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### User Settings & Preferences

```sql
-- user_settings
CREATE TABLE user_settings (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  
  -- Display
  theme VARCHAR(20) DEFAULT 'light', -- 'light', 'dark'
  ui_language VARCHAR(5) DEFAULT 'en',
  font_size VARCHAR(20) DEFAULT 'medium', -- 'small', 'medium', 'large'
  
  -- Learning
  auto_play_audio BOOLEAN DEFAULT false,
  show_mnemonic_hints BOOLEAN DEFAULT true,
  cloze_difficulty VARCHAR(20) DEFAULT 'medium',
  
  -- Notifications
  streak_reminder BOOLEAN DEFAULT false,
  curfew_warning_minutes INT DEFAULT 60,
  
  -- Privacy
  is_profile_public BOOLEAN DEFAULT false,
  share_mnemonics BOOLEAN DEFAULT true,
  
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### Mnemonics & Peer Insights (Phase 2)

```sql
-- user_mnemonics
CREATE TABLE user_mnemonics (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  vocabulary_id BIGINT REFERENCES master_vocabulary(id),
  language_pair VARCHAR(11),
  mnemonic_text TEXT NOT NULL,
  created_at TIMESTAMP,
  approval_status VARCHAR(20) DEFAULT 'pending' -- 'pending', 'approved', 'rejected'
);

-- mnemonic_endorsements
CREATE TABLE mnemonic_endorsements (
  id BIGSERIAL PRIMARY KEY,
  mnemonic_id BIGINT REFERENCES user_mnemonics(id) ON DELETE CASCADE,
  endorser_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP,
  UNIQUE(mnemonic_id, endorser_user_id) -- One endorsement per user per mnemonic
);
```

---

## MODULAR LANGUAGE SYSTEM

### Design Philosophy: Add Language in 3 Steps

The system is architected to allow new language addition with **zero code changes**. Here's how:

### Step 1: Define Language in Configuration

**File:** `assets/config/languages.yaml`

```yaml
languages:
  - code: "en"
    name: "English"
    name_native: "English"
    cefr_supported: [A1, A2, B1, B2, C1, C2]
    script: "latin"
    rtl: false
    locale: "en_US"
    
  - code: "de"
    name: "German"
    name_native: "Deutsch"
    cefr_supported: [A1, A2, B1, B2, C1, C2]
    script: "latin"
    rtl: false
    locale: "de_DE"
    
  - code: "fr"
    name: "French"
    name_native: "Français"
    cefr_supported: [A1, A2, B1, B2, C1, C2]
    script: "latin"
    rtl: false
    locale: "fr_FR"
    
  - code: "es"
    name: "Spanish"
    name_native: "Español"
    cefr_supported: [A1, A2, B1, B2, C1, C2]
    script: "latin"
    rtl: false
    locale: "es_ES"
    
  - code: "it"
    name: "Italian"
    name_native: "Italiano"
    cefr_supported: [A1, A2, B1, B2, C1, C2]
    script: "latin"
    rtl: false
    locale: "it_IT"
    
  - code: "tr"
    name: "Turkish"
    name_native: "Türkçe"
    cefr_supported: [A1, A2, B1, B2, C1, C2]
    script: "latin"
    rtl: false
    locale: "tr_TR"
```

### Step 2: Prepare Language Data CSV

**File:** `data/vocabularies/[language-pair]/[cefr-level].csv`

Example: `data/vocabularies/en-pt/a1.csv`

```csv
word,pronunciation,part_of_speech,example_sentence,example_translation,image_id,audio_id
maçã,mə-ˈsã,noun,"A maçã é vermelha.","The apple is red.",pt-apple-001,pt-apple-audio-001
gato,ˈɡa-tu,noun,"O gato é preto.","The cat is black.",pt-cat-001,pt-cat-audio-001
```

**Validation:** Auto-run validation script (Python):

```bash
python scripts/validate_language_csv.py \
  --language-pair en-pt \
  --cefr-level a1 \
  --config assets/config/languages.yaml
```

**Checks:**
- UTF-8 encoding for diacritics (Portuguese: ã, õ, ç)
- Word exists in example sentence (regex match)
- ID uniqueness across all CEFR levels
- No duplicate translations
- Image/audio IDs reference actual assets

### Step 3: Database Migration & Deployment

**Migration Script** (SQL + custom Dart code):

```sql
-- Auto-generated for new language pair
INSERT INTO master_vocabulary (asset_id, cefr_level, category, language_pair)
VALUES 
  ('EN-PT-A1-0001', 'A1', 'food', 'en-pt'),
  ('EN-PT-A1-0002', 'A1', 'animals', 'en-pt'),
  ...
  
INSERT INTO language_variants (vocabulary_id, language_code, word, pronunciation, part_of_speech, example_sentence, example_translation, image_url, audio_url)
VALUES 
  (1001, 'pt', 'maçã', 'mə-ˈsã', 'noun', 'A maçã é vermelha.', 'The apple is red.', 'https://cdn.wordlearn.io/pt-apple-001.svg', 'https://cdn.wordlearn.io/pt-apple-audio-001.mp3'),
  ...
```

**Deployment:**
1. Validation passes → Auto-generated migration created
2. Migration tested in staging environment (automated)
3. One-click deploy to production
4. App updates language list on next sync
5. Users can select new language in Settings

### Why This Scales

- **Single source of truth:** `languages.yaml` + CSV
- **No code changes:** Validation, migration, and UI all auto-adapt
- **Data integrity:** Automated checks prevent corruption
- **Rollback-safe:** Each language pair is isolated; removing a language doesn't affect others
- **Timeline:** New language can go live in < 1 hour

---

## DESIGN SYSTEM & VISUAL LANGUAGE

### Design Philosophy: Swiss Modernist + Ligne Clare

The visual language is rooted in:
- **Swiss International Style:** Grid-based, sans-serif, precision
- **Ligne Clare (Clear Line):** Clean line art illustrations (no shading)
- **Minimalism:** Every element must earn its place
- **Accessibility:** High contrast, readable typography, semantic colors

### Color Palette

```dart
class WordLearnColors {
  // Primary brand colors
  static const Color primaryTeal = Color(0xFF008B8B); // Teal accent
  static const Color lightTeal = Color(0xFFE0F2F1); // Light teal background
  
  // Neutral palette
  static const Color paperWhite = Color(0xFFFAFAFA); // Off-white background
  static const Color darkGray = Color(0xFF212121); // Text primary
  static const Color mediumGray = Color(0xFF757575); // Text secondary
  static const Color lightGray = Color(0xFFEBEBEB); // Dividers
  
  // Functional colors
  static const Color success = Color(0xFF2E7D32); // Mastered words (deep green)
  static const Color warning = Color(0xFFF57C00); // Pending review (orange)
  static const Color error = Color(0xFFC62828); // Failed review (deep red)
  static const Color info = Color(0xFF0288D1); // Info messages (blue)
  
  // Ice State (Curfew palette shift)
  static const Color iceTeal = Color(0xFF00BCD4); // Cyan-teal (cold)
  static const Color iceBackground = Color(0xFFE0F7FA); // Very light cyan
  
  // Deep Navy (Night mode)
  static const Color deepNavy = Color(0xFF0D1B2A); // Dark blue background
  static const Color navyText = Color(0xFFF0F0F0); // Light text on dark
}
```

### Typography

```dart
class WordLearnTypography {
  // Display (Headlines)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Futura', // or 'Helvetica Neue'
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Futura',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );
  
  // Body (Primary reading)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Helvetica Neue', // or system default
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Helvetica Neue',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );
  
  // Label (Buttons, tags)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Helvetica Neue',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
  );
}
```

### Spacing & Grid System

- **Base unit:** 8px
- **Grid:** 8px vertical + horizontal rhythm
- **Common spacing:** 8, 16, 24, 32, 48, 64px

```dart
class WordLearnSpacing {
  static const double xs = 4; // 0.5x
  static const double sm = 8; // 1x (base)
  static const double md = 16; // 2x
  static const double lg = 24; // 3x
  static const double xl = 32; // 4x
  static const double xxl = 48; // 6x
}
```

### Component Library

#### 1. Button (Primary)

```
Design:
- Background: Teal (#008B8B)
- Text: White, all caps
- Padding: 16px (vertical) × 24px (horizontal)
- Border radius: 2px (sharp corner, not rounded)
- Typography: Label Large (12px, weight 600)
- Hover state: 80% opacity or darker teal
- Disabled: Gray (#EBEBEB) with gray text

Example usage:
"START SESSION" button with 3px black outline (borders)
```

#### 2. Flashcard

```
Design:
- Background: Paper white (#FAFAFA)
- Border: 1px light gray (#EBEBEB)
- Shadow: 0px 2px 8px rgba(0,0,0,0.08)
- Inner padding: 24px
- Word size: 32px, Futura bold
- Translation size: 16px, body medium
- Image: 180×180px, Ligne Claire style
- Border radius: 4px

States:
- Default: Light gray border
- Revealed: Teal border (accent)
- Mastered: Green (#2E7D32) border
- Failed: Red (#C62828) border
```

#### 3. Difficulty Rating (4-button group)

```
Design:
- 4 buttons in horizontal row
- Labels: "HARD", "FAMILIAR", "OK", "EASY"
- Unselected: Light gray border, dark text
- Selected: Teal background, white text
- Spacing: 8px between buttons
- Button dimensions: 64px × 48px (minimum touch target: 44px)
```

### Visual Language: Ligne Claire Illustrations

All vocabulary cards include **hand-drawn, clean-line illustrations**:
- **Style:** Ligne Claire (clear line art, no shading)
- **Color:** Monochrome (black lines, optional single accent color)
- **Dimensions:** 180×180px (fits in card comfortably)
- **Grid alignment:** Always aligned to 8px grid

Example: Word "cat" includes simple, clear cat illustration (2-3 lines).

### UI States & Transitions

#### Ice State (Curfew approaching)

When 60 minutes before Curfew:
- **Palette shift:** Teal → Cyan-ice (#00BCD4)
- **Background shift:** Paper white → Light cyan (#E0F7FA)
- **Typography:** No change (readability priority)
- **Visual effect:** Subtle "cold" tone without distraction

**Transition:** Gradual fade (300ms) using Flutter `ColorTween`

#### Deep Navy Mode (Night learning)

User can enable "Night Mode" in Settings:
- **Background:** Deep navy (#0D1B2A)
- **Text:** Light gray (#F0F0F0)
- **Accent colors:** Remain teal (slightly desaturated)
- **Illustration:** Invert to light lines on dark (no solid fills)

### Ligne Claire Mascot: "The Chancellor"

A minimalist, professional character that appears in:
- Settings screen (top-right corner)
- Session completion screen
- Streak milestone celebrations
- Error states (with brief, professional messages)

**Design:**
- Monochrome line drawing
- Briefcase, professional attire
- Subtle animations (no distracting loops)
- Optional speech bubble with brief feedback

---

## USER FLOWS & INTERACTIONS

### Flow 1: First-Time Onboarding

```
Screen 1: Welcome
├─ Text: "Scholar, welcome to WordLearn."
├─ Text: "A precision tool for vocabulary mastery."
├─ Button: "GET STARTED"

Screen 2: Authentication
├─ Email field
├─ "Sign in with Google" / "Sign in with Apple"
├─ New user → Auto-create account

Screen 3: Linguistic Mapping
├─ Base Language selector (default: English)
├─ Target Languages (multi-select, 1–6)
├─ CEFR Level selector per language (A1–C2)
├─ Button: "NEXT"

Screen 4: Curfew Setup
├─ Time picker (default: 22:00)
├─ Text: "Your daily deadline. Consistency is earned."
├─ Warning: "Missing your Curfew burns your streak to Ash."
├─ Button: "I ACCEPT"

Screen 5: Daily Drip Configuration
├─ Slider (5–40 words/day, default: 20)
├─ Text: "New words to learn each day."
├─ Button: "START LEARNING"

Screen 6: Paywall
├─ Free tier: Limited to 1 language
├─ Monthly: $9.99/month, unlimited languages
├─ Six-Month: $49.99 (6-month commitment)
├─ Button: "SUBSCRIBE" or "TRY FREE"
```

### Flow 2: Daily Study Session

```
Session initialization
├─ App calculates daily review count based on SRS
├─ Display: "X words due for review, Y new words today"
├─ Button: "START SESSION"

Flashcard loop
├─ Card front (word in target language)
├─ User thinks of answer (taps to reveal)
├─ Card back (translation, example, image)
├─ User rates difficulty: HARD / FAMILIAR / OK / EASY
├─ App updates SRS state (ease_factor, interval)
├─ Next card appears (randomized)

Session completion
├─ Summary: "Y words reviewed, Z mastered"
├─ Streak status: "Streak: 42 days"
├─ Curfew status: "Complete by 22:00"
├─ Options: "VIEW STATS" or "CLOSE"

Curfew approach (< 60 min)
├─ UI shifts to Ice State (cyan palette)
├─ Banner: "X minutes until Curfew"
├─ If missed at 23:59:59 → Ash Protocol triggered
  ├─ Streak resets to 0
  ├─ Animation: Streak counter "burns" to ash
  ├─ Push notification (optional): "Streak lost."
```

### Flow 3: Vault (Mastered Words)

```
Access Vault
├─ Tab in bottom navigation
├─ Display: All archived words (sorted by mastery date)
├─ Filter options: Language, mastery date range

View word details
├─ Word + translation + example
├─ "Mastered on: [DATE]"
├─ Next audit: [DATE] (quarterly)
├─ Button: "RE-REVIEW" (optional early re-validation)

Quarterly Vault Audit
├─ Auto-triggered at 3-month, 6-month, 1-year intervals
├─ User reviews 5–10 random Vault words
├─ If failed during audit → Move back to Active Batch
├─ If passed → Reset audit timer to 3 months
```

### Flow 4: Multi-Language Card Management

```
Languages tab (new bottom-nav tab)
├─ List of enrolled languages (de, fr, it, es, tr)
├─ Per-language stats:
   ├─ Words in Active Batch
   ├─ Words in Vault
   ├─ Days streak
   ├─ CEFR level

Language selection for session
├─ User can pick specific language OR
├─ "MULTI-LANGUAGE" session:
   ├─ Cards randomly drawn from all enrolled languages
   ├─ Each card displays source language (small badge)
   ├─ Difficulty rating per language

Add new language
├─ Button: "+ ADD LANGUAGE"
├─ Language selector + CEFR level
├─ Requires subscription to add 2nd+ language
├─ Confirmation: "New language initialized"
```

---

## CORE MODULES & FEATURES (DETAILED)

### Module 1: The Knowledge Base (Master Lexicon)

**Purpose:** Central repository of all vocabulary across all languages and CEFR levels.

**Responsibilities:**
- Store 5,000–20,000 words per language pair
- Organize by CEFR level (A1–C2) + category (work, travel, etc.)
- Provide fast lookup by word, definition, or example
- Support full-text search with fuzzy matching

**Key Features:**

1. **CEFR Classification**
   - Every word tagged: A1, A2, B1, B2, C1, or C2
   - Ensures curriculum relevance and progression
   - Aligned to official CEFR vocabulary lists

2. **Language Variants**
   - One vocabulary concept → 6 language translations
   - Each variant includes:
     - Word (UTF-8 with diacritics)
     - Pronunciation (IPA or phonetic)
     - Part of speech (noun, verb, adjective, etc.)
     - Example sentence (authentic, published)
     - Example translation
     - Ligne Claire illustration (SVG)
     - Audio pronunciation (TTS or recorded)

3. **Content Validation Pipeline**
   - Automated checks:
     - UTF-8 integrity (diacritics render correctly)
     - Word exists in example sentence (regex validation)
     - ID uniqueness across all CEFR levels
     - No duplicate translations in same language
     - Audio file size < 500KB
     - Image file size < 200KB
   - Manual QA: Native speakers review example sentences for authenticity

### Module 2: The Spaced Repetition Engine (SRS)

**Purpose:** Optimize review scheduling using the SM-2 algorithm to maximize retention.

**Algorithm: SM-2 (Simplified Major System)**

```
When user rates difficulty:

IF difficulty == "Easy" (4):
  ease_factor = max(1.3, ease_factor + 0.1)
  interval = interval * ease_factor
  repetitions += 1

IF difficulty == "OK" (3):
  ease_factor = ease_factor
  interval = interval * ease_factor
  repetitions += 1

IF difficulty == "Familiar" (2):
  ease_factor = max(1.3, ease_factor - 0.14)
  interval = max(1, interval * ease_factor)
  repetitions += 1

IF difficulty == "Hard" (1):
  ease_factor = max(1.3, ease_factor - 0.2)
  repetitions = 0
  interval = 1 (re-queue for next session)

next_review_date = today + interval
```

**Initial Values:**
- `ease_factor` = 2.5 (neutral)
- `interval` = 1 day (first review)
- `repetitions` = 0

**Outcomes:**
- "Easy" words: Long intervals (30–365 days)
- "OK" words: Medium intervals (3–14 days)
- "Familiar" words: Short intervals (1–7 days)
- "Hard" words: Immediate re-queue (same session or next day)

**Implementation Details:**
- Calculated on-device (Riverpod provider)
- Persisted to SQLite after every card review
- Synced to server (next_review_date used for server-side queue)
- No server-side SRS calculation (user owns their progress)

### Module 3: The Active Batch (200-Word Working Set)

**Purpose:** Limit cognitive load to optimal 200 words per language pair.

**Design Rationale:**
- Prevents overwhelm and context confusion
- Ensures deep learning (not skimming)
- User must graduate words to Vault before adding new ones

**Mechanics:**

1. **Batch Capacity**
   - Hard limit: 200 words per (user, language_pair)
   - If user tries to add 201st word:
     - App shows: "Batch full. Master 1 word to begin learning 1 new word."
     - Button: "VIEW WORDS TO MASTER" (filter to words with high ease_factor)

2. **Daily Drip**
   - New words added daily (user-configurable, default: 20)
   - Timing: On app open after midnight (UTC-based)
   - Randomness: Words randomly selected from next CEFR level
   - Manual injection: User can force specific words via Global Directory (Phase 2)

3. **Batch Composition**
   - New words: 20% of batch (auto-added)
   - Review words: 80% of batch (SRS-driven)
   - Words in Vault-ready state (high ease_factor) have priority for graduation

4. **Position-in-Batch**
   - Tracks sequence: When were words added?
   - Used for: "Oldest word first" sorting in session prep
   - Prevents: All review words clustered (maintains freshness)

### Module 4: The Vault (Long-Term Archive)

**Purpose:** Archive "Mastered" words and re-validate them periodically.

**Criteria for Vault Entry:**
- Word marked "Easy" (difficulty rating 4) at least 2 times
- 7+ days have passed since last review
- ease_factor ≥ 2.0 (high retention confidence)

**Upon Vault Entry:**
- Word removed from Active Batch (frees up slot for new word)
- Streak milestone checked: Every 50 words → Intelligence Report trigger
- User notification: "[Word] mastered! 1 slot freed in Active Batch."

**Vault Re-Validation (Quarterly Audits):**

- **Trigger:** 3 months, 6 months, 1 year after Vault entry
- **Process:**
  1. App selects 5–10 random Vault words
  2. User re-reviews them in a dedicated "Vault Audit" session
  3. If passed (OK or Easy): audit_date resets; word stays in Vault
  4. If failed (Hard or Familiar): word returns to Active Batch

**Benefits:**
- Long-term retention verification
- Prevents "Vault decay" (forgetting archived words)
- Realistic proficiency certification

### Module 5: The Curfew & Ash Protocol (Accountability)

**Purpose:** Foster discipline through boundary-based accountability (no soft streak freezes).

**The Curfew:**
- User-defined daily deadline (e.g., 22:00)
- User must complete daily session by deadline
- Enforced via server-side NTP time verification

**The Ice State (Visual Priming):**
- Triggered 60 minutes before Curfew
- UI palette shifts from warm to cool cyan:
  - Background: Paper white → Light cyan (#E0F7FA)
  - Primary color: Teal → Cyan (#00BCD4)
  - Effect: Subtle psychological signal (no notifications)

**The Ash Protocol (Hard Streak Reset):**
- If user doesn't complete session by 23:59:59 UTC:
  - Streak counter resets to 0
  - Visual feedback: Counter "burns" to ash (animation)
  - No streak freeze; no second chances
  - One-time "Pardon" available every 180 days:
    - Used via Settings → "Invoke Pardon"
    - Condition: Complete double-intensity session next day (2× normal drip)

**Offline Completion (Military-Grade Anti-Cheat):**
- User can complete session offline (e.g., airplane mode)
- Device generates cryptographic proof:
  - Session completion timestamp
  - HMAC signature (device-local secret)
  - Sealed in Secure Enclave (iOS) / Keystore (Android)
- Upon reconnection:
  - Proof sent to server
  - Server validates signature + timestamp
  - If signature valid + timestamp < Curfew → streak preserved
  - Otherwise → Ash Protocol triggered

**Why No Streak Freezes:**
- Freezes incentivize "checking in" without real learning
- Hard resets enforce genuine daily commitment
- Pardon system provides emergency escape (max 2× per year)

### Module 6: Multi-Language Card System

**Purpose:** Enable simultaneous learning of multiple languages without cognitive confusion.

**Design:**

1. **Language-Pair Isolation**
   - Each (user, language_pair) has independent:
     - Active Batch (200 words)
     - Vault
     - Streak counter
     - Review schedule
   - Example: User learning German (en-de) and Italian (en-it)
     - Earn separate streaks for each language
     - No mixing of words in sessions (unless explicitly requested)

2. **Multi-Language Session Mode**
   - Optional: Toggle "MULTI-LANGUAGE MODE" in settings
   - Draws cards from all active languages
   - Each card displays language badge (small label: "GERMAN" or "ITALIAN")
   - User difficulty ratings affect each language's SRS independently

3. **Subscription Tier Restriction**
   - Free tier: 1 language only
   - Monthly/Six-month: Unlimited languages (up to 6)
   - Enforced in Settings: "Add Language" button disabled for free users

4. **UI Management**
   - Bottom navigation: "Languages" tab shows all enrolled languages
   - Per-language stats:
     - Active batch count
     - Vault count
     - Streak
     - CEFR level
   - Quick-switch: Tap language to start single-language session

### Module 7: Local-First Sync & Data Sovereignty

**Purpose:** User owns their progress; server is only backup/cross-device sync.

**Local Storage (Device):**
- SQLite database encrypted with SQLCipher (AES-256)
- Encryption key stored in Hardware Keystore (Android) / Keychain (iOS)
- Contains:
  - User profile (base language, target languages, Curfew, daily drip)
  - Active Batch (current 200 words per language)
  - SRS state (ease_factor, interval, next_review_date)
  - Study session history (reviews, difficulty ratings)

**Cloud Sync (Server):**
- "Ghost Backup" protocol:
  1. Every 6 hours (or on explicit sync): Device serializes progress to JSON
  2. Compress (gzip) + encrypt (AES-256, different key from local)
  3. POST to Supabase (TLS 1.3)
  4. Server stores encrypted backup (user cannot read)
  5. User can restore from any device using backup key

**Cross-Device Conflict Resolution:**
- User studies on iPhone, then iPad
- Last-Write-Wins (LWW) or CRDT strategy:
  - Latest high-quality review wins (quality = longer study time + higher accuracy)
  - SRS intervals merged intelligently (no duplicate reviews)
  - Example: iPhone review + iPad review same day → Merge as single review

**Offline Study:**
- All study sessions work offline (no internet required)
- Session completion signed cryptographically
- Upon reconnection → Sync triggered, signature verified

**Data Deletion (GDPR Compliance):**
- User → Settings → "Delete Account"
- Immediate local deletion
- Server-side deletion (Supabase) within 30 days (scheduled)
- Backup data destroyed (no recovery option)

---

## API SPECIFICATIONS

### Authentication Endpoints

#### 1. Sign In / Sign Up

```
POST /auth/signup
Content-Type: application/json

{
  "email": "scholar@example.com",
  "password": "SecurePassword123!",
  "base_language": "en",
  "target_languages": ["de", "fr"],
  "display_name": "Dr. Scholar"
}

Response (201):
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "refresh_token_123...",
  "expires_in": 3600,
  "user": {
    "id": "uuid-1234",
    "email": "scholar@example.com",
    "base_language": "en"
  }
}
```

#### 2. OAuth Sign In (Google/Apple)

```
POST /auth/oauth/callback
Content-Type: application/json

{
  "provider": "google",
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEifQ...",
  "code": "4/0AWtgzBrk1234..."
}

Response (200):
{
  "access_token": "...",
  "refresh_token": "...",
  "is_new_user": true
}
```

### Vocabulary Endpoints

#### 3. Get Master Vocabulary (with filtering)

```
GET /api/v1/vocabulary?language_pair=en-de&cefr_level=B1&limit=100&offset=0
Authorization: Bearer {access_token}

Response (200):
{
  "data": [
    {
      "id": "EN-DE-B1-0001",
      "asset_id": "EN-DE-B1-0001",
      "language_pair": "en-de",
      "cefr_level": "B1",
      "category": "work",
      "variants": {
        "en": {
          "word": "negotiate",
          "pronunciation": "nɪ-ˈɡoʊ-ʃi-eɪt",
          "part_of_speech": "verb",
          "example_sentence": "We must negotiate the contract terms.",
          "example_translation": "Wir müssen die Vertragsbedingungen aushandeln.",
          "image_url": "https://cdn.wordlearn.io/en-negotiate-001.svg",
          "audio_url": "https://cdn.wordlearn.io/en-negotiate-001.mp3"
        },
        "de": {
          "word": "aushandeln",
          "pronunciation": "ˈaʊs-ˌhɑn-dəln",
          "part_of_speech": "verb",
          "example_sentence": "Wir müssen die Vertragsbedingungen aushandeln.",
          "example_translation": "We must negotiate the contract terms.",
          "image_url": "https://cdn.wordlearn.io/de-negotiate-001.svg",
          "audio_url": "https://cdn.wordlearn.io/de-negotiate-001.mp3"
        }
      }
    }
  ],
  "meta": {
    "total_count": 2500,
    "limit": 100,
    "offset": 0
  }
}
```

### Learning Progress Endpoints

#### 4. Get Active Batch

```
GET /api/v1/user/active-batch?language_pair=en-de
Authorization: Bearer {access_token}

Response (200):
{
  "data": {
    "language_pair": "en-de",
    "batch_size": 156,
    "batch_capacity": 200,
    "words": [
      {
        "id": "batch-item-001",
        "vocabulary_id": "EN-DE-B1-0001",
        "word": "negotiate",
        "translation": "aushandeln",
        "ease_factor": 2.3,
        "interval_days": 7,
        "next_review_date": "2026-03-09",
        "repetitions": 3,
        "last_reviewed_at": "2026-03-02T14:30:00Z",
        "difficulty_history": "HARD,FAMILIAR,OK"
      }
    ]
  }
}
```

#### 5. Submit Review (Card Difficulty Rating)

```
POST /api/v1/user/reviews
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "vocabulary_id": "EN-DE-B1-0001",
  "language_pair": "en-de",
  "difficulty_rating": "ok", // hard, familiar, ok, easy
  "time_to_answer_seconds": 3,
  "session_id": "session-uuid-001",
  "timestamp": "2026-03-02T14:35:00Z"
}

Response (201):
{
  "data": {
    "review_id": "review-123",
    "new_ease_factor": 2.4,
    "new_interval_days": 8,
    "next_review_date": "2026-03-10",
    "vocabulary_moved_to_vault": false
  }
}
```

#### 6. Complete Study Session

```
POST /api/v1/user/sessions/complete
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "session_id": "session-uuid-001",
  "language_pair": "en-de",
  "words_reviewed": 25,
  "words_mastered": 2,
  "total_duration_seconds": 1200,
  "is_offline_completed": false,
  "reviews": [
    {
      "vocabulary_id": "EN-DE-B1-0001",
      "difficulty_rating": "ok"
    }
  ]
}

Response (201):
{
  "data": {
    "session_completed": true,
    "streak_preserved": true,
    "streak_count": 42,
    "milestone_reached": false,
    "next_drip_date": "2026-03-03"
  }
}
```

### Subscription Endpoints

#### 7. Get Subscription Status

```
GET /api/v1/user/subscription
Authorization: Bearer {access_token}

Response (200):
{
  "data": {
    "tier": "monthly",
    "status": "active",
    "start_date": "2026-01-02",
    "expiry_date": "2026-04-02",
    "renewal_date": "2026-04-02",
    "is_auto_renewing": true,
    "languages_allowed": 6,
    "languages_used": 2
  }
}
```

#### 8. Verify & Process App Store Receipt

```
POST /api/v1/subscriptions/verify-receipt
Content-Type: application/json

{
  "receipt_data": "MIIFXAYJKoZIhvcNAQcCoIIFTTCCBUkCAQExDzANBglghkgBZQEEAwIFADCC...",
  "platform": "ios", // ios or android
  "package_name": "com.wordlearn.app"
}

Response (201):
{
  "data": {
    "subscription_created": true,
    "tier": "monthly",
    "expiry_date": "2026-04-02"
  }
}
```

### Settings & User Profile Endpoints

#### 9. Update User Settings

```
PATCH /api/v1/user/settings
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "daily_curfew_utc": "22:00",
  "daily_drip_count": 25,
  "theme": "light", // light or dark
  "ui_language": "en",
  "auto_play_audio": true
}

Response (200):
{
  "data": {
    "settings_updated": true
  }
}
```

---

## MONETIZATION & SUBSCRIPTION TIERS

### Pricing Model

| Tier | Price | Billing | Languages | Features |
|------|-------|---------|-----------|----------|
| **Free** | $0 | Ongoing | 1 | Basic study loop, 50-word Active Batch limit |
| **Monthly** | $9.99/month | Monthly auto-renewal | 6 | Full features, unlimited languages |
| **Six-Month** | $49.99 | One-time, 6-month access | 6 | Full features, unlimited languages, 17% discount |

### Free Tier Limitations

- **Single language:** Can only enroll in 1 language
- **Active Batch cap:** Max 50 words (vs. 200 for paid)
- **Vault:** Accessible but limited to 25 mastered words
- **No Intelligence Reports:** Cannot export proficiency certificates
- **No Mnemonics:** Cannot view/submit memory hacks
- **Ad-free:** No ads (privacy-first principle)

### Subscription Paywall Flow

**Trigger Points:**
1. After onboarding (if user selects 2+ languages)
2. Settings → "Add Language" (if user tries to add 2nd language)
3. Active Batch full → "Upgrade to add more languages"
4. On periodic "benefit reminder" (every 30 days for free users)

**Paywall UI:**
- Prominent tier comparison table
- Feature highlights per tier
- "SUBSCRIBE" button (primary action)
- "TRY FREE" button (secondary)
- Links: "Privacy Policy", "Terms of Service"

### Revenue Sharing & Platform Fees

**App Store (iOS):**
- Apple takes 30% commission
- WordLearn retains 70%
- Revenue per user:
  - Monthly: $9.99 → WordLearn gets $6.99/user/month
  - Six-month: $49.99 → WordLearn gets $34.99/user (one-time)

**Google Play (Android):**
- Google takes 30% commission
- WordLearn retains 70%
- Same pricing as iOS (no regional variation initially)

### Payment Processing

- **In-App Purchase (IAP) only**
  - Apple in-app purchases handled via App Store server
  - Google in-app purchases handled via Play Store server
  - Server-side receipt validation via Supabase Edge Functions
- **No external payment processors** (Stripe, etc.) to simplify compliance

### Subscription Lifecycle

**Auto-Renewal:**
- Monthly: Renews on same date each month
- Six-month: Renews on 6-month anniversary
- User can cancel any time (via Settings or App Store settings)

**Expiry & Downgrade:**
- On expiry date:
  - Active Batch cap reverts to 50 words
  - Vault remains accessible (read-only)
  - User notified: "Subscription expired. Upgrade to continue."
  - "Resubscribe" button in Settings

**Churn Prevention:**
- Win-back offer (Phase 2): Email users 2 weeks after expiry
- Offer: 50% off one-month renewal
- Goal: Retain power users with affordable re-entry point

---

## SECURITY, PRIVACY & COMPLIANCE

### Data Classification

| Data | Classification | Storage | Encryption |
|------|-----------------|---------|------------|
| User Email | **Sensitive** | Server + Local | AES-256 (local), TLS 1.3 (network) |
| Study Progress (SRS) | **Personal** | Local-first, cloud backup | SQLCipher + TLS 1.3 |
| Vocabulary (Public) | **Public** | Server + Local | None (standard HTTPS) |
| Subscription Receipt | **Sensitive** | Server | AES-256 at rest |
| Biometric Data | **Not collected** | N/A | N/A |

### Encryption Standards

**Local Encryption (Device):**
- **Algorithm:** SQLCipher with AES-256
- **Key derivation:** PBKDF2 (user password + device salt)
- **Hardware backing:** iOS Keychain, Android Keystore
- **Rotation:** Never (user-controlled; can reset via app reinstall)

**Network Encryption:**
- **Protocol:** TLS 1.3
- **Certificate pinning:** Enabled (sha256/SPKI pins)
- **Perfect forward secrecy:** Yes (ECDHE key exchange)

**Backup Encryption (Server-to-Device Restore):**
- **Algorithm:** AES-256-GCM
- **Key:** Derived from user password + timestamp
- **Rotation:** Every 30 days (automatic)

### Authentication & Session Management

**JWT Token Lifecycle:**
- **Access token:** 1 hour expiry
- **Refresh token:** 30 days expiry
- **Token format:** RS256 (server-signed, not user-signed)
- **Revocation:** Logout invalidates refresh token on server

**Biometric Authentication (Optional - Phase 2):**
- **iOS:** Face ID / Touch ID
- **Android:** Biometric API (fingerprint)
- **Purpose:** Unlock app (not for login)
- **Key storage:** Uses device Keychain/Keystore (separate from password)

**Passwordless Auth (Future):**
- WebAuthn support (FIDO2 keys)
- Consider passive approach (magic links via email)

### Privacy & Data Minimization

**Collected Data:**
- Email address (for authentication + communication)
- Display name (optional, user-provided)
- Learning progress (study history, SRS state)
- Subscription status (for entitlements)
- Device info: Model, OS version (anonymous error reporting)

**NOT Collected:**
- Location data
- Device contacts
- Device photos
- Behavioral tracking (no event logging for profiling)
- Third-party app data

**User Control:**
- Settings → Privacy
  - "Share Learning Data" toggle (for peer mnemonics)
  - "Allow Crash Reports" toggle (for error monitoring)
- Full data export: Download all personal data as JSON (GDPR requirement)
- Right to Erasure: Delete account + all associated data

### Compliance & Regulations

**GDPR (EU - Core Focus):**
- Data Processing Agreement (DPA) in place
- Legal basis: Legitimate interest (user consent via ToS)
- Data retention: Minimum necessary (delete on request)
- Subprocessors: Supabase, Vercel (documented)
- Data transfer: Standard Contractual Clauses (SCCs) for non-EU servers

**CCPA (California):**
- Privacy Policy disclosure: California-specific language
- User rights: Delete, access, opt-out
- No data sale: WordLearn does not sell user data
- Accessibility: Privacy controls in app + website

**COPPA (Children's Online Privacy):**
- NOT compliant (intentionally for 13+)
- Age gate: "By signing up, you confirm you are 13+"
- No collection from < 13 year-olds

### Security Testing & Audit

**Phase 1 (Pre-Launch):**
- [ ] Penetration testing: Third-party security firm
- [ ] Dependency audit: Snyk or npm audit
- [ ] Code static analysis: SonarQube
- [ ] Secrets scanning: gitleaks, TruffleHog

**Phase 2 (Post-Launch):**
- [ ] Annual penetration test
- [ ] Quarterly dependency audits
- [ ] Real-time vulnerability alerts (Dependabot)
- [ ] User security bounty program

---

## PERFORMANCE & SCALABILITY REQUIREMENTS

### Client-Side Performance

**App Launch:**
- Cold start: < 2 seconds
- Warm start: < 500ms
- Target device: iPhone 11 Pro or newer, Pixel 4 or newer

**Study Session:**
- Flashcard transition: < 200ms
- Difficulty submission: < 300ms
- SRS calculation: < 50ms (local)
- Image load: < 300ms (pre-cached)

**Memory Usage:**
- Idle: < 80 MB (RAM)
- Study session: < 150 MB (peak)
- Database (local): < 50 MB (uncompressed)

### Server-Side Performance

**API Response Times (95th percentile):**
- Vocabulary lookup: < 200ms
- Active Batch fetch: < 300ms
- Review submission: < 400ms
- Subscription check: < 150ms

**Database Queries:**
- Indexed on: user_id, vocabulary_id, language_pair, cefr_level, next_review_date
- Query cache: Redis (Supabase-integrated)
- Master Lexicon: Pre-loaded into memory (20,000 words ≈ 100 MB)

### Scalability Targets

**Year 1:**
- **Users:** 10,000 MAU (monthly active users)
- **Database:** 100 GB (users + study history)
- **API requests/sec:** 10 rps peak

**Year 2:**
- **Users:** 50,000 MAU
- **Database:** 500 GB
- **API requests/sec:** 50 rps peak

**Capacity Planning:**
- Auto-scaling: Supabase handles compute scaling
- CDN: All assets (images, audio) served via Cloudflare CDN
- Database replicas: Read replicas in EU, US, Asia-Pacific regions

### Bandwidth Optimization

**Image Serving:**
- Format: SVG (Ligne Claire illustrations) for crispness
- Size: 180×180px ≈ 10–20 KB per image
- Delivery: CDN with aggressive caching (30-day max-age)

**Audio Serving:**
- Format: MP3, 128 kbps, mono
- Size: ≈ 30–50 KB per word
- Delivery: CDN with lazy-loading (only play on demand)

**Data Sync (Ghost Backup):**
- Frequency: Every 6 hours or on manual trigger
- Payload: Compressed JSON ≈ 5–20 KB
- Optimization: Only send delta (changed records since last sync)

---

## QUALITY ASSURANCE & TESTING STRATEGY

### Testing Pyramid

```
                    /\
                   /  \
                  / E2E \
                 /Tests  \
                /          \
               / (Manual,   \
              / 5-10%)       \
             /________________\
            /                  \
           /   Integration      \
          /     Tests (15-20%)   \
         /______________________ \
        /                        \
       /       Unit Tests         \
      /       (70-75%)            \
     /________________________________\
```

### Unit Tests

**Scope:** SRS algorithm, validation logic, data serialization

**Frameworks:** Mockito + test package (Dart)

**Coverage Target:** 80%+

**Examples:**
- SM-2 algorithm calculations (ease_factor, interval updates)
- Language config YAML parsing
- CSV validation (UTF-8, diacritics, regex checks)
- SQLCipher encryption/decryption
- Conflictresolution (LWW strategy)

### Integration Tests

**Scope:** API contracts, database operations, sync protocol

**Setup:** Test database (Supabase staging) + mock OAuth

**Examples:**
- Authentication flow (signup, SSO, token refresh)
- Active Batch fetch + SRS recalculation
- Study session completion + streak update
- Subscription receipt verification

### End-to-End Tests

**Scope:** Full user journeys, UI interactions

**Framework:** Patrol (Flutter E2E testing)

**Devices:** 2–3 real devices (iPhone + Android), emulators

**Test Scenarios:**
1. Onboarding flow (signup → language selection → first session)
2. Daily study loop (5+ card reviews, difficulty ratings, streak preservation)
3. Multi-language session (switch languages, verify SRS independence)
4. Curfew + Ash Protocol (manual time manipulation test, signature verification)
5. Subscription upgrade (freemium → monthly, receipt validation)
6. Offline study (disable internet, complete session, verify signature)
7. Vault audit (quarterly re-validation of archived words)
8. Settings update (Curfew change, drip customization, theme toggle)

### Manual Testing Checklist

**Before Each Release:**
- [ ] App launches without crashes (cold start)
- [ ] Onboarding flows smoothly (4 devices: iPhone + Android)
- [ ] Study session performs smoothly (no lag, flashcard transitions smooth)
- [ ] Curfew + Ice State visual shift works at correct time
- [ ] Streaks update correctly (verify via backend API)
- [ ] Subscription paywall displays correctly
- [ ] Dark mode renders all colors correctly
- [ ] Audio pronunciation plays (no distortion, correct volume)
- [ ] Images (Ligne Claire) render crisply
- [ ] Accessibility: Text scaling + VoiceOver (iOS) + TalkBack (Android)

### Performance Testing

**Benchmarks:**
- App startup time: Measure vs. baseline
- Memory usage: Monitor for leaks (30-min study session)
- Battery drain: 1-hour continuous study session
- Sync payload size: Compare before/after optimization

**Tools:** Flutter DevTools, Android Profiler, Xcode Instruments

### User Acceptance Testing (Phase 2)

**Beta Program:** 100–500 external users (1–2 weeks before release)

**Feedback Channels:**
- In-app feedback form
- Public Discord server
- GitHub issues (public repo with development diary)

**Success Criteria:**
- 0 critical bugs in beta period
- Avg. app rating: 4.5+/5
- Churn rate: < 20% in first week

---

## DEPLOYMENT & RELEASE STRATEGY

### Release Schedule

| Phase | Timeline | Target Users | Focus |
|-------|----------|--------------|-------|
| **Closed Alpha** | Weeks 1–4 | Team + 10 friends | Core study loop, SRS |
| **Closed Beta** | Weeks 5–8 | 50 early adopters | Bug fixes, performance |
| **Open Beta** | Weeks 9–12 | 500+ public users | Feedback, retention |
| **Production v1.0** | Week 12 | Public launch | Store submissions + live |
| **Post-Launch** | Ongoing | Scale | Monitoring, hotfixes |

### Branching Strategy (Git)

```
main (production) ← stable releases
  ↑
develop ← integration branch for next release
  ↑
feature/* ← individual features (WL-001, WL-002, etc.)
  ↑
hotfix/* ← emergency production fixes
```

**Pull Request Requirements:**
- Minimum 1 code review approval
- All CI checks passed (tests, lint, analysis)
- No merge conflicts

### Continuous Integration (GitHub Actions)

```yaml
Trigger: Pull Request to develop / main
Steps:
  1. Run unit tests (Dart)
  2. Run integration tests (Supabase staging)
  3. Flutter analyze (lint)
  4. Code coverage check (80% threshold)
  5. Build APK + IPA (for review builds)
  6. Upload to Firebase Test Lab (Android)
  7. Notify team on Slack
```

### App Store Submission

**iOS (Apple App Store):**
1. Archive build in Xcode
2. Upload via Transporter
3. Submit for review (1–3 days approval)
4. Monitor for rejections (Apple can be strict on "productivity" apps)

**Android (Google Play):**
1. Build signed release APK/AAB
2. Upload to Play Console
3. Optional pre-launch report (Google testing)
4. Publish (usually live within hours)

**Store Listing Content:**
- App name: WordLearn
- Subtitle: Vocabulary Mastery Without Fluff
- Description: (Professional, emphasizing academic rigor, SRS, privacy)
- Screenshots: 5–8 images (study session, Vault, settings, Dark Mode)
- Video: Optional 30-second walkthrough

### Monitoring & Analytics (Post-Launch)

**Metrics Dashboard (Plausible Analytics):**
- Daily active users (DAU) / Monthly active users (MAU)
- Retention rate (Day 1, Day 7, Day 30)
- Churn rate (daily/monthly)
- Session duration (avg.)
- Languages per user distribution
- Subscription conversion rate

**Error Tracking (Sentry):**
- Crash rate
- Error frequency
- Affected user count
- Stacktrace trends

**Performance Monitoring (LogRocket, anonymized):**
- API response times (p50, p95, p99)
- App startup time
- Memory usage patterns
- Network errors

**Business Metrics:**
- MRR (Monthly Recurring Revenue)
- LTV (Lifetime Value per subscription tier)
- CAC (Customer Acquisition Cost, if applicable)
- Subscription churn rate

### Hotfix Process

**If critical bug in production:**
1. Assess severity (data loss, crash, security breach)
2. Create hotfix branch: `hotfix/issue-description`
3. Implement fix + tests
4. Merge to main + develop
5. Tag release (v1.0.1)
6. Submit to stores (expedited)
7. Post-mortem analysis (prevent recurrence)

---

## FAQ & DECISION LOG

### FAQ for Product Team

**Q1: Why Spaced Repetition (SRT) instead of AI-adaptive learning?**
A: SRT is science-backed (50+ years of research). AI-adaptive learning requires large datasets and risks overfitting to user quirks. For a privacy-first app, we avoid user behavior tracking. SM-2 is transparent, predictable, and works offline.

**Q2: Why no gamification (streaks, badges, leaderboards)?**
A: Gamification can create fake engagement and "checking in" behavior without real learning. The Curfew + Ash Protocol create accountability, not dopamine. Badges would trivialize mastery.

**Q3: Why "200-word Active Batch"?**
A: Cognitive load research suggests 150–300 items optimal for working memory. 200 prevents overwhelm while maintaining depth. Larger batches lead to surface-level learning (7–10 reviews per word). Smaller batches slow progression.

**Q4: Why local-first storage?**
A: Privacy (user owns data), reliability (works offline), and cost (reduce server load). Server is backup + cross-device sync, not the primary source.

**Q5: Why no ads?**
A: Ads are incompatible with "distraction-free" ethos. Subscription model funds development cleanly.

**Q6: What's the "Director's Pardon" and why once per 180 days?**
A: Real life happens (flights, illness, emergencies). Hard resets without pardon would frustrate serious users. 2–3 pardons/year = lenient but not permissive. Double-intensity remediation ensures real learning, not cheap recovery.

**Q7: Why manual curriculum injection (Phase 2) and not auto-adaptive?**
A: Users know what they need to learn. Allow manual overrides while respecting CEFR structure.

**Q8: Why no support for native script languages (Arabic, Chinese, Japanese)?**
A: Initial MVP focuses on Latin-script languages + Turkish (well-studied, CEFR-aligned). Non-Latin scripts require:
   - RTL text support (Arabic, Hebrew)
   - Complex character rendering (CJK)
   - Different CEFR alignment (HSK for Chinese, JLPT for Japanese)
   - These add significant complexity. Phase 2+ will add these if demand justifies.

**Q9: Why no "smart notifications"?**
A: Smart notifications require user behavior tracking. Curfew reminder (1 hour before) is enough. Users who care about streaks will check the app.

**Q10: How do we prevent users from gaming the SRS (marking everything "Easy")?**
A: We don't prevent it, but:
   - "Easy" words with inconsistent past performance flag for review (admin audit)
   - Vault audit re-validates archived words (gaming exposed)
   - User-submitted data (mnemonics) vouches for credibility, not ease rating

### Decision Log

| Decision | Context | Trade-offs | Status |
|----------|---------|-----------|--------|
| **Flutter for frontend** | Cross-platform, pixel-perfect control | Limited native integrations (mitigated via plugins) | ✅ Approved |
| **Supabase for backend** | Managed database, Auth, Edge Functions | Less control vs. self-hosted (acceptable for MVP) | ✅ Approved |
| **SQLCipher for local encryption** | Industry-standard, open-source | Small performance overhead (< 5%) | ✅ Approved |
| **SM-2 algorithm (not custom)** | Proven, transparent, offline-friendly | Less sophisticated than modern ML (acceptable for privacy model) | ✅ Approved |
| **200-word Active Batch limit** | Cognitive science support | May frustrate fast learners (acceptable, design choice) | ✅ Approved |
| **Monthly + 6-month only (no annual)** | Simpler monetization | Lose users who want annual discount (Phase 2 addition) | ✅ Approved |
| **No B2B (corporate) in MVP** | Focus on consumer product | Lose revenue from institutions (Phase 3) | ✅ Approved |
| **Offline-capable study** | Privacy, reliability | Requires cryptographic proof system (planned) | ✅ Approved |
| **Ligne Clare illustrations** | Premium aesthetic, unique branding | High initial art cost (amortized over user lifetime) | ✅ Approved |

---

## Glossary of Terms

| Term | Definition | Context |
|------|-----------|---------|
| **The Drip** | Daily injection of new words (default: 20) | Gamification-free vocabulary progression |
| **Active Batch** | Current 200-word working set | Cognitive load management |
| **The Vault** | Archive of mastered words (re-validated quarterly) | Long-term retention verification |
| **The Curfew** | User-defined daily study deadline (e.g., 22:00) | Accountability boundary |
| **The Ice State** | UI palette shift (warm → cool cyan) at Curfew-1hr | Psychological priming, no notifications |
| **The Ash Protocol** | Hard streak reset if Curfew missed | Enforces discipline (no streak freezes) |
| **The Chancellor** | Minimalist mascot character (professional, occasional feedback) | UI persona, guidance |
| **Ghost Backup** | Encrypted progress blob synced every 6 hours | Cloud backup + cross-device sync |
| **SRS (Spaced Repetition System)** | SM-2 algorithm for review scheduling | Core learning engine |
| **CEFR** | Common European Framework of Reference (A1–C2) | Vocabulary classification standard |
| **LWW (Last-Write-Wins)** | Conflict resolution strategy (latest review wins) | Cross-device sync logic |
| **Language Pair** | User's base language + target language (e.g., en-de) | Isolation unit for progress tracking |

---

## Appendix: Modular Language Addition Checklist

Use this checklist when adding a new language (e.g., Portuguese):

- [ ] **Step 1: Configuration**
  - [ ] Add language to `languages.yaml`
  - [ ] Verify: Locale code, CEFR support, RTL/LTR, script type
  - [ ] Test: YAML validation script

- [ ] **Step 2: Data Preparation**
  - [ ] Create CSV files:
    - [ ] `data/vocabularies/en-pt/a1.csv` (A1 words)
    - [ ] `data/vocabularies/en-pt/a2.csv` (A2 words)
    - [ ] Continue for B1, B2, C1, C2
  - [ ] Validate: UTF-8 encoding, diacritics, regex checks
  - [ ] QA: Native speaker review of example sentences

- [ ] **Step 3: Assets**
  - [ ] Prepare illustrations (180×180px SVG, Ligne Claire style)
  - [ ] Record/generate audio (MP3, 128 kbps)
  - [ ] Upload to CDN (Supabase Storage)

- [ ] **Step 4: Database**
  - [ ] Generate migration SQL (auto-generated by script)
  - [ ] Test in staging environment
  - [ ] Verify: Data integrity, index performance

- [ ] **Step 5: Testing**
  - [ ] Unit tests: Language config + CSV parsing
  - [ ] Integration tests: Vocabulary fetch, SRS with new language
  - [ ] E2E tests: Onboarding with Portuguese, multi-language session

- [ ] **Step 6: Deployment**
  - [ ] Review PR (no code changes, only config + data)
  - [ ] Merge to main
  - [ ] Tag release (v1.x.0)
  - [ ] Deploy to production
  - [ ] Verify: Language appears in onboarding selector

- [ ] **Step 7: Monitoring**
  - [ ] Monitor Sentry for errors
  - [ ] Check user language distribution
  - [ ] Gather feedback from Portuguese learners

---

## Document Approval & Sign-Off

| Role | Name | Approval | Date |
|------|------|----------|------|
| **Product Manager** | [TBD] | [ ] | [ ] |
| **Lead Developer** | [TBD] | [ ] | [ ] |
| **Designer** | [TBD] | [ ] | [ ] |
| **Security Lead** | [TBD] | [ ] | [ ] |

---

**End of PRDv2 Document**

This document is the authoritative specification for all stakeholders (product, engineering, design, QA). Refer to it for user story acceptance criteria, technical implementation details, and design specifications.

Questions? Open an issue in the product repository.
