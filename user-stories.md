# WordLearn User Stories & Developer Tasks
## Production-Ready Specifications for Sprint Planning & Implementation

**Document Version:** 1.0  
**Status:** Ready for Development  
**Format:** User Stories with Acceptance Criteria & Developer Tasks  
**Total Stories in MVP:** 45+  

---

## EPIC STRUCTURE

| Epic | Stories | Story IDs | Focus |
|------|---------|-----------|-------|
| **Authentication & Authorization** | 3 | WL-001 to WL-005 | User signup, login, SSO, token management |
| **Onboarding & Profile Setup** | 5 | WL-010 to WL-020 | L1/L2 selection, Curfew setup, Drip config |
| **Core Study Loop** | 8 | WL-050 to WL-100 | Flashcard rendering, difficulty ratings, SRS updates |
| **Active Batch Management** | 4 | WL-140 to WL-160 | 200-word limit, daily drip, batch UI |
| **Vault & Long-Term Storage** | 3 | WL-170 to WL-190 | Archive mastered words, audit system |
| **Curfew & Accountability** | 3 | WL-200 to WL-220 | Ice State, Ash Protocol, offline signing |
| **Subscription & Monetization** | 3 | WL-300 to WL-320 | Paywall, receipt verification, entitlements |
| **Settings & User Preferences** | 2 | WL-400 to WL-410 | Profile mgmt, learning settings, privacy controls |
| **Sync & Data Persistence** | 3 | WL-500 to WL-520 | Ghost Backup, conflict resolution, offline support |
| **Multi-Language Support** | 2 | WL-600 to WL-610 | Language selection, independent tracking, multi-session |

---

# EPIC 1: AUTHENTICATION & AUTHORIZATION

## WL-001: Email Sign-Up Flow

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 8 points  
**Dependencies:** Supabase Auth configured  

### User Story
As a **new user**, I want to **sign up with email and password**, so that **I can create a WordLearn account and begin learning**.

### Acceptance Criteria

1. **Sign-Up Form Displays Correctly**
   - [ ] Email field accepts valid email format (RFC 5322)
   - [ ] Password field accepts min 8 characters, requires uppercase + number + special char
   - [ ] Password confirmation field matches password field
   - [ ] Form displays error messages inline (red text, no aggressive alerts)
   - [ ] "Sign Up" button disabled until all fields valid

2. **Email Validation**
   - [ ] User enters invalid email (e.g., "abc@") → Error: "Invalid email format"
   - [ ] User enters valid email → Form proceeds
   - [ ] Duplicate email → Error: "Email already registered. Sign in instead?"

3. **Password Validation**
   - [ ] Password < 8 chars → Error: "Password min 8 characters"
   - [ ] Password without uppercase → Error: "Include uppercase letter"
   - [ ] Password without number → Error: "Include number"
   - [ ] Password without special char → Error: "Include special character (!@#$%)"
   - [ ] Valid password → Form proceeds

4. **Account Creation**
   - [ ] On successful signup → POST /auth/signup with email + password
   - [ ] Server returns JWT access token + refresh token
   - [ ] Tokens stored securely in device Keystore (Android) / Keychain (iOS)
   - [ ] User redirected to Onboarding Flow (WL-010)

5. **Error Handling**
   - [ ] Server error (500) → "Service temporarily unavailable. Try again."
   - [ ] Network error → "No internet connection. Check your network."
   - [ ] All errors display with "RETRY" button

### Developer Tasks

```
Task 1: Design Sign-Up UI Screen
- [ ] Create Sign-Up screen layout (email field, password field, password confirmation)
- [ ] Style form elements per Design System (8px grid, Paper White background, Teal accent)
- [ ] Button states: default, disabled (grayed), loading (spinner)
- [ ] Test on 2 screen sizes (iPhone 12, Pixel 4)
- [ ] Time estimate: 3 hours

Task 2: Implement Form Validation Logic
- [ ] Dart regex validator for email (RFC 5322 pattern)
- [ ] Password strength checker (uppercase, number, special char)
- [ ] Real-time validation (error shows as user types)
- [ ] Disable sign-up button until all fields valid
- [ ] Unit tests for validation logic (8+ test cases)
- [ ] Time estimate: 4 hours

Task 3: Integrate Supabase Auth Signup
- [ ] Install supabase_flutter package
- [ ] Implement POST /auth/signup endpoint call
- [ ] Error handling for duplicate email, weak password, server errors
- [ ] Store JWT tokens in Flutter Secure Storage
- [ ] Loading state while request in progress
- [ ] Time estimate: 4 hours

Task 4: Testing & QA
- [ ] Unit test: Email validation (10+ cases)
- [ ] Unit test: Password validation (15+ cases)
- [ ] Integration test: Full signup flow (happy path + error states)
- [ ] Manual QA on iOS + Android (real devices)
- [ ] Time estimate: 3 hours
```

### Acceptance Criteria Verification

**How to Test:**
1. Open app → Tap "Sign Up"
2. Enter invalid email (e.g., "abc") → See error message
3. Enter valid email → Error clears
4. Enter password < 8 chars → See length error
5. Add uppercase + number + special char → Error clears
6. Confirm password matches → "Sign Up" button enables
7. Tap "Sign Up" → Wait for API call → Redirected to Onboarding

**Success Metric:** User successfully creates account and lands on Onboarding (WL-010).

---

## WL-002: Google OAuth Sign-In

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 6 points  
**Dependencies:** Google OAuth configured in Supabase  

### User Story
As a **busy user**, I want to **sign in with Google**, so that **I can skip manual email/password entry and get to learning faster**.

### Acceptance Criteria

1. **OAuth Button Displays**
   - [ ] "SIGN IN WITH GOOGLE" button visible on Auth screen
   - [ ] Button styled consistently (white bg, Google logo, dark text)
   - [ ] Tap opens Google sign-in picker (not in-app browser)

2. **Google Sign-In Flow**
   - [ ] User taps button → Google account picker appears
   - [ ] User selects Google account → Consent screen (if first time)
   - [ ] On success → JWT tokens received + stored securely
   - [ ] Redirect to Onboarding (WL-010)

3. **Error Handling**
   - [ ] User cancels Google sign-in → Return to Auth screen (no error)
   - [ ] Network error during sign-in → "Failed to connect. Retry."
   - [ ] Server error → "Sign-in failed. Try again."

4. **Account Linking**
   - [ ] First-time Google user → Auto-create account
   - [ ] Returning Google user → Sign in directly
   - [ ] If email exists (from email signup) → Link accounts (not MVP, Phase 2)

### Developer Tasks

```
Task 1: Configure Google OAuth in Supabase
- [ ] Create Google OAuth credentials (iOS + Android bundle IDs)
- [ ] Add credentials to Supabase Auth settings
- [ ] Test OAuth flow in staging environment
- [ ] Time estimate: 2 hours

Task 2: Implement Google Sign-In UI
- [ ] Add Google Sign-In button to Auth screen
- [ ] Style button per Google brand guidelines (white bg, logo)
- [ ] Integrate google_sign_in package (Flutter)
- [ ] Show loading indicator during sign-in
- [ ] Time estimate: 2 hours

Task 3: Handle OAuth Callback
- [ ] Catch Google OAuth response (ID token)
- [ ] POST to /auth/oauth/callback with provider=google + id_token
- [ ] Store JWT tokens securely
- [ ] Check if new user vs. existing user
- [ ] Redirect accordingly (new → Onboarding, existing → Home)
- [ ] Time estimate: 3 hours

Task 4: Error Handling & Testing
- [ ] Handle user-cancelled sign-in gracefully
- [ ] Handle network errors (retry logic)
- [ ] Handle server errors (rate limit, invalid token)
- [ ] Test on iOS (via Apple sign-in picker)
- [ ] Test on Android (via Google play services)
- [ ] Time estimate: 3 hours
```

### Acceptance Criteria Verification

**How to Test:**
1. Open app → Tap "SIGN IN WITH GOOGLE"
2. Select Google account → Sign in
3. Verify tokens stored (use iOS Keychain viewer / Android Keystore inspector)
4. Verify redirected to Onboarding (WL-010)

**Success Metric:** User signs in via Google and accesses Onboarding without friction.

---

## WL-003: Apple OAuth Sign-In (iOS)

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker for iOS)  
**Effort:** 5 points  
**Dependencies:** Apple Sign In configured in Supabase  

### User Story
As an **iOS user**, I want to **sign in with Apple**, so that **I can leverage biometric authentication and maintain privacy**.

### Acceptance Criteria

1. **Apple Sign-In Button (iOS Only)**
   - [ ] "SIGN IN WITH APPLE" button visible on iOS auth screen
   - [ ] Button styled per Apple Human Interface Guidelines (white bg, black text)
   - [ ] Android does NOT show this button (graceful degradation)

2. **Apple Sign-In Flow**
   - [ ] Tap button → System sign-in prompt (Face ID / Touch ID if enabled)
   - [ ] User approves → JWT tokens received
   - [ ] Redirect to Onboarding (WL-010)
   - [ ] Private relay support: Hidden email handled gracefully

3. **Error Handling**
   - [ ] User cancels → Return to Auth screen (no error)
   - [ ] Biometric fails → Show "Authentication failed" + retry
   - [ ] Network error → "Sign-in failed. Try again."

### Developer Tasks

```
Task 1: Configure Apple Sign-In in Supabase
- [ ] Create Apple Sign-In credentials (bundle ID, team ID)
- [ ] Add to Supabase Auth configuration
- [ ] Time estimate: 1 hour

Task 2: Implement Apple Sign-In UI (iOS Only)
- [ ] Add Apple Sign-In button (iOS-specific)
- [ ] Integrate sign_in_with_apple package (Flutter)
- [ ] Show loading state during authentication
- [ ] Time estimate: 2 hours

Task 3: Handle Apple OAuth Response
- [ ] Catch Apple OAuth response (ID token, email if available)
- [ ] Handle private relay (user@privaterelay.appleid.com)
- [ ] POST to /auth/oauth/callback with provider=apple
- [ ] Store JWT tokens securely
- [ ] Time estimate: 2 hours

Task 4: Testing & QA
- [ ] Test on iOS 14+ devices
- [ ] Test biometric authentication (Face ID, Touch ID)
- [ ] Test private relay flow
- [ ] Verify Android doesn't show button
- [ ] Time estimate: 2 hours
```

### Acceptance Criteria Verification

**How to Test (iOS Only):**
1. Open app on iOS → Tap "SIGN IN WITH APPLE"
2. Use Face ID / Touch ID → Sign in
3. Verify redirected to Onboarding (WL-010)

**Success Metric:** iOS users can sign in with Apple seamlessly.

---

## WL-004: JWT Token Management & Refresh

**Story Type:** Feature  
**Priority:** P0 (Critical - Security)  
**Effort:** 5 points  
**Dependencies:** WL-001, WL-002, WL-003  

### User Story
As the **system**, I want to **automatically refresh expired JWT tokens**, so that **users remain authenticated without forced re-login**.

### Acceptance Criteria

1. **Token Storage**
   - [ ] Access token stored in device Keychain (iOS) / Keystore (Android)
   - [ ] Refresh token stored separately (no accidental exposure)
   - [ ] Tokens encrypted at rest (via hardware security module)

2. **Token Refresh Logic**
   - [ ] On app startup → Check token expiry
   - [ ] If expired → Auto-refresh using refresh token
   - [ ] If refresh token expired → Force re-login
   - [ ] New tokens stored securely
   - [ ] User sees no disruption (transparent refresh)

3. **API Call Interceptor**
   - [ ] Every API request includes `Authorization: Bearer {access_token}`
   - [ ] If API returns 401 (unauthorized) → Attempt refresh
   - [ ] On successful refresh → Retry original request
   - [ ] If refresh fails → Redirect to Auth screen

4. **Token Expiry**
   - [ ] Access token expires in 1 hour
   - [ ] Refresh token expires in 30 days
   - [ ] Logout immediately invalidates refresh token on server

