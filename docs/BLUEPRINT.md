# WordLearn — Application Blueprint

**Purpose:** Single reference for app structure: tabs, pages, connections, panels, functions, and dashboards. Aligns with PRD (prdv2.md) and user stories.

**Version:** 1.0  
**Last Updated:** 2026-03-05

---

## 1. Application Shell & Tabs

The app uses **bottom navigation** with a small set of tabs. Post-onboarding, the main shell is:

| Tab | Label | Route / ID | Purpose |
|-----|--------|------------|---------|
| **Home** | Home | `/` or `home` | Daily briefing, “Start Session”, streak, curfew, stats |
| **Batch** | Batch | `/batch` | Active Batch word list (max 200 per language), sort/filter |
| **Vault** | Vault | `/vault` | Mastered words archive, search, re-review, move back to batch |
| **Languages** | Languages | `/languages` | Enrolled languages, per-language stats, add language (subscription-gated) |
| **Settings** | Settings | `/settings` | Profile, learning (Curfew, Drip), privacy, subscription, logout, delete account |

**Notes:**
- On first launch (no completed onboarding): no tabs; user goes through onboarding flow.
- “Languages” tab may be merged into Settings in MVP if needed; PRD describes it as a dedicated tab for multi-language stats.

---

## 2. Pages & Screens

### 2.1 Pre-auth / Onboarding (no tabs)

| Screen | Route | Description |
|--------|--------|-------------|
| **Splash / Loading** | `/` (initial) | Logo, loading; then redirect to Auth or Onboarding or Home |
| **Auth** | `/auth` | Email sign-up/sign-in + Google + Apple (iOS). Entry to onboarding. |
| **Welcome** | `/onboarding/welcome` | “Scholar, welcome to WordLearn.” + GET STARTED |
| **Base Language** | `/onboarding/base-language` | Select L1 (single select from 6) |
| **Target Languages** | `/onboarding/target-languages` | Select L2–L6 (multi-select, 1–6), exclude L1 |
| **CEFR Level** | `/onboarding/cefr` | Per target language: A1–C2 dropdown |
| **Curfew** | `/onboarding/curfew` | Time picker (default 22:00), warning text |
| **Daily Drip** | `/onboarding/drip` | Slider 5–40 (default 20) words/day |
| **Paywall** | `/onboarding/paywall` | Free / Monthly / 6-Month; TRY FREE or SUBSCRIBE |

### 2.2 Main App (with tabs)

| Screen | Route | Tab | Description |
|--------|--------|-----|-------------|
| **Home** | `/home` | Home | Greeting, “X words due”, “Y new words”, streak, Curfew, START SESSION |
| **Session (study)** | `/session` | — | Full-screen flashcard loop: front → reveal → rate (HARD/FAMILIAR/OK/EASY) |
| **Session complete** | `/session/complete` | — | Summary: reviewed, mastered, streak; CONTINUE / VIEW STATS |
| **Batch list** | `/batch` | Batch | List of Active Batch words, SRS state, sort (due first, hard first, oldest), filters |
| **Word detail** | `/batch/word/:id` or modal | — | Word, translation, example, image, audio; actions (e.g. move to Vault) |
| **Vault list** | `/vault` | Vault | Mastered words, sort by date, filter by language, search |
| **Vault word detail** | `/vault/word/:id` or modal | — | Same as batch word + “Re-review”, “Move back to batch” |
| **Vault audit** | `/vault/audit` | — | 5 random Vault words, same flashcard + rating flow; then pass/fail outcome |
| **Languages** | `/languages` | Languages | Cards per language: batch count, vault count, streak, CEFR; “Add language” |
| **Settings** | `/settings` | Settings | Profile, Learning, Privacy, Account, Danger Zone (logout, delete) |

### 2.3 Modals / Overlays

| UI | Trigger | Purpose |
|----|---------|---------|
| **Batch full** | When user would exceed 200 words | “Batch full. Master 1 word to add new word.” + VIEW WORDS TO MASTER |
| **Upgrade prompt** | Free user adds 2nd language | “Upgrade to unlock multiple languages” |
| **Milestone (e.g. 50 words)** | Every 50 words to Vault | “50 Words Mastered!” + list + VIEW REPORT / CONTINUE |
| **Ash (streak reset)** | Missed Curfew | Streak “burns” to 0, message |
| **Pardon** | Settings, eligible | “Use Pardon” → confirm → double-intensity next session |

---

## 3. Navigation & Connections

```
Splash → [not authenticated] → Auth
Auth → [success] → Onboarding Welcome (if first time) or Home (if onboarding done)

Onboarding (linear):
  Welcome → Base Language → Target Languages → CEFR → Curfew → Drip → Paywall → Home

Home:
  - START SESSION → Session (flashcard loop)
  - VIEW BATCH → Batch tab
  - Language selector / Multi-language toggle → affects session content

Session:
  - Card N of M → next card after rating
  - Last card submitted → Session complete

Session complete:
  - CONTINUE → Home
  - VIEW STATS → (Phase 2: stats screen)

Batch:
  - Word row → Word detail (modal or push)
  - Long-press → Move to Vault / Remove (with confirm)

Vault:
  - Word row → Vault word detail
  - RE-REVIEW NOW → Vault audit
  - Banner “Vault audit available” → Vault audit

Settings:
  - Log out → Auth (tokens cleared)
  - Delete account → API + local wipe → Auth
  - Upgrade → Paywall or store
```

---

## 4. Panels & Key UI Blocks

| Panel | Location | Content |
|-------|----------|---------|
| **Daily briefing** | Home | Greeting, “X words due”, “Y new words”, “Streak: Z”, “Curfew: HH:MM” |
| **START SESSION** | Home | Primary CTA; may show language dropdown or “Multi-language” toggle |
| **Flashcard front** | Session | Target word (large), IPA, Ligne Claire image |
| **Flashcard back** | Session | Translation, example sentence, example translation |
| **Difficulty row** | Session | HARD | FAMILIAR | OK | EASY (4 buttons) |
| **Progress** | Session | “Card X of Y” |
| **Batch summary** | Batch tab | “156 / 200 words”, sort/filter controls |
| **Word row (batch)** | Batch | Word, translation, next review date, difficulty color |
| **Vault summary** | Vault tab | “X words mastered”, search, sort |
| **Language card** | Languages tab | Language name, batch count, vault count, streak, CEFR |
| **Curfew banner** | Home / Session | “X minutes until Curfew” (Ice State) or “DEADLINE PASSED” |
| **Ice State** | Global (when &lt; 1 hr to Curfew) | Palette shift: teal → cyan, paper → light cyan |

---

## 5. Functions & Calculations

| Function / Logic | Where used | Description |
|------------------|------------|-------------|
| **SM-2 (SRS)** | After each card rating | Input: difficulty (1–4), current ease_factor, interval, repetitions. Output: new ease_factor, interval_days, next_review_date. “Hard” resets interval to 1 and re-queues. |
| **Due today count** | Home | Count rows in active_batch where next_review_date ≤ today (and language_pair = selected). |
| **New words today** | Home | From daily drip: how many new words added today (by last_drip_date + daily_drip_count). |
| **Daily drip** | On app startup / manual sync | If last_drip_date &lt; today: add up to daily_drip_count new words from next CEFR level into active_batch (max 200 per user per language_pair). |
| **Curfew check** | Session complete | Compare server UTC time with user’s daily_curfew_utc; if before → increment streak; if after → Ash Protocol (streak = 0). |
| **Ice State** | Theming | If now is within 60 minutes before Curfew (local) → apply Ice palette. |
| **Vault eligibility** | Batch word list / actions | Word can move to Vault if ease_factor ≥ 2.0, last_reviewed ≥ 7 days ago, repetitions ≥ 2. |
| **Vault audit due** | Vault / Home | next_audit_date ≤ today for some Vault words → show banner / offer audit. |
| **Subscription gating** | Add language, batch size, features | Free: 1 language, 50-word batch. Paid: up to 6 languages, 200-word batch. |
| **Offline proof** | Session complete (offline) | Sign completion timestamp with device key; on reconnect send to server; server validates and then applies Curfew/streak logic. |

---

## 6. Dashboards & Summary Views

| View | Location | Metrics / Content |
|------|----------|--------------------|
| **Home (daily briefing)** | Home tab | Words due today, new words today, streak, Curfew time; START SESSION. |
| **Session complete** | After last card | Words reviewed, words mastered this session, updated streak; CONTINUE / VIEW STATS. |
| **Batch** | Batch tab | Total X/200 words; list with next review date and difficulty; sort/filter. |
| **Vault** | Vault tab | Total mastered count; list with mastered date, next audit; search. |
| **Languages** | Languages tab | Per language: batch count, vault count, streak, CEFR level. |
| **Settings – Account** | Settings | Subscription tier, expiry, Upgrade / Manage. |
| **Vault audit result** | After audit | “X/5 words passed”, next audit date. |
| **Milestone** | Modal after 50th Vault | “50 Words Mastered!”, list, VIEW REPORT (Phase 2). |

---

## 7. Data Connections (High Level)

| Source | Consumer | Data |
|--------|----------|------|
| **Supabase Auth** | Auth screen, app state | User id, email, tokens; trigger onboarding vs home |
| **Local SQLite (SQLCipher)** | Home, Session, Batch, Vault | active_batch, vault, user profile, SRS state, session history |
| **Supabase (API)** | Sync, session complete, backup | Ghost Backup upload, session completion, Curfew/streak, receipt verification |
| **Assets / config** | App init, language config | languages.yaml, vocabulary CSVs (bundled or encrypted); master_vocabulary |
| **IAP (Store)** | Paywall, Settings | Products, purchase, receipt → server verify |

---

## 8. State (Logical)

- **Auth:** logged-in user, tokens, refresh logic.
- **Onboarding:** current step, base language, target languages, CEFR per language, Curfew, Drip, subscription choice.
- **Subscription:** tier, expiry, entitlements (language count, batch cap).
- **Session:** session_id, list of cards, current index, start time; on rate → SRS update, persist, next card.
- **Curfew / Ice:** current time vs Curfew for theme and banner.
- **Streak / Ash:** streak_count, last_session_date, Ash animation trigger.

This blueprint should stay in sync with the PRD and user stories; update as routes or features change.