### Developer Tasks

```
Task 1: Implement Secure Token Storage
- [ ] Use flutter_secure_storage for token persistence
- [ ] Store access token + refresh token separately
- [ ] Encrypt token payload before storage
- [ ] Time estimate: 2 hours

Task 2: Add Token Refresh Logic
- [ ] Create Riverpod provider for auth state
- [ ] Check token expiry on app startup
- [ ] Implement refresh endpoint call
- [ ] Handle expired refresh token (force re-login)
- [ ] Unit tests for refresh logic
- [ ] Time estimate: 3 hours

Task 3: Implement API Interceptor (Dio)
- [ ] Add JWT token to every HTTP request header
- [ ] Catch 401 responses (token expired)
- [ ] Auto-retry refresh + re-attempt request
- [ ] Handle network errors gracefully
- [ ] Time estimate: 3 hours

Task 4: Testing
- [ ] Unit test: Token refresh logic
- [ ] Integration test: API call with expired token
- [ ] Manual test: Force token expiry + verify refresh
- [ ] Time estimate: 2 hours
```

### Acceptance Criteria Verification

**How to Test:**
1. Sign in → Get valid JWT tokens
2. Wait 1 hour (or manually expire token in test)
3. Make API request → System auto-refreshes token → Request succeeds
4. Verify access token changed (compare before/after)

**Success Metric:** Users remain authenticated without interruption, tokens refresh transparently.

---

## WL-005: Logout & Session Termination

**Story Type:** Feature  
**Priority:** P1  
**Effort:** 3 points  
**Dependencies:** WL-001 to WL-004  

### User Story
As a **user**, I want to **log out of my account**, so that **I can securely end my session and prevent unauthorized access**.

### Acceptance Criteria

1. **Logout Flow**
   - [ ] Settings → "Log Out" button (bottom)
   - [ ] Confirm dialog: "Are you sure? You'll need to sign in again."
   - [ ] On confirm → DELETE /auth/logout call (revoke refresh token)
   - [ ] Clear all local tokens from secure storage
   - [ ] Redirect to Auth screen
   - [ ] User must sign in again to access app

2. **Data Handling**
   - [ ] Local vocabulary + progress remain on device (for offline reference)
   - [ ] On re-login → Sync with server to restore latest progress
   - [ ] No data loss

3. **Error Handling**
   - [ ] Network error during logout → "Failed to logout. Try again."
   - [ ] Show retry button
   - [ ] If retry fails → Force local logout anyway (clear tokens)

### Developer Tasks

```
Task 1: Add Logout Button to Settings
- [ ] Create Settings screen (WL-400)
- [ ] Add "LOG OUT" button at bottom
- [ ] Style with warning colors (red text, darker bg)
- [ ] Time estimate: 1 hour

Task 2: Implement Logout Logic
- [ ] Confirmation dialog component
- [ ] POST /auth/logout endpoint call
- [ ] Clear JWT tokens from secure storage
- [ ] Clear cached user data (Riverpod state reset)
- [ ] Redirect to Auth screen
- [ ] Time estimate: 2 hours

Task 3: Testing
- [ ] Test logout success flow
- [ ] Test network error handling
- [ ] Verify tokens cleared from device
- [ ] Verify user redirected to Auth screen
- [ ] Time estimate: 1 hour
```

### Acceptance Criteria Verification

**How to Test:**
1. Sign in → Go to Settings → Tap "LOG OUT"
2. Confirm logout
3. Verify app shows Auth screen
4. Verify cannot access any protected screens (redirects to Auth)
5. Re-login → Verify progress restored from server

**Success Metric:** Users can securely logout and data persists on re-login.

---

# EPIC 2: ONBOARDING & PROFILE SETUP

## WL-010: Welcome & Introduction Screen

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 2 points  
**Dependencies:** WL-001, WL-002, WL-003  

### User Story
As a **new user**, I want to **see the WordLearn mission statement**, so that **I understand the app's philosophy before committing**.

### Acceptance Criteria

1. **Welcome Screen Displays**
   - [ ] Large headline: "Scholar, welcome to WordLearn."
   - [ ] Subheading: "A precision tool for vocabulary mastery."
   - [ ] Body text (max 100 words) explaining the no-fluff philosophy
   - [ ] Centered layout, Paper White background, dark gray text
   - [ ] Chancellor character (illustration) visible at bottom-right corner

2. **Navigation**
   - [ ] Single button: "GET STARTED" (teal, all caps)
   - [ ] Tap → Proceed to Base Language Selection (WL-011)
   - [ ] Button disabled until text fully loaded (animation complete)

3. **Visual Polish**
   - [ ] Text fade-in animation (typewriter effect, 2 seconds)
   - [ ] Chancellor illustration fade-in (500ms after text)
   - [ ] No background music / sound effects
   - [ ] Accessible to screen readers

### Developer Tasks

```
Task 1: Design Welcome Screen UI
- [ ] Create layout (headline, body, button, character)
- [ ] Apply typography per Design System (Futura display, Helvetica body)
- [ ] Align to 8px grid
- [ ] Test on 3 device sizes
- [ ] Time estimate: 2 hours

Task 2: Implement Text Animation
- [ ] Typewriter effect (character-by-character reveal)
- [ ] Duration: 2 seconds total
- [ ] Smooth fade-in (ease-in curve)
- [ ] Unit tests for animation timing
- [ ] Time estimate: 2 hours

Task 3: Load Chancellor Character
- [ ] Import Ligne Claire illustration as SVG
- [ ] Position at bottom-right (responsive)
- [ ] Fade-in animation (500ms)
- [ ] Verify renders crisply on high-DPI displays
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Manual QA on iOS + Android
- [ ] Test animation smoothness (no jank)
- [ ] Test accessibility (VoiceOver, TalkBack)
- [ ] Time estimate: 1 hour
```

---

## WL-011: Base Language Selection

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 3 points  
**Dependencies:** WL-010  

### User Story
As a **new user**, I want to **select my base language (L1)**, so that **the app knows what language I'm fluent in**.

### Acceptance Criteria

1. **Language Selection Screen**
   - [ ] Title: "Select Your Base Language"
   - [ ] Subtitle: "What language do you speak natively?"
   - [ ] Display list of 6 base language options:
     - [ ] English (default, pre-selected)
     - [ ] German
     - [ ] French
     - [ ] Spanish
     - [ ] Italian
     - [ ] Turkish
   - [ ] Each language shown with flag emoji + language name
   - [ ] Current selection highlighted (teal border, filled)
   - [ ] Only 1 language can be selected

2. **Next Button**
   - [ ] "NEXT" button enabled once a language selected
   - [ ] Tap → Proceed to Target Language Selection (WL-012)

3. **Navigation**
   - [ ] Back button → Return to Welcome (WL-010)

### Developer Tasks

```
Task 1: Build Language Selection UI
- [ ] Create list view (6 items)
- [ ] Style selection state (teal border, filled background)
- [ ] Add flag emojis for visual appeal
- [ ] Responsive layout (works on small screens)
- [ ] Time estimate: 2 hours

Task 2: Implement Selection Logic
- [ ] Riverpod provider for selected base language
- [ ] Single-select radio button logic
- [ ] Enable NEXT button only when selected
- [ ] Time estimate: 1 hour

Task 3: Navigation
- [ ] Back button → Return to Welcome
- [ ] NEXT button → Proceed to Target Language (WL-012)
- [ ] Store selection in app state (Riverpod)
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Verify only 1 language selectable
- [ ] Verify NEXT button enable/disable states
- [ ] Test navigation (back + forward)
- [ ] Time estimate: 1 hour
```

---

## WL-012: Target Language Selection (Multi-Select)

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 4 points  
**Dependencies:** WL-011  

### User Story
As a **new user**, I want to **select 1–6 target languages to learn**, so that **I can learn multiple languages simultaneously with independent tracking**.

### Acceptance Criteria

1. **Target Language Selection Screen**
   - [ ] Title: "Select Target Languages"
   - [ ] Subtitle: "What languages do you want to learn? (1–6)"
   - [ ] Display 6 language options:
     - [ ] English, German, French, Spanish, Italian, Turkish
   - [ ] Exclude base language from selection (grayed out with "Already selected" label)
   - [ ] Each language has checkbox (not radio) for multi-select
   - [ ] Selected languages highlighted (teal filled checkbox, solid bg)

2. **Selection Rules**
   - [ ] Min 1 language required
   - [ ] Max 6 languages allowed
   - [ ] When max reached → Gray out remaining unselected languages
   - [ ] Show counter: "Selected: X/6"

3. **Next Button**
   - [ ] "NEXT" button enabled once 1+ language selected
   - [ ] Tap → Proceed to CEFR Level Selection (WL-013)

4. **Error Messaging**
   - [ ] If user tries to select 7th language → Tooltip: "Max 6 languages. Remove one to add another."

### Developer Tasks

```
Task 1: Build Multi-Select Language UI
- [ ] Create list view with checkboxes
- [ ] Apply selected/unselected styling
- [ ] Disable base language (prevent selection)
- [ ] Disable unselected when max reached
- [ ] Show counter (Selected: X/6)
- [ ] Time estimate: 3 hours

Task 2: Implement Selection Logic
- [ ] Riverpod provider for selected target languages (list)
- [ ] Multi-select logic (add/remove from list)
- [ ] Max 6 languages enforcement
- [ ] Enable NEXT only when 1+ selected
- [ ] Time estimate: 2 hours

Task 3: Navigation
- [ ] Back → Return to Base Language (WL-011)
- [ ] NEXT → Proceed to CEFR Selection (WL-013)
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Test multi-select (add/remove languages)
- [ ] Test max limit (6 languages)
- [ ] Test error message on max
- [ ] Test NEXT enable/disable
- [ ] Time estimate: 2 hours
```

---

## WL-013: CEFR Level Selection (Per Language)

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 4 points  
**Dependencies:** WL-012  

### User Story
As a **new user**, I want to **select my proficiency level for each target language**, so that **the app recommends appropriate vocabulary (A1–C2)**.

### Acceptance Criteria

1. **CEFR Selection Screen**
   - [ ] Title: "Select Your Proficiency Level"
   - [ ] Subtitle: "For each language, where are you?"
   - [ ] Display vertical stack of target languages (WL-012 selection)
   - [ ] For each language, show dropdown or radio group:
     - [ ] A1 (Breakthrough) - Absolute beginner
     - [ ] A2 (Elementary) - Basic phrases
     - [ ] B1 (Intermediate) - Conversational
     - [ ] B2 (Upper-Intermediate) - Professional
     - [ ] C1 (Advanced) - Near-native
     - [ ] C2 (Mastery) - Native-like

2. **Default Selection**
   - [ ] First language defaults to B1 (intermediate focus)
   - [ ] Other languages also default to B1
   - [ ] User can override per language

3. **Visual Design**
   - [ ] Each language row: [Language Name] [CEFR Dropdown]
   - [ ] Dropdown shows current selection
   - [ ] Tap dropdown → Expand options
   - [ ] Select option → Collapse

4. **Next Button**
   - [ ] "NEXT" button enabled once all languages have CEFR level
   - [ ] Tap → Proceed to Curfew Setup (WL-014)

### Developer Tasks

```
Task 1: Design CEFR Selection UI
- [ ] Create list of (language, cefr_level) rows
- [ ] Build dropdown component
- [ ] Style selections per Design System
- [ ] Responsive layout
- [ ] Time estimate: 3 hours

Task 2: Implement CEFR Selection Logic
- [ ] Riverpod provider for CEFR levels per language (map)
- [ ] Dropdown state management
- [ ] Default B1 for all languages
- [ ] Allow per-language override
- [ ] Enable NEXT only when all have selection
- [ ] Time estimate: 2 hours

Task 3: Validation & Navigation
- [ ] Validate all languages have CEFR level
- [ ] Back → Return to Target Language (WL-012)
- [ ] NEXT → Proceed to Curfew (WL-014)
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Test dropdown expand/collapse
- [ ] Test CEFR selection per language
- [ ] Test NEXT enable/disable
- [ ] Test navigation (back + forward)
- [ ] Time estimate: 2 hours
```

---

## WL-014: Daily Curfew Setup

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 3 points  
**Dependencies:** WL-013  

### User Story
As a **new user**, I want to **set my daily study deadline (Curfew)**, so that **I establish a daily discipline boundary**.

### Acceptance Criteria

1. **Curfew Setup Screen**
   - [ ] Title: "When's Your Daily Deadline?"
   - [ ] Subtitle: "Choose wisely. This is when the Ice State begins."
   - [ ] Time picker (default: 22:00 / 10 PM)
   - [ ] Display format: HH:MM (24-hour)
   - [ ] Show selected time prominently

2. **Warning Message**
   - [ ] Display below time picker:
     - "Missing your Curfew burns your streak to Ash. There are no freezes. Only consistency."
   - [ ] Text color: Warning orange (#F57C00)
   - [ ] No aggressive styling (stays calm)

3. **Time Picker Interaction**
   - [ ] Tap time → Open native time picker
   - [ ] Select new time → Update display
   - [ ] Support manual entry (HH:MM format)

4. **Next Button**
   - [ ] "I ACCEPT" button (primary CTA)
   - [ ] Enabled always (Curfew required)
   - [ ] Tap → Proceed to Daily Drip Setup (WL-015)

### Developer Tasks

```
Task 1: Design Curfew Selection UI
- [ ] Create time picker component
- [ ] Display selected time (HH:MM format)
- [ ] Show warning message
- [ ] Responsive design
- [ ] Time estimate: 2 hours

Task 2: Implement Time Picker Logic
- [ ] Flutter time picker integration (native picker)
- [ ] Riverpod provider for selected curfew time
- [ ] Default to 22:00
- [ ] Support manual entry
- [ ] Validate time format (00:00 - 23:59)
- [ ] Time estimate: 2 hours

Task 3: User's Timezone Handling
- [ ] Get device timezone (from system)
- [ ] Convert to UTC for server storage
- [ ] Display time in user's local time
- [ ] Unit tests for timezone conversion
- [ ] Time estimate: 2 hours

Task 4: Navigation & Testing
- [ ] Back → Return to CEFR Selection (WL-013)
- [ ] I ACCEPT → Proceed to Daily Drip (WL-015)
- [ ] Manual QA on iOS + Android
- [ ] Test time picker on different devices
- [ ] Time estimate: 2 hours
```

---

## WL-015: Daily Drip Configuration

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 3 points  
**Dependencies:** WL-014  

### User Story
As a **new user**, I want to **set how many new words to learn daily**, so that **I control my learning pace**.

### Acceptance Criteria

1. **Drip Configuration Screen**
   - [ ] Title: "How Many Words Per Day?"
   - [ ] Subtitle: "New words to learn. (You'll also review existing words.)"
   - [ ] Slider: 5–40 words/day (default: 20)
   - [ ] Display selected value prominently (e.g., "20 words/day")
   - [ ] Slider has tick marks at 5, 10, 15, 20, 25, 30, 35, 40

2. **Slider Interaction**
   - [ ] Drag slider left/right → Update value
   - [ ] Value updates in real-time
   - [ ] Show tooltip above slider (current value)

3. **Info Message**
   - [ ] Display note: "Recommendation: 20 words/day. Adjust anytime in Settings."

4. **Button**
   - [ ] "START LEARNING" button (primary, teal)
   - [ ] Enabled always
   - [ ] Tap → Check subscription status (WL-016)

### Developer Tasks

```
Task 1: Design Drip Slider UI
- [ ] Create slider widget (5–40 range)
- [ ] Add tick marks + labels
- [ ] Display current value prominently
- [ ] Show info message
- [ ] Responsive layout
- [ ] Time estimate: 2 hours

Task 2: Implement Slider Logic
- [ ] Riverpod provider for daily drip count
- [ ] Min 5, max 40, default 20
- [ ] Real-time value updates (no debounce needed)
- [ ] Tooltip showing current value
- [ ] Time estimate: 1 hour

Task 3: Navigation
- [ ] Back → Return to Curfew Setup (WL-014)
- [ ] START LEARNING → Check subscription (WL-016)
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Test slider range (5–40)
- [ ] Test value updates in real-time
- [ ] Test navigation
- [ ] Manual QA on iOS + Android
- [ ] Time estimate: 1 hour
```

---

## WL-016: Subscription Paywall (Free vs. Paid)

**Story Type:** Feature  
**Priority:** P0 (Critical - Monetization)  
**Effort:** 6 points  
**Dependencies:** WL-001 to WL-015  

### User Story
As a **new user**, I want to **choose between free and paid subscription tiers**, so that **I can unlock multi-language learning if I want**.

### Acceptance Criteria

1. **Paywall Screen Display**
   - [ ] Title: "Unlock Unlimited Languages"
   - [ ] Subtitle: "Free tier: 1 language. Paid: Up to 6."
   - [ ] Display 3 tier cards in vertical stack:
     - **Free:** $0, 1 language, limited features
     - **Monthly:** $9.99/month, unlimited languages
     - **6-Month:** $49.99 (one-time), unlimited languages

2. **Tier Card Design**
   - [ ] Each card displays:
     - [ ] Tier name (FREE, MONTHLY, 6-MONTH)
     - [ ] Price + billing period
     - [ ] Feature list (bullet points)
     - [ ] CTA button (TRY FREE or SUBSCRIBE)
   - [ ] Recommended tier (6-Month) has highlighted border (teal)
   - [ ] Free tier has muted styling (gray)

3. **Subscription Logic**
   - [ ] Free → Tap "TRY FREE" → Proceed to Home (limited 1 language)
   - [ ] Monthly → Tap "SUBSCRIBE" → Launch App Store / Play Store receipt flow
   - [ ] 6-Month → Tap "SUBSCRIBE" → Launch App Store / Play Store receipt flow
   - [ ] On successful purchase → Verify receipt (WL-300) → Update entitlements → Proceed to Home

4. **Links**
   - [ ] Bottom: "Privacy Policy" + "Terms of Service" links
   - [ ] Tappable, styled as hyperlinks (teal, underlined)

5. **Error Handling**
   - [ ] Purchase cancelled by user → Return to paywall (no error)
   - [ ] Network error during purchase → "Purchase failed. Check connection."
   - [ ] Receipt validation fails → "Purchase not verified. Try again."

### Developer Tasks

```
Task 1: Design Paywall UI
- [ ] Create 3-tier card layout
- [ ] Style each tier (FREE muted, others highlighted)
- [ ] Add feature lists + buttons
- [ ] Responsive design (small screens)
- [ ] Time estimate: 3 hours

Task 2: Implement Subscription Selection Logic
- [ ] Free tier selection → Set subscription_tier='free'
- [ ] Monthly/6-Month → Launch IAP flow (WL-300)
- [ ] Riverpod provider for selected tier
- [ ] Time estimate: 2 hours

Task 3: Integrate In-App Purchase (IAP)
- [ ] iOS: in_app_purchase package
- [ ] Android: in_app_purchase package
- [ ] Configure product IDs (monthly, sixmonth)
- [ ] Launch purchase flow on button tap
- [ ] Handle purchase completion callback
- [ ] Time estimate: 4 hours

Task 4: Error Handling & Testing
- [ ] Test free tier selection → Proceed to Home
- [ ] Test purchase flow (iOS + Android)
- [ ] Test purchase cancellation
- [ ] Test network errors
- [ ] Manual QA on real devices
- [ ] Time estimate: 3 hours
```

---

# EPIC 3: CORE STUDY LOOP

## WL-050: Daily Session Initialization

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 4 points  
**Dependencies:** WL-001 to WL-016  

### User Story
As a **user**, I want to **open the app and see my daily study goals**, so that **I know what to study today**.

### Acceptance Criteria

1. **Home Screen (Session Start)**
   - [ ] Display user's first name (or "Scholar" if not set)
   - [ ] Greeting: "Welcome back, [Name]"
   - [ ] Display today's stats:
     - [ ] "X words due for review"
     - [ ] "Y new words today"
     - [ ] "Streak: Z days"
   - [ ] Display "Curfew: 22:00" (user's set time)
   - [ ] Primary button: "START SESSION"

2. **Multi-Language Support**
   - [ ] If user has multiple languages:
     - [ ] Show dropdown/selector for language
     - [ ] OR show "MULTI-LANGUAGE" button (study all languages mixed)
     - [ ] Display stats per language (if individual language selected)

3. **Session Prep**
   - [ ] On app startup → Calculate due reviews (SRS scheduling)
   - [ ] Load active batch from local SQLite
   - [ ] Randomize card order for this session
   - [ ] Prepare ~20–40 flashcards for today

4. **Error Handling**
   - [ ] If no words due → "No reviews today. Relax and come back tomorrow."
   - [ ] If database corrupted → "Data error. Please contact support."

### Developer Tasks

```
Task 1: Build Home Screen UI
- [ ] Create layout (greeting, stats, buttons)
- [ ] Display user name (from profile)
- [ ] Show streak count prominently
- [ ] Language selector / Multi-language toggle
- [ ] Style per Design System
- [ ] Time estimate: 2 hours

Task 2: Implement Daily Stats Calculation
- [ ] Riverpod provider for daily stats
- [ ] Query SQLite active_batch for SRS schedule
- [ ] Count words with next_review_date <= today
- [ ] Count new words (daily drip)
- [ ] Handle multi-language stats
- [ ] Time estimate: 2 hours

Task 3: Session Preparation
- [ ] On "START SESSION" → Load active batch for selected language
- [ ] Shuffle card order (Fisher-Yates shuffle)
- [ ] Create session_id (UUID)
- [ ] Store session metadata (start time, language pair, etc.)
- [ ] Time estimate: 2 hours

Task 4: Testing
- [ ] Test stats calculation (various SRS states)
- [ ] Test multi-language stats
- [ ] Test no-words-due state
- [ ] Test session shuffle (verify randomization)
- [ ] Unit + integration tests
- [ ] Time estimate: 2 hours
```

---

## WL-060: Flashcard Display & Reveal

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 5 points  
**Dependencies:** WL-050  

### User Story
As a **user**, I want to **see a flashcard with the target word**, so that **I can attempt recall before seeing the translation**.

### Acceptance Criteria

1. **Flashcard Front**
   - [ ] Display target language word (large, 32px, Futura bold)
   - [ ] Display IPA pronunciation (smaller, gray text)
   - [ ] Display Ligne Claire illustration (180×180px)
   - [ ] Centered layout, Paper White background
   - [ ] Light gray border (1px)

2. **Reveal Flow**
   - [ ] User taps card (or swipes down) → Flip animation (200ms)
   - [ ] Back shows translation + example sentence
   - [ ] Translation in bold (user's base language)
   - [ ] Example sentence (italicized, original language)
   - [ ] Example translation (below, gray text)

3. **Card Animation**
   - [ ] Flip is smooth (3D perspective, no jank)
   - [ ] No excessive rotation (professional, subtle)
   - [ ] After flip → Display difficulty buttons (WL-070)

4. **Navigation**
   - [ ] User cannot skip cards (no swipe left/right)
   - [ ] Cannot see next card until rating difficulty

### Developer Tasks

```
Task 1: Design Flashcard UI
- [ ] Create card layout (front + back templates)
- [ ] Front: Word + pronunciation + image
- [ ] Back: Translation + examples
- [ ] Apply Design System typography + spacing
- [ ] Test on various screen sizes
- [ ] Time estimate: 3 hours

Task 2: Implement Card Flip Animation
- [ ] Use Flutter Transform + AnimationController
- [ ] Flip duration: 200ms
- [ ] Smooth easing (ease-in-out)
- [ ] Verify no jank on older devices
- [ ] Time estimate: 2 hours

Task 3: Load Card Data
- [ ] Query SQLite for current flashcard
- [ ] Fetch translation + example from master vocabulary
- [ ] Handle image + audio asset loading
- [ ] Display IPA pronunciation (if available)
- [ ] Time estimate: 2 hours

Task 4: Testing & Polish
- [ ] Test flip animation smoothness (60 FPS)
- [ ] Test on iPhone SE + Pixel 4
- [ ] Verify images load crisply
- [ ] Manual QA
- [ ] Time estimate: 2 hours
```

---

## WL-070: Difficulty Rating & Review Submission

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 4 points  
**Dependencies:** WL-060  

### User Story
As a **user**, I want to **rate how difficult the word was to recall**, so that **the app adjusts my review schedule (SM-2 algorithm)**.

### Acceptance Criteria

1. **Difficulty Rating Buttons**
   - [ ] After card flip, display 4 buttons in horizontal row:
     - [ ] "HARD" (left) - Could not recall, show on next review
     - [ ] "FAMILIAR" (left-center) - Somewhat familiar, needs work
     - [ ] "OK" (right-center) - Recalled correctly, medium time
     - [ ] "EASY" (right) - Recalled instantly and confidently
   - [ ] Each button: 64px wide × 48px tall (touch-friendly)
   - [ ] Unselected: Light gray border, dark text
   - [ ] Selected (hover): Teal background, white text
   - [ ] Disabled after selection (prevent double-tap)

2. **Selection Feedback**
   - [ ] On tap → Button highlights
   - [ ] Brief loading spinner (while submitting)
   - [ ] On success → Next card appears (auto-transition, 300ms delay)

3. **SRS Update (Backend)**
   - [ ] On selection → POST /api/v1/user/reviews with:
     - [ ] vocabulary_id
     - [ ] language_pair
     - [ ] difficulty_rating (hard, familiar, ok, easy)
     - [ ] time_to_answer_seconds
     - [ ] session_id
   - [ ] Server calculates new SM-2 state (ease_factor, interval)
   - [ ] Returns updated interval + next_review_date

4. **Counter Display**
   - [ ] Show progress: "Card X of Y" (top of screen)
   - [ ] Update after each submission

### Developer Tasks

```
Task 1: Build Difficulty Rating UI
- [ ] Create 4-button row layout
- [ ] Style buttons per Design System
- [ ] Implement tap states (selected, disabled)
- [ ] Add progress counter (X of Y)
- [ ] Time estimate: 2 hours

Task 2: Implement Rating Logic
- [ ] Capture difficulty selection (Riverpod state)
- [ ] Timer for time_to_answer_seconds (track card reveal to submission)
- [ ] Disable buttons after selection
- [ ] Show loading spinner during API call
- [ ] Time estimate: 2 hours

Task 3: Submit Review to Server
- [ ] POST /api/v1/user/reviews (Dio)
- [ ] Include all required metadata
- [ ] Handle response (new SRS state)
- [ ] Update local SQLite with new state
- [ ] Time estimate: 2 hours

Task 4: Error Handling & Testing
- [ ] Network error → "Failed to submit. Retry?"
- [ ] Server error → "Error updating progress. Try again."
- [ ] Test submission success + local DB update
- [ ] Verify next card appears after success
- [ ] Time estimate: 2 hours
```

---

## WL-075: Session Completion & Streak Preservation

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP blocker)  
**Effort:** 4 points  
**Dependencies:** WL-070  

### User Story
As a **user**, I want to **complete my study session and preserve my streak**, so that **my daily discipline is recognized**.

### Acceptance Criteria

1. **Session Completion**
   - [ ] Last flashcard submitted → "Session Complete" screen
   - [ ] Display summary:
     - [ ] "X words reviewed"
     - [ ] "Y words mastered"
     - [ ] "Streak: Z days" (updated, highlighted)
   - [ ] Button: "CONTINUE" (go to Home)
   - [ ] Button: "VIEW STATS" (detailed breakdown, Phase 2)

2. **Streak Preservation**
   - [ ] Session completion triggers:
     - [ ] Server-side streak check (via Curfew verification)
     - [ ] If before Curfew (UTC) → Increment streak
     - [ ] If after Curfew → Trigger Ash Protocol (WL-120)
   - [ ] Updated streak_count returned to app
   - [ ] Display new streak prominently

3. **Milestone Check**
   - [ ] Every 50 words mastered → Trigger Intelligence Report (Phase 2)
   - [ ] Display notification: "Milestone: 50 words mastered! View report."

4. **Error Handling**
   - [ ] Network error during completion → "Failed to finalize session. Retry?"
   - [ ] Offline session → Store locally, sync when online

### Developer Tasks

```
Task 1: Build Session Completion UI
- [ ] Create summary screen
- [ ] Display stats (reviewed, mastered, streak)
- [ ] Highlight streak (green color, larger font)
- [ ] Add buttons (CONTINUE, VIEW STATS)
- [ ] Time estimate: 2 hours

Task 2: Implement Session Finalization
- [ ] Count total reviews + mastered words
- [ ] Prepare session completion payload
- [ ] POST /api/v1/user/sessions/complete
- [ ] Include all review data
- [ ] Time estimate: 2 hours

Task 3: Streak Update Logic
- [ ] Receive updated streak_count from server
- [ ] Update local Riverpod state
- [ ] Display new streak in summary
- [ ] Check if milestone reached (50-word marks)
- [ ] Time estimate: 2 hours

Task 4: Testing & Error Handling
- [ ] Test session completion success
- [ ] Test streak increment
- [ ] Test milestone detection
- [ ] Test network errors + offline fallback
- [ ] Time estimate: 2 hours
```

---

# EPIC 4: ACTIVE BATCH MANAGEMENT

## WL-140: Active Batch Status & Word List

**Story Type:** Feature  
**Priority:** P1  
**Effort:** 3 points  
**Dependencies:** WL-050  

### User Story
As a **user**, I want to **see my current Active Batch (all 200 words)**, so that **I understand what I'm currently learning**.

### Acceptance Criteria

1. **Active Batch Screen**
   - [ ] Accessible from Home → "VIEW BATCH" button (or "Batch" tab)
   - [ ] Display list of current words in Active Batch
   - [ ] For each word, show:
     - [ ] Word (target language)
     - [ ] Translation (base language)
     - [ ] SRS state (next review date)
     - [ ] Difficulty indicator (color: green=easy, orange=medium, red=hard)
   - [ ] Total: "156 / 200 words"

2. **Sorting & Filtering**
   - [ ] Sort options:
     - [ ] By next review date (default - "Due first")
     - [ ] By difficulty ("Hard first")
     - [ ] By date added ("Oldest first")
   - [ ] Filter by language pair (if multi-language)

3. **Word Actions**
   - [ ] Tap word → View details:
     - [ ] Full translation
     - [ ] Example sentence
     - [ ] Illustration
     - [ ] Audio pronunciation
   - [ ] Long-press → Options:
     - [ ] "Mark as Easy" (move to Vault manually)
     - [ ] "Remove from Batch" (requires confirmation)

### Developer Tasks

```
Task 1: Design Batch List UI
- [ ] Create word list layout
- [ ] Display word + translation + SRS state
- [ ] Add difficulty color indicators
- [ ] Show batch count (X / 200)
- [ ] Time estimate: 2 hours

Task 2: Implement Data Query
- [ ] Query SQLite active_batch table
- [ ] Sort by next_review_date
- [ ] Calculate difficulty color (based on ease_factor)
- [ ] Implement sorting options
- [ ] Time estimate: 2 hours

Task 3: Word Details & Actions
- [ ] Tap word → Show detail modal
- [ ] Implement long-press menu
- [ ] "Mark as Easy" → Move to Vault
- [ ] "Remove" → Delete from batch (confirm dialog)
- [ ] Time estimate: 2 hours

Task 4: Testing
- [ ] Test list rendering (200 words)
- [ ] Test sorting (verify order changes)
- [ ] Test word detail modal
- [ ] Test batch count update
- [ ] Time estimate: 1 hour
```

---

## WL-150: Daily Drip (New Words Injection)

**Story Type:** Feature  
**Priority:** P0  
**Effort:** 3 points  
**Dependencies:** WL-140  

### User Story
As **the system**, I want to **inject new words into the Active Batch daily**, so that **users progress through the curriculum at their chosen pace**.

### Acceptance Criteria

1. **Daily Drip Trigger**
   - [ ] On app startup (after midnight, UTC):
     - [ ] Check if new words already added today (flag: last_drip_date)
     - [ ] If not → Execute drip
   - [ ] Manual sync: User can force drip via Settings → "Sync Now"

2. **Drip Logic**
   - [ ] Count current batch size (e.g., 156 words)
   - [ ] Calculate slots available (200 - 156 = 44 slots)
   - [ ] Drip count = user's daily_drip_count (default: 20)
   - [ ] Select 20 random words from next CEFR level (local master vocabulary)
   - [ ] Add to active_batch table
   - [ ] Update last_drip_date to today

3. **Handling Edge Cases**
   - [ ] If no slots available → Skip drip, show message:
     - "Batch full (200/200). Master 1 word to add new word."
   - [ ] If not enough words in next CEFR level → Drip fewer words
   - [ ] If no next level (already at C2) → Skip drip

4. **User Notification**
   - [ ] After successful drip → Show toast: "20 new words added today."
   - [ ] Notification appears on Home screen (temporary)

### Developer Tasks

```
Task 1: Implement Drip Logic
- [ ] Query active_batch count per language pair
- [ ] Calculate available slots (200 - current)
- [ ] Check last_drip_date (prevent double-drip)
- [ ] Get user's daily_drip_count setting
- [ ] Time estimate: 2 hours

Task 2: Select New Words
- [ ] Query master_vocabulary (local SQLite)
- [ ] Filter by next CEFR level
- [ ] Random selection (Fisher-Yates or SQL ORDER BY RANDOM())
- [ ] Insert into active_batch
- [ ] Update last_drip_date
- [ ] Time estimate: 2 hours

Task 3: Trigger Drip
- [ ] On app startup → Check drip eligibility
- [ ] Implement background drip (if app doesn't open)
- [ ] Manual sync button in Settings
- [ ] Time estimate: 2 hours

Task 4: Testing & Error Handling
- [ ] Test drip execution (verify words added)
- [ ] Test full batch scenario (no drip)
- [ ] Test multiple language pairs (independent drips)
- [ ] Test manual sync
- [ ] Time estimate: 2 hours
```

---

## WL-160: Batch Capacity Management (200-Word Limit)

**Story Type:** Feature  
**Priority:** P0  
**Effort:** 2 points  
**Dependencies:** WL-140, WL-150  

### User Story
As **the system**, I want to **enforce the 200-word Active Batch limit**, so that **users practice deep learning instead of surface-level skimming**.

### Acceptance Criteria

1. **Batch Capacity Enforcement**
   - [ ] SQLite constraint: Max 200 words per (user_id, language_pair)
   - [ ] Trigger on INSERT: If count > 200 → REJECT

2. **User Messaging**
   - [ ] If user tries to add 201st word (manual injection, Phase 2):
     - [ ] Modal: "Batch full (200/200)."
     - [ ] Subtitle: "Master 1 word to add new word."
     - [ ] Button: "VIEW WORDS TO MASTER"
     - [ ] Tap → Sort batch by ease_factor (high-ease words first)

3. **Batch Management**
   - [ ] User can manually move words to Vault (WL-170)
   - [ ] User can remove words (with confirm dialog)
   - [ ] Each action frees a slot in batch

### Developer Tasks

```
Task 1: Add Database Constraint
- [ ] Create trigger in SQLite:
     CREATE TRIGGER limit_batch_size
     BEFORE INSERT ON active_batch
     BEGIN
       SELECT RAISE(ABORT, 'Batch full')
       WHERE (SELECT COUNT(*) FROM active_batch
              WHERE user_id = NEW.user_id
              AND language_pair = NEW.language_pair) >= 200;
     END
- [ ] Test constraint in dev environment
- [ ] Time estimate: 1 hour

Task 2: Implement Batch Full UI
- [ ] Create modal component
- [ ] Add "VIEW WORDS TO MASTER" button
- [ ] Link to sorted batch view
- [ ] Time estimate: 1 hour

Task 3: User Interaction
- [ ] When batch full → Show modal
- [ ] Allow manual Vault move (WL-170)
- [ ] Allow word removal (confirm)
- [ ] Verify slots freed after actions
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Test 200-word limit enforcement
- [ ] Test manual word removal + vault move
- [ ] Test slot availability after removal
- [ ] Time estimate: 1 hour
```

---

# EPIC 5: THE VAULT (MASTERED WORDS)

## WL-170: Move Words to Vault (Manual Graduation)

**Story Type:** Feature  
**Priority:** P0  
**Effort:** 3 points  
**Dependencies:** WL-140  

### User Story
As a **user**, I want to **manually move mastered words to the Vault**, so that **I free up slots in my Active Batch for new words**.

### Acceptance Criteria

1. **Vault Movement Criteria**
   - [ ] Word must meet criteria:
     - [ ] ease_factor ≥ 2.0 (high retention confidence)
     - [ ] Last reviewed ≥ 7 days ago
     - [ ] At least 2 reviews completed
   - [ ] UI shows "eligible" words only (green highlight)
   - [ ] Ineligible words show lock icon + reason (gray)

2. **Manual Move Action**
   - [ ] Batch view (WL-140) → Long-press word → "Move to Vault"
   - [ ] Confirm dialog: "Move [word] to Vault? This will free a slot."
   - [ ] On confirm:
     - [ ] Update active_batch.moved_to_vault = true
     - [ ] Insert into vault table
     - [ ] Calculate milestone (every 50 words)
   - [ ] Toast: "[Word] moved to Vault. Slot freed!"

3. **Milestone Celebration**
   - [ ] Every 50 words → Show milestone modal:
     - [ ] "50 Words Mastered!"
     - [ ] Display all 50 mastered words (brief list)
     - [ ] Button: "VIEW REPORT" (Phase 2 - Intelligence Report)
     - [ ] Button: "CONTINUE"

### Developer Tasks

```
Task 1: Determine Vault Eligibility
- [ ] Query active_batch for words meeting criteria
- [ ] ease_factor ≥ 2.0
- [ ] last_reviewed_at ≤ today - 7 days
- [ ] repetitions ≥ 2
- [ ] Mark eligible words in UI (highlight)
- [ ] Time estimate: 2 hours

Task 2: Implement Move to Vault
- [ ] Long-press action on word (WL-140)
- [ ] Show confirm dialog
- [ ] UPDATE active_batch (set status = 'vault')
- [ ] INSERT into vault table
- [ ] Update batch count
- [ ] Time estimate: 2 hours

Task 3: Milestone Detection & Celebration
- [ ] After each vault move → Check milestone
- [ ] If vaulted_count % 50 == 0 → Show modal
- [ ] Display count + list of 50 words
- [ ] Link to Intelligence Report (if available, Phase 2)
- [ ] Time estimate: 2 hours

Task 4: Testing
- [ ] Test eligibility criteria (various states)
- [ ] Test manual move action
- [ ] Test milestone detection (50, 100, 150...)
- [ ] Test batch count updates
- [ ] Time estimate: 1 hour
```

---

## WL-180: View Vault & Mastered Words

**Story Type:** Feature  
**Priority:** P1  
**Effort:** 2 points  
**Dependencies:** WL-170  

### User Story
As a **user**, I want to **view all my mastered words in the Vault**, so that **I can review my long-term progress and revisit archived words**.

### Acceptance Criteria

1. **Vault Screen**
   - [ ] Accessible from bottom nav: "VAULT" tab
   - [ ] Display list of all vaulted words
   - [ ] For each word, show:
     - [ ] Word + translation
     - [ ] Date mastered
     - [ ] Next audit date (if applicable)
   - [ ] Total count: "X words mastered"

2. **Sorting & Filtering**
   - [ ] Sort by mastery date (default: oldest first)
   - [ ] Filter by language pair (if multi-language)
   - [ ] Search by word (text input, fuzzy matching)

3. **Word Details & Actions**
   - [ ] Tap word → Show details:
     - [ ] Translation
     - [ ] Example sentence
     - [ ] Mastery date
     - [ ] Next audit date
   - [ ] Button: "RE-REVIEW NOW" (manually trigger re-validation)
   - [ ] Button: "MOVE BACK TO BATCH" (restore to active learning)

### Developer Tasks

```
Task 1: Design Vault Screen
- [ ] Create word list view
- [ ] Display word + translation + dates
- [ ] Add search bar
- [ ] Show total count
- [ ] Time estimate: 2 hours

Task 2: Query & Display Vaulted Words
- [ ] Query vault table
- [ ] Sort by mastered_at date
- [ ] Implement search (fuzzy matching)
- [ ] Time estimate: 2 hours

Task 3: Word Details & Actions
- [ ] Tap word → Modal with full details
- [ ] "RE-REVIEW" → Trigger vault audit (WL-190)
- [ ] "MOVE BACK" → Return to active_batch
- [ ] Confirm dialog for back-move
- [ ] Time estimate: 2 hours

Task 4: Testing
- [ ] Test vault list rendering
- [ ] Test search functionality
- [ ] Test word detail modal
- [ ] Test move back action
- [ ] Time estimate: 1 hour
```

---

## WL-190: Vault Audit & Re-Validation (Quarterly)

**Story Type:** Feature  
**Priority:** P2  
**Effort:** 4 points  
**Dependencies:** WL-180  

### User Story
As **the system**, I want to **periodically re-validate mastered words**, so that **users maintain long-term retention and prevent "Vault decay"**.

### Acceptance Criteria

1. **Audit Scheduling**
   - [ ] Quarterly intervals: 3 months, 6 months, 1 year after vault entry
   - [ ] On app startup → Check if audit due
   - [ ] If due → Show banner: "Vault audit available. 5 words to review."
   - [ ] User can manually trigger anytime (WL-180)

2. **Audit Session**
   - [ ] Display 5 random vault words
   - [ ] Flashcard format (same as study session, WL-060)
   - [ ] User rates difficulty (HARD, FAMILIAR, OK, EASY)
   - [ ] If passed (OK or EASY):
     - [ ] Word stays in Vault
     - [ ] audit_date reset to today
     - [ ] next_audit_date = today + 3 months
   - [ ] If failed (HARD or FAMILIAR):
     - [ ] Word returned to active_batch
     - [ ] Reset to new word (ease_factor = 2.5, interval = 1)
     - [ ] Toast: "[Word] returned to Active Batch."

3. **Audit Completion**
   - [ ] After all 5 words audited → Summary screen:
     - [ ] "Audit Complete!"
     - [ ] "X/5 words passed"
     - [ ] "Next audit: [DATE]"

### Developer Tasks

```
Task 1: Schedule Audit Detection
- [ ] On app startup → Query vault
- [ ] Find words with next_audit_date <= today
- [ ] If any found → Show banner
- [ ] User can dismiss or start audit
- [ ] Time estimate: 2 hours

Task 2: Implement Audit Session
- [ ] Select 5 random vault words
- [ ] Display flashcards (reuse WL-060 component)
- [ ] Capture difficulty ratings
- [ ] Submit reviews to server
- [ ] Time estimate: 2 hours

Task 3: Update Vault State
- [ ] On passed word → Update audit_date + next_audit_date
- [ ] On failed word → Move back to active_batch
- [ ] Reset SRS state for failed words
- [ ] Update vault metadata
- [ ] Time estimate: 2 hours

Task 4: Testing & Error Handling
- [ ] Test audit scheduling (various dates)
- [ ] Test passed/failed outcomes
- [ ] Test vault state updates
- [ ] Test manual trigger (WL-180)
- [ ] Time estimate: 2 hours
```

---

# EPIC 6: CURFEW & ACCOUNTABILITY (THE ASH PROTOCOL)

## WL-200: The Curfew (Daily Deadline Enforcement)

**Story Type:** Feature  
**Priority:** P0 (Critical - Core Philosophy)  
**Effort:** 4 points  
**Dependencies:** WL-050 to WL-100  

### User Story
As **the system**, I want to **enforce a daily study deadline (Curfew)**, so that **users build genuine discipline and commitment**.

### Acceptance Criteria

1. **Curfew Display**
   - [ ] Home screen shows: "Curfew: 22:00"
   - [ ] Session completion shows time remaining: "Complete by 22:00"
   - [ ] After session complete → "Streak preserved. Curfew: 22:00"

2. **Curfew Verification (Server-Side)**
   - [ ] Session completion (WL-075) triggers server check:
     - [ ] GET user's Curfew time (UTC)
     - [ ] Compare current server UTC time vs. Curfew
     - [ ] If current_time < Curfew → streak_count += 1 ✅
     - [ ] If current_time ≥ Curfew → Trigger Ash Protocol (WL-210)
   - [ ] Return result to app

3. **Multi-Timezone Support**
   - [ ] User's Curfew stored in UTC
   - [ ] Server calculates based on user's device timezone
   - [ ] Account for daylight savings (automatic via system)

4. **User Timezone Change**
   - [ ] If user changes timezone (travel):
     - [ ] Curfew time unchanged (stored as absolute time)
     - [ ] Effective time shifts (e.g., Curfew 22:00 UTC = 3 AM local if user moves to Hawaii)
     - [ ] User can update Curfew in Settings anytime

### Developer Tasks

```
Task 1: Server-Side Curfew Verification
- [ ] POST /api/v1/user/sessions/complete
- [ ] Backend logic:
     SELECT daily_curfew_utc FROM users WHERE id = user_id;
     current_time = NOW() AT TIME ZONE 'UTC';
     IF current_time < daily_curfew_utc THEN
       UPDATE users SET streak_count = streak_count + 1;
     ELSE
       trigger_ash_protocol(user_id);
     END
- [ ] Return streak_count + ash_status
- [ ] Time estimate: 2 hours

Task 2: Client-Side Curfew Display
- [ ] Home screen → Show "Curfew: HH:MM"
- [ ] Session screen → Show time remaining
- [ ] Completion screen → Show streak preserved message
- [ ] Time estimate: 1 hour

Task 3: Timezone Handling
- [ ] Get device timezone (flutter_timezone package)
- [ ] Convert user's UTC Curfew to local time for display
- [ ] Allow Curfew update in Settings (WL-410)
- [ ] Unit tests for timezone conversion
- [ ] Time estimate: 2 hours

Task 4: Testing
- [ ] Test Curfew verification (before + after)
- [ ] Test timezone conversion (multiple zones)
- [ ] Test streak increment on success
- [ ] Test Ash Protocol trigger on failure
- [ ] Time estimate: 2 hours
```

---

## WL-210: The Ice State (Visual Priming at Curfew-1hr)

**Story Type:** Feature  
**Priority:** P1  
**Effort:** 3 points  
**Dependencies:** WL-200  

### User Story
As **the system**, I want to **shift the UI palette 60 minutes before Curfew**, so that **users receive subtle psychological priming without intrusive notifications**.

### Acceptance Criteria

1. **Ice State Trigger**
   - [ ] 60 minutes before user's Curfew:
     - [ ] Background color shifts: Paper White → Light cyan (#E0F7FA)
     - [ ] Primary accent: Teal → Cyan (#00BCD4)
     - [ ] Text colors remain unchanged (readability)
   - [ ] Transition is smooth (300ms fade)

2. **Visual Changes**
   - [ ] UI elements with teal accent now show cyan
   - [ ] Button backgrounds shift to cyan
   - [ ] Cards/panels shift to light cyan bg
   - [ ] Overall effect: "cooler" temperature (psychological signal)

3. **State Persistence**
   - [ ] Ice State remains active until Curfew
   - [ ] After Curfew (if session incomplete):
     - [ ] Ice State continues
     - [ ] Add banner at top: "DEADLINE PASSED. Streak will burn to Ash."
   - [ ] On session complete before Curfew:
     - [ ] Revert to normal colors
     - [ ] Show "Streak preserved" message

4. **No Notifications**
   - [ ] Ice State is ONLY visual cue (no sound, no haptic)
   - [ ] No push notification at Curfew
   - [ ] User must check app to see deadline status

### Developer Tasks

```
Task 1: Implement Color Scheme Switching
- [ ] Define Ice State colors in Design System
- [ ] Create theme provider (Riverpod)
- [ ] Logic: Check current time vs. Curfew
- [ ] If within 60 min → Use Ice State colors
- [ ] Time estimate: 2 hours

Task 2: Color Transition Animation
- [ ] Use ColorTween + AnimationController
- [ ] Transition duration: 300ms
- [ ] Ease curve: ease-in-out
- [ ] Apply to all UI elements (background, buttons, accents)
- [ ] Time estimate: 2 hours

Task 3: Deadline Passed Banner
- [ ] At Curfew time (if not complete):
     - Create banner: "DEADLINE PASSED. Streak will burn to Ash."
     - Add to top of Home/Session screen
     - Color: Warning orange or deep red
- [ ] Disappear on session complete
- [ ] Time estimate: 1 hour

Task 4: Testing & Performance
- [ ] Test color transition smoothness (no jank)
- [ ] Test on various devices (verify 60fps)
- [ ] Test banner appearance at Curfew
- [ ] Verify colors revert after session complete
- [ ] Time estimate: 1 hour
```

---

## WL-220: The Ash Protocol (Hard Streak Reset)

**Story Type:** Feature  
**Priority:** P0 (Critical - Core Philosophy)  
**Effort:** 5 points  
**Dependencies:** WL-200, WL-210  

### User Story
As **the system**, I want to **reset streaks at midnight if Curfew is missed**, so that **users face real consequences for inconsistency**.

### Acceptance Criteria

1. **Ash Protocol Trigger**
   - [ ] Midnight UTC (or next day startup):
     - [ ] Check if last_session_date < today
     - [ ] If yes AND session not complete today → Trigger Ash
   - [ ] Streak counter: streak_count = 0
   - [ ] Visual feedback: Animation of streak "burning to ash"

2. **Animation (Client-Side)**
   - [ ] On app open (next day):
     - [ ] Home screen loads
     - [ ] Streak counter currently shows "42"
     - [ ] Trigger animation: Streak fades, turns gray, counter → "0"
     - [ ] Duration: 2 seconds
     - [ ] Accompanying visual: Subtle ash/burn effect
   - [ ] No aggressive sound / notifications

3. **The Director's Pardon (Emergency Escape)**
   - [ ] User can invoke "Pardon" once per 180 days:
     - [ ] Settings → "Use Pardon" button (only if eligible)
     - [ ] Confirm: "You will owe a Double-Intensity session tomorrow."
     - [ ] On confirm:
       - [ ] Streak preserved (not reset to 0)
       - [ ] Flag: pardon_used_today = true
       - [ ] Next session: Daily drip × 2 (e.g., 40 words instead of 20)
       - [ ] Message: "Pardon granted. Complete 40 words tomorrow to re-validate."

4. **Offline Proof System (Anti-Cheat)**
   - [ ] User completes session offline (airplane mode)
   - [ ] Device generates cryptographic proof:
     - [ ] Timestamp (when session completed)
     - [ ] HMAC signature (signed by device Secure Enclave)
     - [ ] Session data (words reviewed, etc.)
   - [ ] On reconnection → Send proof to server
   - [ ] Server validates:
     - [ ] Signature valid? (using device's public key)
     - [ ] Timestamp < Curfew? (UTC comparison)
     - [ ] If both valid → Streak preserved
     - [ ] Otherwise → Ash Protocol triggered

5. **Error Handling**
   - [ ] Network error on final session submission:
     - [ ] Retry with exponential backoff (1s, 2s, 4s, 8s, then give up)
     - [ ] Store session locally if final retry fails
     - [ ] On next sync → Submit + verify curfew check

### Developer Tasks

```
Task 1: Implement Ash Protocol Trigger
- [ ] On app startup (after midnight UTC):
     - Query last_session_date from user
     - Check if today's session completed
     - If not → Trigger ash
- [ ] UPDATE users SET streak_count = 0
- [ ] Set flag: ash_triggered_today = true
- [ ] Time estimate: 2 hours

Task 2: Ash Animation
- [ ] Riverpod provider: ash_animation_triggered
- [ ] On Home screen load → Check flag
- [ ] If triggered → Play animation
     - Fade out streak counter (500ms)
     - Change color to gray (500ms)
     - Reset counter to 0
     - Display message: "Streak burned. Consistency is earned."
- [ ] Duration: 2 seconds total
- [ ] Time estimate: 2 hours

Task 3: Implement Pardon System
- [ ] Settings screen → "Use Pardon" button (if eligible)
- [ ] Eligibility: Last pardon used > 180 days ago
- [ ] Confirm dialog + double-intensity notification
- [ ] Next session: Force daily_drip_count × 2
- [ ] Mark pardon as used: pardon_last_used_date = today
- [ ] Time estimate: 3 hours

Task 4: Implement Offline Proof System
- [ ] On offline session completion:
     - Generate timestamp (local device time)
     - Create HMAC signature:
       - Input: session_data + timestamp + device_secret
       - Output: hex signature
     - Store proof in secure storage
- [ ] On reconnection:
     - Send proof to server
     - POST /api/v1/user/sessions/verify-offline-proof
- [ ] Server validates:
     - Verify HMAC signature (using stored device secret)
     - Verify timestamp < Curfew UTC
     - Update session status accordingly
- [ ] Time estimate: 4 hours

Task 5: Testing & Error Handling
- [ ] Test Ash trigger (manually advance time)
- [ ] Test animation playback
- [ ] Test Pardon eligibility + usage
- [ ] Test offline proof generation + verification
- [ ] Test network errors + retries
- [ ] Manual QA on iOS + Android
- [ ] Time estimate: 3 hours
```

---

# EPIC 7: SUBSCRIPTION & MONETIZATION

## WL-300: In-App Purchase (IAP) Integration

**Story Type:** Feature  
**Priority:** P0 (Critical - Revenue)  
**Effort:** 6 points  
**Dependencies:** WL-016  

### User Story
As **the system**, I want to **process in-app purchases for subscription tiers**, so that **users can upgrade from free to paid and generate revenue**.

### Acceptance Criteria

1. **IAP Product Configuration**
   - [ ] iOS (App Store Connect):
     - [ ] Product ID: `com.wordlearn.subscription.monthly`
     - [ ] Price: $9.99/month
     - [ ] Billing period: 1 month (auto-renews)
     - [ ] Product ID: `com.wordlearn.subscription.sixmonth`
     - [ ] Price: $49.99/6 months
     - [ ] Billing period: 6 months (auto-renews)
   - [ ] Android (Google Play Console):
     - [ ] SKU: `wordlearn_monthly` ($9.99)
     - [ ] SKU: `wordlearn_sixmonth` ($49.99)
     - [ ] Same pricing as iOS

2. **Purchase Flow**
   - [ ] User taps "SUBSCRIBE" on paywall (WL-016)
   - [ ] App requests product list from App Store/Play Store
   - [ ] Display price + confirmation dialog
   - [ ] User confirms purchase → Launch system purchase prompt
   - [ ] User enters credentials (Face ID, Apple Pay, Google Play)
   - [ ] On success → Receive receipt + transaction ID

3. **Receipt Handling**
   - [ ] iOS: Capture receipt (base64-encoded)
   - [ ] Android: Capture Google Play purchase token
   - [ ] Send to server for validation (WL-301)

4. **Error Handling**
   - [ ] User cancels purchase → Return to paywall (no error)
   - [ ] Network error → "Failed to process purchase. Try again."
   - [ ] Invalid receipt → "Purchase verification failed. Contact support."

### Developer Tasks

```
Task 1: Configure IAP Products
- [ ] iOS: Create products in App Store Connect
- [ ] Android: Create products in Google Play Console
- [ ] Document product IDs for app config
- [ ] Time estimate: 2 hours

Task 2: Integrate in_app_purchase Package (Flutter)
- [ ] Add in_app_purchase plugin to pubspec.yaml
- [ ] Initialize IAP (iOS + Android)
- [ ] Request product list from stores
- [ ] Time estimate: 2 hours

Task 3: Implement Purchase Flow
- [ ] User taps SUBSCRIBE → Launch purchase dialog
- [ ] Handle purchase callback (success / cancel / error)
- [ ] Capture receipt/token
- [ ] Send to server for verification
- [ ] Show loading indicator during processing
- [ ] Time estimate: 3 hours

Task 4: Error Handling & Testing
- [ ] Test purchase flow (iOS + Android)
- [ ] Test cancellation handling
- [ ] Test network errors
- [ ] Test receipt capture
- [ ] Manual QA with real transactions (use sandbox)
- [ ] Time estimate: 3 hours
```

---

## WL-301: Receipt Verification (Server-Side)

**Story Type:** Feature  
**Priority:** P0 (Critical - Security)  
**Effort:** 5 points  
**Dependencies:** WL-300  

### User Story
As **the system**, I want to **verify app store receipts server-side**, so that **invalid or fraudulent purchases cannot grant access**.

### Acceptance Criteria

1. **Receipt Verification Endpoint**
   - [ ] POST /api/v1/subscriptions/verify-receipt
   - [ ] Input:
     - [ ] receipt_data (iOS: base64 receipt | Android: purchase token)
     - [ ] platform (ios | android)
     - [ ] user_id (from JWT)
   - [ ] Output:
     - [ ] Valid: { "status": "active", "tier": "monthly", "expiry_date": "..." }
     - [ ] Invalid: { "status": "error", "message": "Receipt not valid" }

2. **iOS Receipt Validation**
   - [ ] Send receipt to Apple App Store Server API
   - [ ] Verify signature + expiration
   - [ ] Extract:
     - [ ] Bundle ID
     - [ ] Product ID
     - [ ] Expiry date
     - [ ] Original transaction ID
   - [ ] Cross-check against stored subscriptions (prevent reuse)

3. **Android Receipt Validation**
   - [ ] Call Google Play Billing Library API
   - [ ] Verify purchase token against package + SKU
   - [ ] Check purchase state (purchased, pending, etc.)
   - [ ] Extract expiry timestamp

4. **Subscription Record Creation**
   - [ ] On valid receipt:
     - [ ] INSERT into subscriptions table:
       - [ ] user_id
       - [ ] tier (monthly | sixmonth)
       - [ ] start_date (NOW)
       - [ ] expiry_date (from receipt)
       - [ ] receipt_data (encrypted, stored for audit)
       - [ ] platform (ios | android)
   - [ ] Update users.subscription_tier

5. **Error Handling**
   - [ ] Invalid receipt → 400 Bad Request
   - [ ] Expired receipt → 400 Bad Request
   - [ ] Duplicate transaction → 409 Conflict (already subscribed)
   - [ ] Network error (Apple/Google API) → 502 Bad Gateway (retry)

### Developer Tasks

```
Task 1: iOS Receipt Verification
- [ ] Implement Apple App Store Server API client
- [ ] Endpoint: https://api.storekit.itunes.apple.com/inApps/...
- [ ] Verify JWS signature (cryptographic validation)
- [ ] Extract payload fields
- [ ] Validate bundle ID + product ID match
- [ ] Check expiration date
- [ ] Time estimate: 3 hours

Task 2: Android Receipt Verification
- [ ] Implement Google Play Billing API client
- [ ] Endpoint: https://androidpublisher.googleapis.com/...
- [ ] Authenticate with service account (OAuth)
- [ ] Verify purchase token + signature
- [ ] Extract purchase state + timestamp
- [ ] Time estimate: 2 hours

Task 3: Database & Subscription Management
- [ ] INSERT into subscriptions table on verified receipt
- [ ] UPDATE users.subscription_tier + users.subscription_status
- [ ] Create subscription_id for reference
- [ ] Encrypt receipt_data before storage
- [ ] Time estimate: 2 hours

Task 4: Error Handling & Testing
- [ ] Handle each error case (invalid, expired, duplicate)
- [ ] Test with actual App Store sandbox receipts
- [ ] Test with Google Play sandbox tokens
- [ ] Test database record creation
- [ ] Integration tests
- [ ] Time estimate: 2 hours
```

---

## WL-310: Subscription Entitlements & Feature Gating

**Story Type:** Feature  
**Priority:** P0 (Critical - Monetization Enforcement)  
**Effort:** 3 points  
**Dependencies:** WL-301  

### User Story
As **the system**, I want to **gate features based on subscription tier**, so that **free users see limited features while paid users unlock full platform**.

### Acceptance Criteria

1. **Subscription Tiers & Entitlements**

| Feature | Free | Monthly | 6-Month |
|---------|------|---------|---------|
| Languages | 1 | 6 | 6 |
| Active Batch | 50 words | 200 words | 200 words |
| Vault | Yes | Yes | Yes |
| Multi-Language Session | ❌ | ✅ | ✅ |
| Intelligence Reports | ❌ | ✅ | ✅ |
| Mnemonics (Phase 2) | ❌ | ✅ | ✅ |
| Ads | None | None | None |

2. **Feature Gating**
   - [ ] Free users:
     - [ ] Language selection shows "Upgrade to add language" after 1st
     - [ ] Active Batch capped at 50 words
     - [ ] "Add Language" button in Settings disabled (with upgrade prompt)
   - [ ] Paid users:
     - [ ] Can select up to 6 languages
     - [ ] 200-word Active Batch per language
     - [ ] Intelligence Reports accessible
     - [ ] Mnemonics feature enabled

3. **Entitlement Check**
   - [ ] On app startup → Check subscription status
   - [ ] If expired → Downgrade to free tier
   - [ ] Show banner: "Subscription expired. Upgrade to continue."
   - [ ] Limit features dynamically

4. **Upgrade Prompts**
   - [ ] When free user tries to add 2nd language:
     - [ ] Modal: "Upgrade to unlock multiple languages"
     - [ ] Button: "UPGRADE"
     - [ ] Link: "Back"
   - [ ] When accessing paid features:
     - [ ] Show feature-specific upgrade prompt

### Developer Tasks

```
Task 1: Fetch Subscription Status
- [ ] GET /api/v1/user/subscription (retrieve tier + status)
- [ ] Store in Riverpod provider (subscription_tier)
- [ ] Cache for 1 hour (refresh on app startup)
- [ ] Time estimate: 1 hour

Task 2: Create Feature Gating Service
- [ ] Riverpod provider: can_add_language(tier)
- [ ] can_access_feature(feature_name, tier)
- [ ] can_use_active_batch_full(tier) // 50 vs 200
- [ ] Logic: Free → limited, Paid → full
- [ ] Time estimate: 1 hour

Task 3: Implement Feature Gating UI
- [ ] "Add Language" button disabled for free users
- [ ] Show upgrade prompts at key points
- [ ] Add "Upgrade" button in Settings
- [ ] Show subscription status (expiry date, tier)
- [ ] Time estimate: 2 hours

Task 4: Testing & Verification
- [ ] Test free tier (1 language, 50-word batch)
- [ ] Test paid tier (6 languages, 200-word batch)
- [ ] Test expired subscription → downgrade
- [ ] Test feature gates (Language add, Intelligence Reports)
- [ ] Test upgrade prompts
- [ ] Time estimate: 2 hours
```

---

# EPIC 8: MULTI-LANGUAGE SUPPORT (MODULAR SYSTEM)

## WL-600: Language Configuration & Loading

**Story Type:** Feature  
**Priority:** P0 (Critical - MVP Foundation)  
**Effort:** 4 points  
**Dependencies:** None (foundational)  

### User Story
As **the system**, I want to **load language configuration and vocabulary from modular sources**, so that **adding new languages requires zero code changes**.

### Acceptance Criteria

1. **Language Configuration**
   - [ ] Load `assets/config/languages.yaml`:
     - [ ] Language code (en, de, fr, es, it, tr)
     - [ ] Display name + native name
     - [ ] CEFR support (A1–C2)
     - [ ] Script (latin, cyrillic, etc.)
     - [ ] RTL support (false for MVP)
     - [ ] Locale (en_US, de_DE, etc.)
   - [ ] Parse YAML at app startup
   - [ ] Store in Riverpod provider (available_languages)

2. **Vocabulary Loading**
   - [ ] Load master vocabulary CSVs:
     - [ ] `data/vocabularies/en-de/a1.csv`
     - [ ] `data/vocabularies/en-de/a2.csv`
     - [ ] Continue for all language pairs + CEFR levels
   - [ ] Parse CSV on first launch (or on-demand per language)
   - [ ] Store in local SQLite (master_vocabulary + language_variants tables)
   - [ ] Verify data integrity (validation checks)

3. **Language-Pair Isolation**
   - [ ] Each (user, language_pair) has independent:
     - [ ] active_batch
     - [ ] vault
     - [ ] streak
     - [ ] srs state
   - [ ] User can learn en-de and en-fr simultaneously without conflicts

4. **Adding New Language (Future-Proof)**
   - [ ] To add Portuguese:
     - [ ] Add to languages.yaml
     - [ ] Prepare CSVs: en-pt/a1.csv, en-pt/a2.csv, etc.
     - [ ] Run validation script
     - [ ] Auto-generate migration SQL
     - [ ] Deploy → No code changes

### Developer Tasks

```
Task 1: Load Language Configuration
- [ ] Create languages.yaml with 6 languages
- [ ] Implement YAML parser (yaml package)
- [ ] Create LanguageConfig model (Dart)
- [ ] Riverpod provider: available_languages
- [ ] Unit tests for config parsing
- [ ] Time estimate: 2 hours

Task 2: Load Master Vocabulary
- [ ] CSV loader utility (csv package)
- [ ] Read all vocabulary CSVs from assets
- [ ] Parse into Vocabulary objects
- [ ] Validate data (UTF-8, ID uniqueness, etc.)
- [ ] Unit tests for CSV parsing
- [ ] Time estimate: 3 hours

Task 3: Initialize SQLite Master Vocabulary
- [ ] On first app launch:
     - Read CSV files
     - INSERT into master_vocabulary + language_variants tables
     - Ensure no duplicates (idempotent)
- [ ] Create indexes for fast lookups
- [ ] Handle update scenario (new CEFR level added)
- [ ] Time estimate: 2 hours

Task 4: Implement Language-Pair Isolation
- [ ] Database constraints ensure per-language-pair independence
- [ ] Riverpod providers for per-language state
- [ ] Verify no cross-language data leaks
- [ ] Integration tests
- [ ] Time estimate: 2 hours
```

---

## WL-610: Multi-Language Study Sessions

**Story Type:** Feature  
**Priority:** P1  
**Effort:** 4 points  
**Dependencies:** WL-600  

### User Story
As a **polyglot user**, I want to **study multiple languages in a single session**, so that **I can maintain momentum across all my target languages**.

### Acceptance Criteria

1. **Multi-Language Mode Toggle**
   - [ ] Home screen:
     - [ ] Single-language mode (default): Dropdown to select language
     - [ ] OR "MULTI-LANGUAGE MODE" toggle
   - [ ] If toggled ON:
     - [ ] Draw cards randomly from all enrolled languages
     - [ ] Each card shows language badge (small label: "GERMAN", "ITALIAN")
     - [ ] Stats show per-language breakdown (X German, Y Italian cards)

2. **Card Rendering with Language Badge**
   - [ ] Flashcard includes language badge:
     - [ ] Position: Top-right corner
     - [ ] Style: Small label, language color-coded (optional)
     - [ ] Example: "GERMAN" in teal badge
   - [ ] User knows which language they're studying immediately

3. **Independent SRS**
   - [ ] Difficulty rating applies only to that language:
     - [ ] Mark German word "Easy" → German SRS updates
     - [ ] Italian word not affected
   - [ ] Each language has independent next_review_date

4. **Session Summary (Multi-Language)**
   - [ ] On completion:
     - [ ] "15 German words reviewed, 2 mastered"
     - [ ] "10 Italian words reviewed, 1 mastered"
     - [ ] "Total: 25 words, 3 mastered"
   - [ ] Streak increments (once, for all languages, if Curfew met)

### Developer Tasks

```
Task 1: Implement Language Mode Selection
- [ ] Home screen: Language dropdown + Multi-Language toggle
- [ ] Riverpod state: selected_language_pair (or null if multi)
- [ ] Toggle switches mode
- [ ] Time estimate: 2 hours

Task 2: Card Randomization (Multi-Language)
- [ ] Session prep (WL-050): If multi-mode, sample from all languages
- [ ] Pool = all due cards from all enrolled languages
- [ ] Shuffle pool using Fisher-Yates
- [ ] Create session with mixed languages
- [ ] Time estimate: 2 hours

Task 3: Language Badge Display
- [ ] Add badge widget to flashcard
- [ ] Show language code or name (configurable)
- [ ] Color-code per language (optional, Phase 2)
- [ ] Verify badge doesn't obscure content
- [ ] Time estimate: 1 hour

Task 4: Multi-Language Session Completion
- [ ] Collect reviews from mixed languages
- [ ] Separate reviews by language_pair
- [ ] Update SRS per language independently
- [ ] Calculate per-language stats
- [ ] Display breakdown in summary
- [ ] Single streak increment (applies to all)
- [ ] Time estimate: 2 hours
```

---

# EPIC 9: SYNC & OFFLINE SUPPORT

## WL-500: Ghost Backup (Cloud Sync)

**Story Type:** Feature  
**Priority:** P0 (Critical - Data Persistence)  
**Effort:** 5 points  
**Dependencies:** WL-001 to WL-100  

### User Story
As **the system**, I want to **periodically backup user progress to the cloud**, so that **users can restore their data on new devices**.

### Acceptance Criteria

1. **Ghost Backup Trigger**
   - [ ] Every 6 hours (automatic)
   - [ ] On app close (gracefully)
   - [ ] Manual sync: Settings → "Sync Now" button
   - [ ] On successful session completion (WL-075)

2. **Data to Backup**
   - [ ] Serialize:
     - [ ] User profile (name, languages, Curfew, drip)
     - [ ] Active batch (all words + SRS state)
     - [ ] Vault (all mastered words)
     - [ ] Study session history (last 30 days)
     - [ ] Streaks + Pardon status
   - [ ] Exclude: Password, subscription receipt

3. **Backup Process**
   - [ ] Serialize to JSON (custom encoder)
   - [ ] Compress with gzip
   - [ ] Encrypt with AES-256 (key derived from user password + timestamp)
   - [ ] POST to server: `/api/v1/user/backup`
   - [ ] Server stores encrypted blob in Supabase
   - [ ] Size optimization: Only include changed records (delta sync)

4. **Error Handling**
   - [ ] Network error → Store locally, retry next sync
   - [ ] Server error → Show message: "Backup failed. Try again later."
   - [ ] Large payload → Skip sync (user has too much data)

5. **Restore Process (Cross-Device)**
   - [ ] User signs in on new device
   - [ ] On first login → Offer restore option:
     - [ ] "Restore progress from backup?"
     - [ ] "RESTORE" or "START FRESH"
   - [ ] On restore:
     - [ ] Fetch encrypted backup from server
     - [ ] Decrypt with user password
     - [ ] Parse JSON → Restore to local SQLite
     - [ ] Verify data integrity

### Developer Tasks

```
Task 1: Implement Backup Serialization
- [ ] Create BackupData model (all user data)
- [ ] Implement custom JSON encoder (Freezed)
- [ ] Serialize active_batch, vault, session history
- [ ] Compress with archive package (gzip)
- [ ] Unit tests for serialization
- [ ] Time estimate: 3 hours

Task 2: Backup Encryption
- [ ] Use encrypt package (AES-256)
- [ ] Key derivation: PBKDF2(password + timestamp)
- [ ] Encrypt compressed JSON
- [ ] Output: base64-encoded ciphertext
- [ ] Unit tests for encryption/decryption
- [ ] Time estimate: 2 hours

Task 3: Cloud Backup Transmission
- [ ] POST /api/v1/user/backup
- [ ] Include: encrypted_data, timestamp, platform
- [ ] Server stores in Supabase
- [ ] Retry logic (exponential backoff, max 3 retries)
- [ ] Show toast: "Backup successful" on success
- [ ] Time estimate: 2 hours

Task 4: Restore on New Device
- [ ] On first login → Check if backup exists
- [ ] Offer restore dialog
- [ ] Fetch + decrypt backup
- [ ] Parse JSON → Insert into local SQLite
- [ ] Verify integrity (count check, etc.)
- [ ] Time estimate: 2 hours
```

---

## WL-510: Conflict Resolution (Multi-Device Sync)

**Story Type:** Feature  
**Priority:** P1  
**Effort:** 3 points  
**Dependencies:** WL-500  

### User Story
As a **multi-device user**, I want to **study on both iPhone and iPad without losing progress**, so that **my learning continues seamlessly across devices**.

### Acceptance Criteria

1. **Multi-Device Sync Scenario**
   - [ ] User studies 10 words on iPhone → Submit reviews
   - [ ] Later, user opens iPad → Fetch latest backup
   - [ ] iPad has local state (old progress)
   - [ ] System detects conflict (newer server state)

2. **Conflict Resolution (Last-Write-Wins)**
   - [ ] For each word, compare:
     - [ ] Device state vs. Server state
     - [ ] Look at timestamps (last_reviewed_at)
   - [ ] Rule: Most recent review wins
   - [ ] Example:
     - [ ] iPhone review: "OK" at 14:30
     - [ ] iPad local review: "EASY" at 14:20
     - [ ] Server wins (14:30 > 14:20)
     - [ ] iPad receives iPhone's state + SRS update

3. **Merge Strategy**
   - [ ] Don't duplicate reviews (1 review = 1 submission)
   - [ ] SRS state merges based on latest review
   - [ ] Example:
     - [ ] iPhone: ease_factor = 2.4, interval = 10 days
     - [ ] iPad: ease_factor = 2.3, interval = 8 days
     - [ ] Merge: Keep iPhone state (more recent, higher confidence)

4. **User Notification**
   - [ ] On device: Synced with latest progress
   - [ ] No error message (transparent)
   - [ ] If conflict detected: Log for debugging (no user alert)

### Developer Tasks

```
Task 1: Implement LWW (Last-Write-Wins)
- [ ] Create SyncResolver class
- [ ] Logic: Compare last_reviewed_at timestamps
- [ ] Most recent timestamp wins
- [ ] Merge SRS states (ease_factor, interval)
- [ ] Unit tests for various conflict scenarios
- [ ] Time estimate: 2 hours

Task 2: Multi-Device State Synchronization
- [ ] On app startup → Fetch latest server backup
- [ ] Compare with local state (active_batch)
- [ ] Detect conflicts (different SRS states)
- [ ] Apply LWW resolution
- [ ] Update local SQLite
- [ ] Time estimate: 2 hours

Task 3: Background Sync
- [ ] Periodic sync every 30 minutes (if online)
- [ ] Foreground sync on app resume
- [ ] Handle network errors gracefully
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Test LWW conflict resolution (various scenarios)
- [ ] Test multi-device sync (simulate iPhone + iPad)
- [ ] Test merge correctness (SRS state integrity)
- [ ] Time estimate: 1 hour
```

---

# EPIC 10: SETTINGS & USER PROFILE

## WL-400: User Profile & Settings Screen

**Story Type:** Feature  
**Priority:** P1  
**Effort:** 4 points  
**Dependencies:** WL-001, WL-050  

### User Story
As a **user**, I want to **access settings to customize my learning experience**, so that **I can adjust pace, preferences, and account details**.

### Acceptance Criteria

1. **Settings Screen Layout**
   - [ ] Accessible from bottom nav: "SETTINGS" tab
   - [ ] Sections (grouped):
     - **Profile**
       - Display name (editable)
       - Base language (read-only)
       - Target languages (edit: add/remove)
     - **Learning**
       - Daily Curfew (editable: time picker)
       - Daily Drip (editable: slider 5–40)
       - Auto-play audio (toggle)
       - Theme (Light / Dark)
     - **Privacy**
       - Share Learning Data (toggle)
       - Allow Crash Reports (toggle)
     - **Account**
       - Subscription status (tier + expiry)
       - "Upgrade" button (if free tier)
       - "Manage Subscription" (if paid)
     - **Danger Zone**
       - "Log Out" button
       - "Delete Account" button (red, requires confirmation)

2. **Editability**
   - [ ] Display name:
     - [ ] Tap → Show edit dialog
     - [ ] Submit → Update server + local state
   - [ ] Daily Curfew:
     - [ ] Tap → Time picker
     - [ ] Submit → Update immediately (no restart required)
   - [ ] Daily Drip:
     - [ ] Slider → Real-time update (no submit needed)

3. **Visual Design**
   - [ ] Clean, grouped layout
   - [ ] Each section has title + divider
   - [ ] Toggles on right, labels on left
   - [ ] Red styling for destructive actions

### Developer Tasks

```
Task 1: Design Settings Screen
- [ ] Create grouped list layout (Profile, Learning, Privacy, Account, Danger Zone)
- [ ] Add toggle switches + text fields + buttons
- [ ] Style per Design System (teal accents, red for dangerous)
- [ ] Time estimate: 2 hours

Task 2: Implement Profile Editing
- [ ] Display name: Edit dialog + validation
- [ ] Base language: Read-only display
- [ ] Target languages: "Add/Remove Language" UI
- [ ] Update server on submit
- [ ] Time estimate: 2 hours

Task 3: Learning Settings
- [ ] Curfew: Time picker + update
- [ ] Drip: Slider with real-time update
- [ ] Audio toggle: Persisted in user_settings
- [ ] Theme toggle: Switch between light/dark
- [ ] Time estimate: 2 hours

Task 4: Account & Subscription Info
- [ ] Fetch subscription status (WL-310)
- [ ] Display tier + expiry date
- [ ] "Upgrade" button → Paywall (if free)
- [ ] "Manage Subscription" → Open App Store / Play Store settings
- [ ] Time estimate: 1 hour
```

---

## WL-410: Privacy Controls & Data Management

**Story Type:** Feature  
**Priority:** P2  
**Effort:** 2 points  
**Dependencies:** WL-400  

### User Story
As a **privacy-conscious user**, I want to **control my data collection and export my information**, so that **I maintain ownership of my data**.

### Acceptance Criteria

1. **Privacy Toggles**
   - [ ] Share Learning Data:
     - [ ] Toggle on/off user-generated mnemonics sharing (Phase 2)
     - [ ] When ON: Mnemonics visible to other users
     - [ ] When OFF: Mnemonics private
   - [ ] Allow Crash Reports:
     - [ ] Toggle on/off anonymous error telemetry
     - [ ] When ON: Sentry receives error data (no PII)
     - [ ] When OFF: No telemetry sent

2. **Data Export (GDPR)**
   - [ ] "Download My Data" button
   - [ ] Generates JSON file with:
     - [ ] User profile
     - [ ] All study progress
     - [ ] Active batch + vault
     - [ ] Session history
   - [ ] File saved to device (user can share/back up)
   - [ ] Confirmation: "Data exported. Check Files app."

3. **Right to Erasure (GDPR)**
   - [ ] "Delete Account" button (red, bottom of Settings)
   - [ ] Confirm dialog: "Permanently delete account and all data? This cannot be undone."
   - [ ] Optional: Allow re-download of data before deletion
   - [ ] On confirm:
     - [ ] Clear local SQLite
     - [ ] POST /api/v1/user/delete to server
     - [ ] Server schedules deletion (30 days for audit)
     - [ ] Redirect to Auth screen

### Developer Tasks

```
Task 1: Implement Privacy Toggles
- [ ] Add toggle switches to Settings
- [ ] Riverpod providers: share_learning_data, allow_crash_reports
- [ ] Persist to user_settings table
- [ ] Update Sentry + mnemonic sharing logic based on toggle
- [ ] Time estimate: 1 hour

Task 2: Implement Data Export
- [ ] Query all user data (profile, batch, vault, sessions)
- [ ] Serialize to JSON
- [ ] Create file in Documents directory
- [ ] Show share sheet (user can AirDrop, email, etc.)
- [ ] Confirmation toast
- [ ] Time estimate: 2 hours

Task 3: Implement Account Deletion
- [ ] "Delete Account" button + confirm dialog
- [ ] POST /api/v1/user/delete
- [ ] Clear all local data (SQLite + tokens)
- [ ] Redirect to Auth screen
- [ ] Server-side deletion (scheduled)
- [ ] Time estimate: 1 hour

Task 4: Testing
- [ ] Test privacy toggle persistence
- [ ] Test data export (verify JSON structure)
- [ ] Test account deletion (verify local clear)
- [ ] Time estimate: 1 hour
```

---

# IMPLEMENTATION ROADMAP

## MVP Sprint Breakdown (12 weeks)

**Week 1–2: Foundation**
- [ ] WL-001: Email Sign-Up
- [ ] WL-002: Google OAuth
- [ ] WL-003: Apple OAuth (iOS)
- [ ] WL-004: JWT Token Management
- [ ] WL-005: Logout
- [ ] WL-600: Language Configuration

**Week 3–4: Onboarding**
- [ ] WL-010: Welcome Screen
- [ ] WL-011: Base Language Selection
- [ ] WL-012: Target Languages
- [ ] WL-013: CEFR Level Selection
- [ ] WL-014: Curfew Setup
- [ ] WL-015: Daily Drip Configuration

**Week 5–6: Core Study Loop**
- [ ] WL-050: Session Initialization
- [ ] WL-060: Flashcard Display
- [ ] WL-070: Difficulty Rating
- [ ] WL-075: Session Completion
- [ ] WL-300: IAP Integration
- [ ] WL-301: Receipt Verification

**Week 7–8: Batch & SRS**
- [ ] WL-140: Active Batch Status
- [ ] WL-150: Daily Drip
- [ ] WL-160: Batch Capacity Management
- [ ] WL-170: Move to Vault
- [ ] WL-180: View Vault
- [ ] Update: SRS Algorithm (SM-2)

**Week 9–10: Accountability & Multi-Language**
- [ ] WL-200: Curfew Enforcement
- [ ] WL-210: Ice State
- [ ] WL-220: Ash Protocol + Pardon
- [ ] WL-610: Multi-Language Sessions
- [ ] WL-400: Settings Screen

**Week 11–12: Sync, Subscription & Polish**
- [ ] WL-310: Subscription Entitlements
- [ ] WL-500: Ghost Backup
- [ ] WL-510: Conflict Resolution
- [ ] WL-410: Privacy & Data Management
- [ ] Testing + QA + Launch Prep

---

## Success Metrics (Post-Launch)

| Metric | Target | Method |
|--------|--------|--------|
| **DAU (Day 1)** | 100 | Analytics dashboard |
| **Retention (Day 7)** | 40% | Cohort analysis |
| **Retention (Day 30)** | 20% | Cohort analysis |
| **Subscription Conversion** | 5% | In-app tracking |
| **App Rating** | 4.5+ / 5 | App Store reviews |
| **Churn Rate** | < 10% monthly | MRR tracking |

---

**End of User Stories Document**

These stories are **production-ready** for sprint planning. Each includes acceptance criteria, developer tasks, and effort estimates. Use them as the single source of truth for implementation.

Questions? Clarify with the product team before development begins.
