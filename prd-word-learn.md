CHAPTER 1: STRATEGIC FOUNDATION
1.1. Executive Vision & Value Proposition: The "Academic Rigor meets Minimalist Design" ethos.
1.2. Institutional Alignment & Personas: Mapping the specific needs of Scholars, Professors, and Corporate HR.
1.3. Pedagogical Methodology: The SRT (Spaced Repetition Theory) and CEFR alignment.
1.4. Ethical Gamification (Focus Design): Defining the "Ice & Ash" accountability system without the "noir" fluff.
1.5. Nomenclature Glossary: Unified definitions for The Drip, Active Batch, and The Curfew.

CHAPTER 2: ARCHITECTURE & DATA INTEGRITY
2.1. System Resilience & Scalability: Merging Infrastructure, Scaling, and Disaster Recovery into one "Global Ready" spec.
2.2. Data Sovereignty (Local-First): The technical logic of SQLite/Syncing that ensures the user owns their progress.
2.3. Internationalization (i18n): Framework for global character support and localized UI logic.
2.4. Staging & QA: Standardized pipeline for word-batch validation before deployment.

CHAPTER 3: THE SCHOLAR’S JOURNEY (UX)
3.1. Enrollment Protocol (Onboarding): Identity setup, the Honor Code, and baseline proficiency mapping.
3.2. Deep Work Cycle: The "Multi-Face Reveal" study loop and contextual encoding.
3.3. Discipline Framework: The Curfew logic and the "Ice/Ash" accountability states.
3.4. Executive Certification: Milestone verification and automated LinkedIn/PDF credentialing.

CHAPTER 4: CORE FUNCTIONAL MODULES
4.1. The Knowledge Base (Library): Relational mapping of words (A1-C2) and the "200-Asset Active Batch" drip logic.
4.2. The Cognitive Lab (Engine): Advanced Retrieval modes: Cloze-deletion, Recognition, and Encoding Drills.
4.3. The Mastery Archive (The Vault): Long-term knowledge persistence and re-validation drills.
4.4. Peer Insights: Scholarly mnemonic repository and peer-vetted memory hacks.
4.5. Global Directory: Universal search across all 6 languages for manual curriculum injection.

CHAPTER 5: VISUAL & INTERACTION DESIGN
5.1. Swiss Modernist Aesthetic: Typography (Helvetica/Futura), Grid Systems, and Ligne Claire precision.
5.2. Adaptive Environments: "Focus Mode" (Day) vs. "Deep Work Mode" (Night) and the "Ice" UI shift.
5.3. The Chancellor (Interface): The professional tone, visual persona, and contextual guidance logic.

CHAPTER 6: SECURITY & COMPLIANCE
6.1. Encryption Standards: SQLCipher (Local) and TLS 1.3 (Network) with Hardware-Backed Key Management.
6.2. Institutional Compliance: Global GDPR/CCPA data sovereignty and RASP (Runtime Self-Protection).
6.3. Identity Management (SSO): Standard Enterprise login (Okta, Azure, Google Workspace).

CHAPTER 7: INSTITUTIONAL INFRASTRUCTURE (B2B)
7.1. Corporate Administration: Managerial Dashboards, LMS integration, and SCIM (User Provisioning).
7.2. Custom Curricula: Proprietary Lexicon Ingestion (e.g., Medical/Legal sets) and Departmental Knowledge Groups.
7.3. Service Level Assurance: Uptime SLAs and professional support frameworks.

CHAPTER 1: STRATEGIC FOUNDATION
1.1. Executive Vision & Value Proposition
The Institute is the antithesis of the "casual" language learning market. While competitors focus on dopamine-driven streaks and colorful characters, we provide a high-performance environment built on Swiss Modernist principles.
The Ethos: Academic rigor delivered through minimalist design. We assume the user is a high-functioning professional or dedicated student who values time over entertainment.
Value Proposition: To provide a focused, distraction-free "Deep Work" environment that guarantees long-term semantic retention through strict accountability and superior visual clarity.
1.2. Institutional Alignment & Personas
The platform is engineered to satisfy three distinct tiers of scholarly and professional needs:
The Scholar (User): Focuses on high-efficiency mastery. They require a tool that feels like a premium workstation, not a toy. They value data privacy and technical reliability.
The Professor (Educator): Requires a curriculum that aligns with official standards (CEFR) and provides verifiable "Proof of Effort" from students.
Corporate HR (Enterprise): Seeks maximum ROI for training budgets. They require professional certification (Intel Reports) and a tool that reflects the company’s own professional standards.
1.3. Pedagogical Methodology
Our system is grounded in the science of cognitive endurance:
Spaced Repetition Theory (SRT): Using a refined SM-2 algorithm to ensure words are reviewed exactly as they begin to fade from the user's "Mastery Archive."
CEFR Alignment: The Knowledge Base is categorized strictly from A1 (Breakthrough) to C2 (Mastery), ensuring the vocabulary is relevant to international exams.
Active Recall vs. Passive Recognition: Our "Multi-Face Reveal" protocol forces the brain to retrieve the target word from memory rather than simply recognizing it from a list of options.
1.4. Ethical Gamification (Focus Design)
We reject "Loot-Box" mechanics. Our gamification is based on Accountability and Loss Aversion:
The Ice State (Curfew): As the user’s self-imposed deadline approaches, the UI transitions to a "Cold" palette. This creates a psychological "priming" for completion without intrusive notifications.
The Ash Protocol (The Hard Reset): If a daily session is not finalized by midnight, the streak burns to Ash. There are no "Streak Freezes." This fosters genuine professional discipline—consistency is the only way to maintain the flame.
1.5. Nomenclature Glossary
To ensure the development team and institutional partners speak a unified language, we define the following proprietary terms:
The Drip: The automated daily injection of new vocabulary assets (default: 20) into the user’s curriculum.
The Active Batch: The hard limit of 200 words currently being "processed" by the user's brain. A new word cannot be added until one is mastered and moved to the Vault.
The Curfew: The specific hour (user-defined) when the app enters the "Ice" state, signaling the final window for daily study.
The Vault: The long-term storage for "Mastered" assets.
The Chancellor: The refined interface persona providing high-level feedback and institutional guidance.
CHAPTER 2: TECHNICAL ARCHITECTURE
The Institute’s infrastructure is designed for data permanence and global availability. Our "Local-First" approach ensures that even if the central server is unreachable, the Scholar’s intellectual progress remains uncompromised.

2.1. System Resilience & Scalability
We utilize a distributed backend architecture centered on Supabase (PostgreSQL) to handle institutional-grade traffic.
High-Availability Infrastructure: Global scaling is managed via a clustered database environment. Read-replicas are deployed across major geographical regions to ensure low-latency access to the Master Lexicon.
Edge Logic Deployment: Time-critical events—specifically the Curfew and Ash Reset—are handled via Edge Functions. This ensures that discipline logic is calculated based on the Scholar's local UTC offset, verified against server-side time to prevent local manipulation.
Disaster Recovery: Automated daily snapshots of the central Knowledge Base and encrypted User Meta-data are stored in redundant, physically separate data centers.
2.1.2. On-Demand Media Streaming Protocol: To optimize bandwidth and local storage, the app does not download the full 20,000+ asset library. It utilizes a Just-In-Time (JIT) Media Fetcher that pre-caches Ligne Claire illustrations and high-fidelity TTS audio only for the 200-Word Active Batch and upcoming reviews.

2.2. Data Sovereignty (Local-First Integrity)
To ensure maximum performance and privacy, the primary "Source of Truth" for progress data is the Scholar’s device.
The Local Ledger (SQLite): All active batch data and SRS metadata are stored locally in a high-performance SQLite database. This allows for zero-latency study sessions and full offline functionality.
Proprietary Security (SQLCipher): The local database is encrypted at rest using SQLCipher (AES-256). The encryption keys are managed through hardware-backed security modules (iOS Keychain / Android Keystore), ensuring that the Knowledge Base cannot be extracted or "scraped."
The Sync Protocol (Ghost Backup): Periodically, the app serializes local progress into a compressed JSON blob. This "Ghost Backup" is transmitted via TLS 1.3 to the secure backend, allowing for cross-device persistence without the overhead of row-by-row server updates.
2.3. Internationalization (i18n) & Localization
The Institute is a global entity. The technical framework is built to support diverse linguistic structures from the outset.
Universal Character Support: The entire data pipeline utilizes UTF-8 encoding, ensuring perfect rendering for the 6 core languages, including the specific diacritics of Turkish, French, German, Italian, and Spanish.
Contextual UI Strings: All interface elements are mapped to a localization key system. This allows the "Chancellor" to communicate with the Scholar in their preferred base language while maintaining a consistent professional tone.
Temporal Logic: The app logic accounts for regional date/time formats and daylight savings transitions to ensure the Curfew remains mathematically accurate relative to the Scholar's physical location.
2.4. Staging & Quality Assurance (QA)
Scholarly precision requires that no corrupted data or "broken" curriculum reaches the production environment.
Institutional Staging: We maintain a dedicated Staging Environment where new features (such as "Shadow Sessions" or new "Cognitive Lab" modes) are stress-tested before deployment to the general Scholar population.
Error Monitoring: Real-time telemetry (anonymized) tracks crash rates and synchronization failures, allowing the engineering team to deploy hotfixes before the Scholar’s "Deep Work" is interrupted.
2.4.1. The Validation Pipeline: Scholarly precision is maintained through a Strict Schema & Regex Constraint Validation system. New linguistic assets added to the "Huge CSV" pass through an automated local script that enforces:
Character Integrity: Verification of UTF-8 encoding for language-specific diacritics.
Syntactic Logic: Regex checks to confirm the Target Word exists within the Example Sentence.
Data Constraints: Enforcement of ID-uniqueness and strict character limits to maintain UI consistency.
Normalization: Trimming of whitespace and standardized casing to prevent search index pollution.

2.5. Data Sovereignty & Synchronization Logic
2.4.1. Local-First / Cloud-Second Protocol: The primary "Source of Truth" remains the device.
2.4.2. Multi-Device Conflict Resolution: To support Scholars moving between tablets and mobile devices, the system implements LWW (Last-Write-Wins) or CRDT (Conflict-free Replicated Data Types) logic. This ensures that SRS intervals are merged based on the most recent high-quality interaction, preventing progress loss across synchronized hardware.
2.4.3. The Sync Protocol (Ghost Backup): Periodically, the app serializes local progress into a compressed JSON blob transmitted via TLS 1.3.
2.6. Tech Stack (The 2026 Blueprint)
Frontend: Flutter (Dart) for pixel-perfect Ligne Claire rendering and 8px grid precision; Riverpod for robust, testable state management.
Backend: Supabase (PostgreSQL) for data/Auth; Supabase Edge Functions for time-sensitive "Curfew" logic.
Database & Security: SQLite with SQLCipher (AES-256); Hardware-backed key management via iOS Keychain/Android Keystore.
Integrity: Cloudflare Time API (NTP) for anti-cheat verification on the Ash Protocol; gRPC/GraphQL for rigid API schemas.


CHAPTER 3: THE SCHOLAR’S JOURNEY (UX)
The Scholar’s Journey is a structured path from initial enrollment to verified mastery. Every interaction is designed to minimize friction and maximize cognitive engagement, ensuring the Institute’s high standards for discipline and retention are met.

3.1. Enrollment Protocol (Onboarding)
Entering the Institute is a formal process. We do not use "tutorial" levels; instead, we utilize an Initialization Protocol that establishes the Scholar’s professional environment.
3.1.1. Professional Identity: Scholars authenticate via SSO (Single Sign-On) or institutional credentials. This links their progress to a permanent professional record.
3.1.2. The Academic Honor Code: Before data ingestion begins, the Scholar must acknowledge the Terms of Intellectual Property and the Discipline Contract. This is a "Clickwrap" agreement that emphasizes the permanence of the streak system.
3.1.3. Baseline Configuration: The Scholar selects their Base Language (L1) and Target Language(s) (L2-L6). The system then maps the curriculum based on the chosen CEFR starting level.
3.1.4. Cognitive Load Initialization: The Scholar defines their Daily Drip (default: 20 assets). This setting determines the velocity of the curriculum and can only be adjusted during a session "Cool Down" to prevent impulsive changes.
CHAPTER 3.1.5: THE PRELIMINARY BRIEFING (ONBOARDING)
The first-ever page the user sees is a high-contrast, text-driven sequence designed to establish the gravity of the Institute. It is not skippable; it is the Foundational Briefing.
Page 0: The Initialization Sequence
The Visual: A blank kPaperWhite screen. The Chancellor (Ligne Claire illustration) appears in the center. A typewriter-style animation reveals the text.
The Content: 1. Welcome: "Scholar, welcome to the Institute. This is a workstation, not a playground." 2. The Mission: "We aim for mastery through architectural precision and Spaced Repetition." 3. The Warning: "Consistency is our only currency. If you fail to meet your Curfew, your progress will burn to Ash. We do not freeze streaks. We do not offer shortcuts."
The Interaction: A single, sharp kPrimaryTeal button: "I ACCEPT THE TERMS OF DISCIPLINE".
Step-by-Step Enrollment Flow
Identity Verification: Link to SSO or Professional Email.
Linguistic Mapping: The user selects their L1 (Base) and Target L2–L6.
The Curfew Setup: The user must select their daily deadline. The UI warns: "Choose wisely. This is when the Ice State begins."
The Initial Drip: The app performs a one-time sync of the first 20 assets from the Huge CSV to the Active Batch.


3.2. The Deep Work Cycle (Core Study Loop)
The study session is the Scholar’s "Workstation." It is a distraction-free environment focused on Active Retrieval.
3.2.1. Session Initialization: Upon launch, the app displays the Daily Briefing: total assets due for review and the new "Drip" assets for the day.
3.2.2. The Multi-Face Reveal: Each flashcard follows a strict retrieval sequence.
Face 1: The prompt (e.g., Target Language word).
Face 2 (Action): The Scholar attempts mental retrieval before tapping to reveal the translation/context.
Face 3-6: Secondary layers (Audio, Example Sentence, Mnemonic, or Grammatical Notes) are toggled as needed.
3.2.3. Semantic Triage: After the reveal, the Scholar must honestly assess their recall speed using four distinct labels:
Critical (Hard): Immediate re-queue within the current session.
Familiar (Not Familiar): Re-queue within 24 hours.
Proficient (OK): Standard SRS progression.
Mastered (Easy): Extended interval; potential candidate for The Vault.

3.3. The Discipline Framework
Professionalism requires consistency. The app enforces a Boundary-Based Discipline model.
3.3.1. The Curfew (Boundary Setting): Scholar-defined daily "End of Operations."
3.3.2. The Ice State: Cognitive priming via cold-palette shift one hour prior to Curfew.
3.3.4. The Director’s Pardon (Institutional Forgiveness): To prevent churn due to genuine emergencies (flight delays, medical issues), Scholars may invoke a "Pardon" once per 180-day cycle. This preserves the streak but requires a Double-Intensity Remediation Session (reviewing 2x the normal load) to "re-validate" the standing within the Institute.
3.3.3. The Ash Protocol (Synchronized Finalization): Streak resets are server-verified via NTP. However, to support Offline Study (e.g., in-flight), the app implements a "Synchronized Finalization" rule.
The Rule: A Scholar may complete their session offline. The device generates a Cryptographic Proof of Completion timestamped and signed by the Secure Enclave.
Verification: Upon reconnection, the server audits this local timestamp. If the completion occurred before the local Curfew, the streak is preserved. If the signature is invalid or the timestamp is post-curfew, the Ash Protocol is triggered.


3.4. Executive Certification
The Institute provides tangible proof of intellectual growth.
3.4.1. Milestone Verification: Every 50 assets moved to The Vault triggers a "Milestone Assessment."
3.4.2. The Proficiency Report: The app generates an automated Proficiency Report (PDF/JPEG). This is not a "badge" but a sophisticated, minimalist dossier listing words mastered, proficiency level, and a verification signature from the Chancellor.
3.4.3. Institutional Integration: A one-tap "Post to Professional Record" feature allows Scholars to instantly upload their certification to LinkedIn or their company’s Learning Management System (LMS).

CHAPTER 4: CORE FUNCTIONAL MODULES
The Core Modules represent the internal "machinery" of the Institute. They are designed to manage the flow of information from raw data to long-term cerebral storage, ensuring the Knowledge Base remains structured and accessible.

4.1. The Knowledge Base (The Library)
The Library is a high-density relational database serving as the primary repository for the Institute’s linguistic assets. It manages the "Huge CSV" with mathematical precision to ensure data integrity across all scholarly activities.
4.1.1. Semantic Tiering (CEFR A1–C2): All assets are categorized strictly according to the Common European Framework of Reference for Languages. This ensures that progress is measurable against global academic standards.
4.1.2. Relational Mapping & Integrity Layer: Every concept is assigned a unique Asset_ID, mapping it across all six language columns simultaneously. Before commitment, assets are cross-referenced against a Relational Integrity Schema to prevent "orphan" data and ensure identical context across L1–L6 pivots.
4.1.3. Cognitive Load Balancing (The 200-Word Batch): To prevent cognitive fatigue and "over-learning," the system enforces a strict 200-asset limit for the Active Batch. A 201st asset cannot be ingested until a current asset is mastered and archived to the Vault.
4.1.4. Automated Drip & Version Control: New assets are injected into the curriculum based on the Scholar’s Daily Drip settings. The Library utilizes Checksum-based Version Control to detect changes in the master file, allowing for incremental local updates without data duplication or redundancy.



4.2. The Cognitive Lab (Active Retrieval Engine)
The Lab is where study happens. It uses randomized, high-engagement modes to ensure the brain does not "habituate" to a single testing style.
4.2.1. Advanced Cloze-Deletion: For scholars at the B2 level and above, the Lab removes key words from professional or literary sentences. The Scholar must recall the exact form of the word based on the surrounding syntactic context.
4.2.2. Rapid Recognition Drills: High-speed sessions designed to test the Scholar’s "First Impression" recall. This builds the reflex required for real-world conversation.
4.2.3. Encoding Practice (Reverse Ciphers): The Scholar is presented with their base language and must mentally (or via input) translate it back into the target language, reversing the standard recognition path.
4.2.4. Semantic Variety: The engine dynamically cycles these modes during a session to ensure the brain stays in a state of "Desirable Difficulty."

4.3. The Mastery Archive (The Vault)
The Vault is the terminal point for the Active Batch. It is the digital equivalent of a permanent filing cabinet.
4.3.1. Knowledge Persistence: When an asset is marked "Easy" across multiple review cycles, it is officially "Mastered" and moved to the Vault. This frees up a slot in the Active Batch.
4.3.2. Re-validation Drills: At set intervals (3 months, 6 months, 1 year), the system triggers a "Vault Audit." The Scholar must successfully recall a archived word to ensure it has not faded.
4.3.3. Re-deployment Logic: If a Vault word is failed during an audit, it is instantly re-deployed into the Active Batch for remediation.

4.4. Peer Insights (Collaborative Mnemonics)
To facilitate learning, the Institute allows for controlled, peer-vetted information sharing.
4.4.1. Mnemonic Repository: Scholars can submit "Memory Hacks" (mnemonics) for difficult words.
4.4.2. Scholarly Endorsements: Rather than a "Like" button, peers "Endorse" (upvote) the most effective insights. The top 2 endorsed insights are displayed on the secondary faces of the flashcard.
4.4.3. Quality Control: To maintain a professional environment, mnemonics are only visible to Scholars studying in the same base-language/target-language pair.

4.5. The Global Directory (The Decoder)
The Decoder is the Institute's primary research and manual curriculum-adjustment tool, utilizing high-performance local indexing for instantaneous results.
4.5.1. Advanced Multi-Linguistic Full-Text Search (FTS): The directory utilizes native Language-Aware FTS (Postgres/SQLite) to provide a 100% local, zero-latency search experience.
Stemming Logic: Integrated support for the six core languages allows the system to recognize word roots (e.g., "running" and "ran" are indexed as the same concept).
Trigram Indexing: Implementation of trigram-based Fuzzy Matching handles typographical errors and approximate spellings, ensuring the Scholar finds the correct asset even with imperfect input.
4.5.2. Contextual Extraction & Comparative Study: The Decoder allows for Simultaneous Referencing, revealing a word's mapping across all six languages on a single screen. It displays every example sentence associated with the asset, providing a holistic view of usage across CEFR tiers.
4.5.3. Manual Curriculum Injection: Scholars may search for specific terms encountered in external field-work and utilize the INJECT TO BATCH protocol. This prioritizes the found asset in the next Daily Drip, bypassing the standard linear curriculum order.

CHAPTER 5: VISUAL & INTERACTION DESIGN
The Institute’s visual language is rooted in Swiss Modernism and Ligne Claire (clear line) illustration. The goal is to eliminate "UI noise" and create a digital environment that feels like a premium, physical workstation.

5.1. Swiss Modernist Design Ethos
We adhere to the principles of the International Typographic Style: cleanliness, readability, and objectivity.
5.1.1. Grid Systems & Structural Harmony: Every screen is built on a mathematically precise grid (8px base). This ensures that information density is balanced and that the interface remains predictable across all device sizes.
5.1.2. Typographic Hierarchy: We utilize high-legibility sans-serif typefaces (e.g., Inter or Helvetica Neue).
Weights: Bold for headers, Regular for primary text, and Light for secondary metadata.
Purpose: To guide the Scholar's eye instantly to the "Recall Trigger" without distraction.
5.1.3. Ligne Claire Illustration Guidelines: All character and icon assets utilize uniform, thick black outlines with no hatching or shading. This provides a professional, "architectural" feel that distinguishes the app from the "sketchy" or "cartoonish" style of competitors.
5.1.4. Universal Scholar Accessibility (WCAG 2.1): The design must support Dynamic Type (font scaling) and Screen Reader Compatibility. Contrast ratios are maintained at a minimum of 4.5:1 to ensure the Institute is accessible to scholars with visual impairments, meeting institutional and B2B procurement standards.


5.2. Adaptive Environmental UI States
The interface is not static; it responds to the Scholar's progress and the reality of the daily schedule.
5.2.1. Focus Mode (Neutral Daylight): The default state for daytime operations. It utilizes a palette of Paper White (#F5F5F5), Ink Black (#1A1A1A), and Primary Teal (#008080). This provides maximum contrast for reading during peak cognitive hours.
5.2.2. Deep Work Mode (Night Recon): When the system detects a low-light environment or the user manually toggles "Deep Work," the UI shifts to a dark-mode palette: Slate Grey (#2F2F2F) and Soft Ivory (#E5E5E5) text. This reduces eye strain and signals a period of intense focus.
5.2.3. Accountability UI (The "Ice" Transformation): One hour before the Curfew, the UI begins a gradual color-shift. All warm or neutral accent colors (Teals, Yellows) are replaced by Glacier Blue (#B0E0E6). This serves as a constant, peripheral visual reminder that the window for daily study is closing.

5.3. The Chancellor (The Professional Interface)
The Chancellor is the visual anchor of the Institute, providing feedback that is encouraging yet strictly professional.
5.3.1. Visual Representation: A refined, minimalist figure in Ligne Claire style. The Chancellor’s expressions are subtle—a slight nod for a successful streak, or a stern, analytical look during a "Cool Down" session.
5.3.2. Contextual Guidance Logic: The Chancellor does not provide generic "good job" messages. Instead, feedback is data-driven: "Scholar, your retention of B2 Medical terms has increased by 15% this week. Maintain this trajectory."
5.3.3. Administrative Alerts: When the Ash Protocol is triggered, the Chancellor appears in a high-contrast, somber UI state to deliver the reset notification, reinforcing the weight of the lapse in discipline.

CHAPTER 6: DATA PRIVACY & SECURITY PROTOCOLS
In a professional and academic environment, data is a high-value asset. The Institute treats the Scholar’s learning progress and personal identifiers with the same rigor as a financial institution. Our security architecture is designed to prevent data exfiltration and ensure total privacy.

6.1. Encryption Standards & Key Management
We employ military-grade encryption to protect the Knowledge Base and the Scholar’s local progress ledger.
6.1.1. Local At-Rest Encryption: The local SQLite database is encrypted using SQLCipher (AES-256). This ensures that even if the physical device is compromised, the data remains unreadable without the specific cryptographic key.
6.1.2. Hardware-Backed Security: We do not store encryption keys in the application code. Keys are generated and stored within the device’s Secure Enclave (iOS) or Hardware-Backed Keystore (Android). This provides hardware-level isolation, making it virtually impossible for malware to extract the master key.
6.1.3. JSON Payload Obfuscation: All data transmitted between the device and the Institute’s servers (Ghost Backups) is obfuscated and signed. This prevents "Man-in-the-Middle" attackers from reading or tampering with the progress data.

6.2. Network Security & Communication
Communications between the Scholar’s workstation (the app) and the Institute’s infrastructure are hardened against interception.
6.2.1. TLS 1.3 & Certificate Pinning: We utilize the latest TLS 1.3 protocol for all transit. Additionally, Certificate Pinning is implemented to ensure the app only communicates with our verified servers, preventing interception via rogue certificates.
6.2.2. JWT Authentication & Refresh Cycles: Authentication is handled via JSON Web Tokens (JWT). To minimize the window of risk, access tokens have a short lifespan, requiring frequent, silent "Refresh" cycles that utilize secure, single-use refresh tokens.
6.2.3. HMAC Request Verification: Every API request is signed with a Hash-based Message Authentication Code (HMAC). This ensures that the request originated from the official app and has not been modified during transit.

6.3. Identity Management (SSO)
For institutional and corporate deployments, we eliminate the risk of password fatigue and unauthorized access through modern identity protocols.
6.3.1. Single Sign-On (SSO): Full integration with Okta, Azure AD, and Google Workspace via SAML 2.0 or OIDC. This allows Scholars to use their existing professional credentials, ensuring that access is immediately revoked if they leave the institution.
6.3.2. SCIM Provisioning: We support the System for Cross-domain Identity Management (SCIM) to automate the onboarding and offboarding of Scholars at scale.

6.4. Institutional Compliance & Data Rights
The Institute is fully compliant with global data protection regulations, ensuring that the Scholar remains in control of their information.
6.4.1. GDPR/CCPA Sovereignty: We provide a "Right to Erasure" protocol within the Settings. A Scholar can initiate a Permanent Deletion, which wipes their UID from the Supabase backend and triggers a local database purge.
6.4.2. RASP (Runtime Application Self-Protection): The app includes a RASP layer that detects if it is being run in a compromised environment (e.g., a rooted or jailbroken device). If a threat is detected, the app automatically wipes sensitive local keys to protect the intellectual property.
6.4.3. Anonymized Analytics: No PII (Personally Identifiable Information) is used for performance tracking. Analytics are aggregated at the institutional level to provide "Trend Intel" without compromising individual privacy.

CHAPTER 7: B2B & INSTITUTIONAL UTILITY
This final chapter outlines how the Institute scales from an individual workstation to a global organizational asset. It provides the tools necessary for administrators, lecturers, and HR departments to integrate the Institute into their professional training ecosystems.

7.1. Professional Certification & Credentialing
The Institute validates linguistic mastery through high-fidelity, data-backed documentation.
7.1.1. Automated Proficiency Report Generation: Upon reaching milestones (e.g., 100, 500, 1000 Mastered Assets), the system generates a formal Dossier. This includes a detailed breakdown of CEFR levels achieved, consistency metrics, and a timestamped audit trail of the Scholar’s "Vault" re-validations.
7.1.2. Branded Institutional Endorsements: For university partnerships, certificates can be co-branded with the institution’s seal and signed by the Chancellor, serving as official proof of credit hours or professional development.
7.1.3. Professional Network Integration: A native integration with LinkedIn Licenses allows Scholars to display their "Active Proficiency" as a live-updating credential on their professional profile.

7.2. Corporate & Academic Administration
Large-scale deployments are managed through a centralized, high-security administrative interface.
7.2.1. Managerial Dashboard Connectivity: Administrators have access to a web-based portal that monitors aggregate progress. It provides a heat-map of linguistic gaps within a department without revealing individual Scholar secrets.
7.2.2. Bulk Licensing & Enrollment Flows: Using the SCIM Provisioning protocol discussed in Chapter 6, organizations can deploy the Institute to thousands of employees simultaneously. Licenses are managed dynamically, allowing for "Seat Recycling" as project needs change.
7.2.3. Aggregate Performance Analytics: The dashboard tracks "Organization Fluency Levels"—anonymized data that helps HR directors justify training budgets by showing real-world increases in workforce communication capacity.

7.3. Institutional Content Customization
The Institute can be tailored to the specific technical needs of a professional field.
7.3.1. Proprietary Lexicon Ingestion: Institutions can upload their own "Field Manuals" (e.g., Medical terminology for hospitals, Legal jargon for law firms, or Engineering specs). These are processed by the engine and "Dripped" into the relevant team's curriculum.
7.3.2. Departmental Knowledge Groups: Admins can segment their organization into "Knowledge Groups." A marketing team in Berlin may receive a different "Drip" of target assets than a technical support team in Istanbul.
7.3.3. Custom Institutional Branding: The "Chancellor" interface and the UI color palette can be adjusted to match an organization’s corporate identity, fostering a sense of internal continuity.
7.3.3. The Faculty Persona Layer: Institutional admins may customize the "Chancellor" interface to align with their pedagogical culture. This includes:
Visual Identity: Co-branding the persona (e.g., "The Dean" for universities or "The Lead Consultant" for corporate firms).
Tone of Voice: Adjusting feedback thresholds from "Analytical & Strict" to "Encouraging & Academic" based on the specific learner demographic.

7.4. Service Level & Compliance (The Guarantee)
To ensure the Institute remains a reliable professional tool, we provide enterprise-grade assurances.
7.4.1. Performance SLAs: We guarantee 99.9% uptime for the Master Lexicon and Sync servers, ensuring that the Scholar's "Deep Work" is never interrupted by system failure.
7.4.2. Data Processing Agreements (DPA): We provide standardized DPAs that align with institutional requirements for data handling, ensuring that legal teams can clear the Institute for deployment in highly regulated sectors.
7.4.3. Transparency Logs: Administrators can access audit logs of all data-sync events and security challenges, ensuring the integrity of the institution's intellectual property.

Linguistic Mastery through Professional Rigor
The Vision
The Institute is a high-performance language acquisition platform designed to replace "casual gamification" with Academic Discipline. Built on Swiss Modernist design principles and Ligne Claire illustration, it provides a focused "Deep Work" environment for serious scholars and corporate professionals.

The Core Innovation: "Accountability-as-a-Service"
Unlike competitors that use dopamine-driven "streaks" that can be frozen or cheated, The Institute utilizes the Ice & Ash Protocol:
The Curfew: A user-defined boundary that triggers a psychological UI shift (The Ice State).
The Ash Reset: A hard, server-verified reset for missed sessions. No freezes. No second chances. Consistency is the only metric for success.

Technical Pillars
1. Local-First / Cloud-Second Architecture
Engine: High-performance SQLite database with SQLCipher (AES-256) encryption.
Privacy: Hardware-backed key management (iOS Keychain / Android Keystore).
Scalability: Supabase (PostgreSQL) backend for global synchronization and enterprise-grade SSO (Okta/Azure AD) integration.
2. The Cognitive Engine (SRS 2.0)
The 200-Word Active Batch: A strict limit on cognitive load; new words are "Dripped" into the curriculum only as others are mastered and moved to The Vault.
Active Retrieval: A "Multi-Face Reveal" UI that prioritizes high-effort recall over simple multiple-choice recognition.
3. Institutional Interoperability
Custom Lexicons: B2B capability to ingest proprietary jargon (Medical, Legal, Technical) into a specialized curriculum.
Certification: Automated generation of professional Proficiency Dossiers for LinkedIn and LMS integration.

The Competitive Advantage
Feature
Casual Apps
The Institute
UX Design
Playful / Cartoonish
Minimalist / Swiss Modern
Logic
Gamified Dopamine
Professional Accountability
Content
General Travel
Academic & Specialized (CEFR A1-C2)
Privacy
Data Tracking
Local-First / Enterprise SSO


Strategic Roadmap
Phase I (Beta): Deployment to 50 "Alpha Scholars" for SRS logic refinement.
Phase II (The Heist): Product Hunt launch focusing on the "Anti-Duolingo" design ethos.
Phase III (B2B): Pilot programs with European universities and multinational HR departments.

This is the final technical bridge. By codifying these standards, we eliminate "creative drift" and ensure the software operates with the same cold, architectural precision as a Swiss timepiece.
We shall designate this as CHAPTER 8: THE ARCHITECTURAL BLUEPRINT.

CHAPTER 8: THE ARCHITECTURAL BLUEPRINT
8.1. The Standardized Constants (The Style Guide)
To maintain the Swiss Modernist aesthetic, these values are immutable. There are no gradients; there is only clarity.
Category
Constant Name
Hex Value / Value
Usage
Color
kPaperWhite
#F5F5F5
Primary Background (Day)
Color
kInkBlack
#1A1A1A
Primary Text & Ligne Claire Outlines
Color
kPrimaryTeal
#008080
Interactive Elements / Call to Action
Color
kGlacierBlue
#B0E0E6
Ice State Overrides (Curfew)
Color
kSlateGrey
#2F2F2F
Deep Work Background (Night)
Color
kAshGrey
#707070
Secondary Text / Vaulted Items
Spacing
kBaseUnit
8.0
All margins/padding must be multiples of 8
Animation
kStandardCurve
Curves.easeInOut
Standard transition for UI shifts


8.2. Database Architecture (The Ledger)
We utilize SQLite with the FTS5 extension for high-performance, offline-first operations.
8.2.1. SQL Schema: Core Tables
SQL
-- The Master Lexicon (Static Data)
CREATE TABLE assets (
    id TEXT PRIMARY KEY,
    cefr_level TEXT NOT NULL, -- A1, B2, etc.
    l1_term TEXT, -- Base Language (e.g., English)
    l2_term TEXT, -- Target Language (e.g., Turkish)
    l3_term TEXT, -- German
    l4_term TEXT, -- French
    l5_term TEXT, -- Italian
    l6_term TEXT, -- Spanish
    example_sentence TEXT,
    cloze_mask TEXT -- Masked sentence for Lab drills
);

-- Scholar Progress (Dynamic User Data)
CREATE TABLE scholar_progress (
    asset_id TEXT PRIMARY KEY,
    status TEXT DEFAULT 'DRIP', -- DRIP, ACTIVE, VAULT
    srs_interval INTEGER DEFAULT 0,
    ease_factor REAL DEFAULT 2.5,
    next_review_at DATETIME,
    last_pardon_at DATETIME,
    FOREIGN KEY (asset_id) REFERENCES assets(id)
);

-- Secure Metadata
CREATE TABLE session_logs (
    id INTEGER PRIMARY KEY,
    session_date DATE UNIQUE,
    is_completed INTEGER DEFAULT 0,
    signature TEXT -- Cryptographic proof for Ash Protocol
);


8.2.2. FTS5 Search Setup
SQL
-- Virtual Table for Multi-Language Search
CREATE VIRTUAL TABLE assets_search USING fts5(
    asset_id,
    l1_term, l2_term, l3_term, l4_term, l5_term, l6_term,
    content='assets',
    tokenize='unicode61 remove_diacritics 1' -- Essential for Turkish/French
);

-- Trigger to keep Search in sync with the Library
CREATE TRIGGER assets_ai AFTER INSERT ON assets BEGIN
  INSERT INTO assets_search(asset_id, l1_term, l2_term, l3_term, l4_term, l5_term, l6_term)
  VALUES (new.id, new.l1_term, new.l2_term, new.l3_term, new.l4_term, new.l5_term, new.l6_term);
END;



8.3. Flutter Project Structure (Swiss-Clean)
The directory follows Domain-Driven Design, separating logic from the visual layer.
Plaintext
lib/
├── core/
│   ├── constants/        # palette.dart, typography.dart
│   ├── theme/            # swiss_theme.dart (Day/Night logic)
│   └── security/         # secure_enclave_service.dart
├── data/
│   ├── local/            # sqlite_client.dart, fts_engine.dart
│   ├── repositories/     # asset_repository.dart
│   └── models/           # asset_model.dart, progress_model.dart
├── domain/               # Business logic (Pure Dart)
│   ├── srs_logic.dart    # SM-2 Algorithm implementation
│   └── ash_protocol.dart # Verification logic
├── presentation/         # UI Layer (Flutter)
│   ├── chancellors_office/ # Onboarding & Profile
│   ├── lab/              # Active Retrieval screens
│   ├── decoder/          # Search interface
│   ├── vault/            # Mastery archive
│   └── shared_widgets/   # Ligne_claire_button.dart
└── main.dart



8.4. The Functional Map (Page-by-Page Blueprint)
To eliminate randomness, every page has a specific "Academic Purpose."
Page 1: The Chancellor’s Briefing (Home)
Purpose: Session initialization and discipline status.
UI Elements:
BriefingHeader: High-contrast greeting from The Chancellor.
DailyProgressGauge: Circular 8px stroke showing (Completed / Total Today).
StatusCard: Displays current "Streak" and "Curfew Time."
Functions: checkAshProtocol(), initializeDailyDrip().
Page 2: The Cognitive Lab (Study Engine)
Purpose: The active study loop.
UI Elements:
FlashcardStack: Ligne Claire card with "Face Reveal" mechanics.
FaceToggleButtons: Subtle bottom bar to reveal (Audio, Example, Note).
TriageBar: Four 8px grid-aligned buttons (Critical, Familiar, Proficient, Mastered).
Functions: triggerNativeTTS(), updateSRSInterval(), checkIceState().
Page 3: The Decoder (Global Search)
Purpose: Instant research and manual injection.
UI Elements:
SearchField: Minimalist input with auto-focus.
SimultaneousResultList: Grid showing all 6 languages for the result.
InjectButton: Action to move search result to "Active Batch."
Functions: runFTSQuery(), addToActiveBatch().
Page 4: The Vault (Archive)
Purpose: Reviewing long-term persistence.
UI Elements:
VaultGrid: Minimalist list of mastered words (Greyed out until hovered).
MilestoneBadge: Display of the 50-word Dossier.
Functions: generateProficiencyReport(), triggerVaultAudit().
Page 5: Institutional Settings (Admin)
Purpose: System configuration.
UI Elements:
CurfewPicker: Time selection for Discipline Framework.
IdentityManager: SSO login status.
PardonButton: Uses "Director's Pardon" if available.
Functions: updateCurfew(), wipeData().


CHAPTER 3.1.5: THE PRELIMINARY BRIEFING (ONBOARDING)
The first-ever page the user sees is a high-contrast, text-driven sequence designed to establish the gravity of the Institute. It is not skippable; it is the Foundational Briefing.
Page 0: The Initialization Sequence
The Visual: A blank kPaperWhite screen. The Chancellor (Ligne Claire illustration) appears in the center. A typewriter-style animation reveals the text.
The Content: 1. Welcome: "Scholar, welcome to the Institute. This is a workstation, not a playground."
2. The Mission: "We aim for mastery through architectural precision and Spaced Repetition."
3. The Warning: "Consistency is our only currency. If you fail to meet your Curfew, your progress will burn to Ash. We do not freeze streaks. We do not offer shortcuts."
The Interaction: A single, sharp kPrimaryTeal button: "I ACCEPT THE TERMS OF DISCIPLINE".
Step-by-Step Enrollment Flow
Identity Verification: Link to SSO or Professional Email.
Linguistic Mapping: The user selects their L1 (Base) and Target L2–L6.
The Curfew Setup: The user must select their daily deadline. The UI warns: "Choose wisely. This is when the Ice State begins."
The Initial Drip: The app performs a one-time sync of the first 20 assets from the Huge CSV to the Active Batch.

CHAPTER 8: THE ARCHITECTURAL BLUEPRINT (APPENDIX)
8.5. The Page-by-Page Logic Detail
Page Title
Primary Function
Core Button / Action
Technical Logic
0. Briefing
Mindset Alignment
"Accept Discipline"
Writes accepted_honor_code = 1 to SQLite.
1. Home
Daily Overview
"Begin Session"
Triggers fetchDailyBatch(); checks last_sync_time.
2. The Lab
Active Study
"Reveal / Triage"
Updates srs_metadata; triggers Native TTS.
3. Decoder
Research
"Inject to Batch"
Performs FTS5 search; moves word to status = 'ACTIVE'.
4. The Vault
Certification
"Generate Report"
Aggregates status = 'VAULT' rows into PDF/JPEG.


8.6. Detailed Page Blueprint (Logic & Buttons)
The Cognitive Lab (The Engine Room)
This is where 90% of the user's time is spent. To prevent randomness, the interaction is hard-coded:
Top Bar: Progress bar (8px height) showing (current_word_index / total_session_count).
Center Stage: The Asset Card. Minimalist. No distractions.
Interaction Logic:
Initial State: Target word is shown.
Action 1 (Reveal): Tap the card. Card flips using kStandardCurve.
Secondary Reveals: Four icon-only buttons appear at the bottom of the card: [Audio], [Example], [Mnemonic], [Grammar].
Action 2 (Triage): Four buttons at the bottom of the screen (Full Width).
CRITICAL: srs_interval set to 0. Word repeats in 5 minutes.
FAMILIAR: srs_interval set to 1 day.
PROFICIENT: srs_interval calculated by SM-2.
MASTERED: srs_interval maximized; moves toward The Vault.



User login- first page ever.
User login or sign in.


After gmail and /or phone verification

After that direct purcasing/subscription section.
3 subscription (1 monthly, 3 monthly x% discount, 6 monthly x% discount). 
1 one time purchase deal

Be strict: if you pay you study, at the end you learn.


This is the "Zero-Hour" for your user. To match your Vintage Noir / Archer aesthetic, the onboarding shouldn't feel like a tech company—it should feel like being recruited into an elite intelligence agency or a high-end mid-century university.
Here is the step-by-step breakdown of the entry flow, strictly designed to avoid ambiguity.

Visual Identity Palette (Consistent Throughout)
Background: "Manila Folder" Cream (#F5F5DC) with a subtle 5% Ben-Day dot texture.
Primary Action: "Oxblood Red" (#8B0000) buttons with white bold text.
Secondary Action: "Deep Teal" (#004B49) buttons.
Outlines: Consistent 3px solid Black on every element.
Typography: Bold Sans-Serif (e.g., Franklin Gothic or Futura).

Screen 1: The Entrance (Login/Sign-In)
This is the first screen the user ever sees. It should be high-impact.
Top 1/3 (The Branding):
Illustration: A Ligne Claire-style character (The Tutor) sitting at a mahogany desk, looking directly at the user with a stoic expression.
App Title: Large, bold, noir-style typography (e.g., "LINGUA NOIR" or your chosen name).
Middle 1/3 (The Motivation):
Text: "Decide to learn. Commit to the grind. No excuses."
Bottom 1/3 (The Actions):
Button A (Primary): [CONTINUE WITH GMAIL]
Design: White background, black outline, Gmail logo on the left.
Button B (Primary): [CONTINUE WITH PHONE]
Design: White background, black outline, phone icon on the left.
Footer Link: "Already have an account? Log In" (Simple underlined text).

Screen 2: The Checkpoint (Verification)
Once the user selects a method, they are funneled here to prove their identity.
Header: "IDENTITY VERIFICATION" (All caps, bold).
Sub-text: "We've sent a code to [User's Email/Phone]. Enter the 6-digit sequence to proceed."
The Input Area: * Six separate square boxes with thick black outlines.
As the user types, the numbers appear in a "Typewriter" style font.
The "No-Hassle" Buttons:
Button: [VERIFY CODE] (Oxblood Red, full width).
Text Link: "Didn't get a code? Resend" (Grayed out for 60 seconds, then turns Teal).
The "Noir" Detail: A small stamp at the bottom of the screen that says "SECURE CONNECTION ESTABLISHED" in a faded ink-stamp texture.

Screen 3: The Investment (The Paywall)
This is where you apply the "Strict" philosophy. The user cannot access the lexicon or flashcards until they commit.
Header: "SELECT YOUR DISCIPLINE"
The Manifesto (Small Text Block): > "Language is not a gift; it is a result. By investing today, you are telling your brain that there is no turning back. If you pay, you study. If you study, you learn."
The Pricing Cards (Vertical Stack):
Each card is a rectangle with a thick black outline and a 2px drop-shadow.
Plan
Visual Design
Price Label
1 Month
Simple Cream background.
$XX.XX / month
3 Months
Most Popular Tag in Teal.
$XX.XX / month (Save 15%)
6 Months
Best Value Tag in Oxblood Red.
$XX.XX / month (Save 30%)
One-Time
"LIFETIME ACCESS" in Gold-tinted card.
$XXX.XX (Once and Forever)


The Action Button: * Button: [COMMENCE INVESTMENT]
Placement: Sticky at the bottom of the screen.
Legal/Small Print: Standard "Restore Purchase" and "Terms of Service" links at the very bottom in 10pt font.

Logic & Strictness Rules
The Pay-to-Play Gate: There is no "Skip" or "Later" button on Screen 3. The only way to reach the Dashboard is through a successful transaction or a "Restore Purchase" check.
Visual Consistency: If a user clicks a button, it should have a "pressed" animation where the drop-shadow disappears, mimicking a physical button on a mid-century machine.
The Tone: Every piece of micro-copy (the small text) should be firm. Instead of "Loading...", use "Synchronizing Lexicon..." or "Preparing Curriculum...".

What Happens Next?
Once the payment is confirmed, the screen should fade to black, and the Dashboard (Home Tab) we discussed previously should "iris-in" (like an old film transition), showing the 0/200 progress ring for the first time.
Would you like me to detail the "Lexicon" tab next—specifically how the multi-level categories (B1-Travel, B2-Business) are displayed and "ticked" into the active deck?



1. Page: The Intelligence Briefing (Initial Setup)
This is a one-time flow immediately after the paywall. It prevents the user from landing on a blank Dashboard.
Step 1: The Base Language: "What is your primary tongue?" (User selects 1 of the 6).
Step 2: The Target Selection: "Which languages are we deploying?" (User toggles the others).
Step 3: The Face Order: This is crucial for your multi-face logic.
Visual: A vertical drag-and-drop list.
Action: User moves the languages into their preferred reveal order (e.g., 1. English, 2. German, 3. Spanish).
Step 4: The App Language: Choosing the UI language for the "Motivation Messages."

This is the Intelligence Briefing. It is the bridge between the user paying and the user learning. To stay consistent with your Vintage Noir / Archer aesthetic, this isn't a "settings menu"—it is a Psychological Profile & Deployment Order.

General Visual Standards (Consistency Check)
Background: Light Cream (#F2EFE9) with a subtle 10% Ben-Day dot texture.
Outlines: 3px Solid Black on all buttons, containers, and icons.
Shadows: 4px Hard Block Shadows (Offset: 4px Right, 4px Down).
Typography: Franklin Gothic Heavy (Headers/All Caps), Futura Medium (Body/Instructions).
Primary Action Button: Oxblood Red (#8B0000).

1. Page: The Intelligence Briefing (Setup Flow)
A. Header & Progress Indicator
Visual: A thick black horizontal line at the top. Above it, in small text: OPERATIVE STATUS: UNINITIALIZED.
Progress Bar: A thin Slate Blue bar that fills as the user completes the 4 steps. It is styled like a "Radio Frequency" wave that flattens as it nears 100%.

B. Step 1: The Base Language ("Primary Tongue")
Prompt: "IDENTIFY YOUR PRIMARY TONGUE."
Visual: A 2x3 grid of large circular buttons.
Icons: Each button contains a Ligne Claire style flag icon (simplified, no gradients).
Interaction: * Default State: White background, 3px black outline.
Selected State: The circle turns Mustard Yellow (#E1AD01). The flag icon gets a thick white highlight.
Logic: The user can only select one. This language will be the "Front" of your flashcards by default.

C. Step 2: Target Selection ("Theaters of Operation")
Prompt: "SELECT TARGET THEATERS FOR DEPLOYMENT."
Instruction: "Which languages are you here to master?"
Visual: The same 2x3 grid, but the remaining 5 languages (excluding the one chosen in Step 1) are active.
Interaction: * Toggled Off: Muted grey version of the flag icon.
Toggled On: The circle turns Deep Teal (#004B49). A small white checkmark appears in the bottom-right corner of the circle.
Logic: Multi-select. Users can select 1 or all 5.

D. Step 3: The Face Order ("The Reveal Sequence")
This is the most critical technical step for your multi-face flashcard logic.
Prompt: "ESTABLISH THE REVEAL SEQUENCE."
Visual: A vertical list of rectangular blocks. Each block represents a language selected in Step 2.
Design: Each block looks like a Dossier Tab. On the left is the language name; on the right is a "Grip" icon (three horizontal lines).
Interaction: Drag-and-Drop.
The user holds the "Grip" and slides the language up or down.
The order here directly translates to the Flashcard Tab.
Example: If the order is 1. German, 2. Spanish, the card will show English (Base) -> Tap -> German -> Tap -> Spanish -> Tap -> Examples.

E. Step 4: The App Language ("UI Communication")
Prompt: "SELECT INTERFACE COMMUNICATION LANGUAGE."
Instruction: "All coaching and 'Tough Love' messages will be delivered in this tongue."
Visual: A simple vertical list of the 6 languages with radio-button circles.
Design: High-contrast, black text on cream. The selected radio button is an Oxblood Red dot.

2. The Final Activation: "Commence Mission"
Visual: A large, full-width button at the bottom of the screen.
Color: Oxblood Red.
Label: COMMENCE MISSION (All Caps, Bold White).
Sub-text: [NO RETREAT. NO EXCUSES.]
Animation: Upon clicking, the screen doesn't just switch; it should have a "Shutter" animation (like a camera lens closing and opening) to transition into the Home Tab (Dashboard).

3. Technical Specifications & UI Logic (No Room for Interpretation)
Element
Component Type
Default Behavior
Grid Buttons
Toggleable Circles
3px stroke must remain consistent even when selected.
Dossier Tabs
Reorderable List
Use "Long-press to lift" haptic feedback.
Back Button
Arrow Icon (Top Left)
Allows the user to go back and change Step 1 or 2 without losing Step 3's data.
Logic Gate
Verification
The "Commence Mission" button is Disabled (Greyed Out) until at least one target language (Step 2) is selected.


The "Coach" Integration
During this setup, the Ligne Claire Tutor (the stoic, Archer-style character) should be visible in a small circular window at the bottom left, offering brief commentary in speech bubbles:
Step 1: "Don't lie to me. Where were you born?"
Step 3: "Order is everything. Put your priority at the top."
Final Step: "The contract is signed. Let's begin."
Would you like me to move on to detailing "The Vault" (Mastered Word Archive) and how the "Re-deploy" logic works for words you've already learned?

To maintain our Intelligence Agency theme, we won’t call it a "Help" section. We will call it "THE FIELD MANUAL." This section is best placed as a secondary layer within the Stats & Motivation (The "You Are Ready" Hub) tab. It serves as the psychological and tactical guide for the operative (the user).

Placement: The "Field Manual" (Inside Stats Tab)
Visual: At the very bottom of the Stats & Motivation tab, below the Progress Bars, there is a large, square button designed like a Pocket Handbook.
Label: ACCESS FIELD MANUAL
Design: A thick black outline, Deep Teal background, with a minimalist white icon of a compass or an open book.

Content: The Operational Protocol (FAQ & Effectiveness)
Once tapped, it opens a vertical scrolling "Dossier" with the following sections:
1. The "Ice & Ash" Protocol (The Streak FAQ)
"Why is my flame blue?"
The Intel: At your chosen Curfew Hour (default 18:00), the app checks if you’ve finished your daily 20 words. If not, the flame turns to Ice. This is a tactical warning: you are in the "Danger Zone."
The Consequence: If the clock hits 00:00 (Midnight) and the session isn't done, the streak becomes Ash.
The Rule: There are no "Streak Freezes." There are no "Backdates." An agent who makes excuses doesn't learn.
2. The Reveal Sequence (Effectiveness Tip)
"How do I use the Multi-Face cards effectively?"
The Strategy: Do not reveal all languages at once.
Step-by-Step: 1. Look at the Source word.
2. Try to visualize the Target word in your mind.
3. Reveal only one target language.
4. If you have a 3rd language, try to translate from the 2nd to the 3rd before tapping again.
The Result: This "Interleaved Practice" forces your brain to build multiple neural pathways for the same concept.
3. The "200-Word Cap" Logic
"Why can't I add more words?"
The Intel: Research shows that "Focus" is a finite resource. By capping your active batch at 200 words, we ensure you actually master them instead of just glancing at them.
The Solution: If you want new words, you must prove you know the current ones. Label them "Easy" to move them into the Vault and clear space in your deck.
4. The "Really Hard" Button (The Grit Factor)
"Should I be afraid of the Red button?"
The Strategy: No. The "Really Hard" button is your best friend.
The Logic: Tagging a word as "Hard" isn't a failure; it tells the SRS Algorithm to prioritize that ID. You will see it again in 60 seconds. Embrace the struggle—that is where the "re-wiring" happens.

5. Tactical Tips for Maximum Fluency
Objective
Operational Advice
Phonetic Mastery
Always tap the Ear Icon and repeat the word out loud before moving to the next face. Silence is the enemy of speech.
Contextual Link
When you reach the Example Sentences, read them twice. Once for meaning, and once to see how the "Word Type" (Verb/Adj) sits in the structure.
Batch Discipline
Do your 20 words at the same time every day. Routine creates a "Trigger" in the brain that makes memorization 40% faster.


The "Coach" Integration (The Manual's Voice)
Throughout the Field Manual, the Ligne Claire Tutor appears in the margins with "Direct Feedback":
"Stop looking for a 'Reset' button. In the real world, there isn't one. If you miss a day, own the ash."
"You're not here to collect words like stamps. You're here to use them like weapons. Quality over quantity, Operative."

Technical Specification
Searchable Index: At the top of the Field Manual, include a "Search Intel" bar so users can quickly find answers like "Payment" or "Change Language."
Visual Consistency: Use the same 3px Black Outlines and Cream/Teal/Red color palette.
Exit Strategy: A prominent [CLOSE MANUAL - RETURN TO MISSION] button at the bottom of the scroll.
Would you like me to create a "Launch Checklist" for you now, summarizing everything from the login screen to the final settings, so you can see the entire user journey in order?



2. Page: The Vault (Mastered Word Archive)
When a word is labeled "Easy," it disappears from the active deck. Users often get anxious that they’ll forget it forever. The Vault gives them peace of mind.
Visual: Designed like a high-security safe or a library archive.
Function: A searchable list of every word the user has marked "Easy."
The "Quick Review" Feature: A button to run a "Refresh Session" of 10 random Mastered words just to keep them fresh.
The "Re-deploy" Button: If the user feels they've forgotten a "Mastered" word, they can hit a button to send it back to the Lexicon as "Not Familiar."

The Vault is the user’s "safety net." To maintain the Vintage Noir / Archer aesthetic, we will design this as a high-security Cold War-style Archive. It is where words go once they are mastered, kept in "deep storage" but always available for retrieval.

1. General Visual Standards (Consistency Check)
Background: Steel Grey-Blue (#4A5D6A) with a heavy "Grainy" texture. This distinguishes the Vault from the "Manila" feel of the active Lexicon.
Outlines: 3px Solid Black on every element.
Shadows: 4px Hard Block Shadows (Black).
Typography: Franklin Gothic Heavy (Headers), Typewriter-style font (for the "stored" words to look like archived documents).

2. Page: The Vault (Archive Interface)
A. The Header: "Archive Status"
Visual: A horizontal bar at the top, styled like a steel plate with rivets.
Title: THE VAULT: SECURE ASSETS (White text, black outline).
The Asset Counter: A circular gauge in the center showing the total number of words labeled "Easy."
Label: 942 WORDS SECURED.
The "Safe Dial" Icon: A small, rotating safe-dial graphic in the top-right that spins briefly when the page loads.
B. The "Decoder" Search Bar
Visual: A rectangular input field with a thick black outline.
Placeholder Text: SEARCH ARCHIVES...
Design: A small magnifying glass icon on the left, styled with the Ligne Claire thick-line look.
Behavior: As the user types, the list below filters in real-time.

C. The "Quick Review" Station (Top Action)
This sits directly below the search bar, making it the most accessible action.
Button Shape: A large horizontal rectangle with a Mustard Yellow (#E1AD01) background.
Button Label: INITIATE RE-VALIDATION SESSION (All Caps, Bold Black).
Sub-text: [10 RANDOM ASSETS • 2 MINUTE DRILL]
Function: Tapping this launches a mini-flashcard session of 10 random "Easy" words to ensure the user hasn't grown rusty. It does not change their "Easy" status unless the user manually re-labels them.

D. The Asset List (Scrollable Archive)
The words are presented as a vertical list of "Index Cards."
Card Design: Thin horizontal rectangles with a white-to-grey gradient and a grainy Ben-Day dot pattern.
Information on Card:
Left Side: The word in the Source Language (e.g., “EXECUTIVE”).
Center: A row of small, circular flag icons representing the target languages mastered for this word.
Right Side: A "Re-deploy" icon (an arrow pointing out of a box).

3. The "Re-deploy" Logic (Individual Word Retrieval)
If a user clicks on a word in the list or the "Re-deploy" icon:
Action: A pop-up menu appears styled like a "Top Secret" Stamp.
Prompt: RE-DEPLOY TO ACTIVE STATUS?
Reasoning: "This word will be moved back to the Lexicon and labeled as 'Not Familiar'."
Button 1: [CONFIRM RE-DEPLOY] (Oxblood Red).
Button 2: [KEEP IN VAULT] (Dark Grey).
Result: If confirmed, the word is removed from the Vault and injected back into the next 200-word batch in the Lexicon.

4. Technical Specifications & UI Logic
Element
Component
Logic / Constraint
Search Bar
Text Input
Must search across all 6 language columns in the CSV simultaneously.
Asset Cards
List Item
Tapping the card expands it to show the full "Faces" (Example sentences) without leaving the Vault.
Quick Review
Randomizer
Pulls from the "Easy" list only. If "Easy" count is <10, it pulls all available.
Visual State
Empty State
If 0 words are mastered, display a Ligne Claire graphic of an empty safe with the text: "THE VAULT IS EMPTY. START STUDYING."


5. Summary of Buttons & States
Archive Search: Transparent background with black outline; turns Mustard Yellow when active.
Re-validation Button: Mustard Yellow; "sinks" into shadow when pressed.
Re-deploy Button: Oxblood Red; triggers a confirmation haptic (short vibration).
Language Flags: 20px circles; high contrast; Ligne Claire style.

The "Coach" Integration (Vault Edition)
The Ligne Claire Tutor appears in the bottom-right corner, wearing a dark trench coat or spectacles:
"Your memory is a fortress. 942 bricks and counting."
"Don't be ashamed to re-deploy. Even the best agents need a refresher."
Would you like me to detail "The Decoder" (Global Search) next—explaining how the 6-language simultaneous search and the "Manual Injection" into batches work?





3. Page: The Decoder (Global Search)
Because you have a "huge CSV," the user will eventually want to use the app as a quick reference or dictionary.
Visual: A clean, minimalist search interface with a thick black border.
Search Logic: As the user types, it searches across all 6 languages simultaneously.
Result Card: Shows the word, its type, the example sentences, and its current status (e.g., "Not yet learned" or "Mastered").
Interaction: Tapping a search result allows the user to manually "Tick" it into their next batch.

The Decoder serves as the app’s internal intelligence database. It transforms a standard search function into a sleek, Mid-Century "Cipher-Breaking" interface. It allows the user to treat your massive CSV as a live dictionary while simultaneously acting as a manual entry point for new study material.

1. General Visual Standards (Consistency Check)
Background: Light Cream (#F2EFE9) with 10% Ben-Day dot stippling.
Outlines: 3px Solid Black on all UI elements.
Shadows: 4px Hard Block Shadows (Black).
Typography: Franklin Gothic Heavy for headers; Futura Medium for search results; Typewriter font for "Status Stamps."

2. Page: The Decoder (Global Search Interface)
A. The Header: "Signal Intercept"
Visual: A thick black horizontal line at the top.
Title: THE DECODER: UNIVERSAL SEARCH (Franklin Gothic Heavy, All Caps).
Icon (Right): A minimalist Ligne Claire magnifying glass with a thick black rim and a single "shimmer" line on the lens.
B. The Main Input (The Cipher Field)
Visual: A large, centered rectangular text box.
Design: White background, 3px solid black outline, 4px block shadow.
Placeholder Text: INPUT KEYWORD OR PHRASE...
Behavior: * Focus State: When the user taps, the border turns Mustard Yellow (#E1AD01).
Real-time Logic: Results populate immediately after the 2nd character is typed. It scans all 6 columns (EN, DE, TR, ES, IT, FR) simultaneously.

C. The Search Result Card (The Intelligence File)
Results appear as a vertical stack of cards. Each card represents one row from your CSV.
Card Design: Rectangular, cream-colored, with a "stamped" feel.
Top Row (The Match):
Left: The word found (e.g., "FLIGHT"). Bold, black.
Center: Word type in small italics (e.g., noun).
Right: The Status Stamp. A slanted, rectangular box resembling an ink stamp.
State 1: UNSEEN (Light Grey outline).
State 2: IN TRAINING (Slate Blue ink).
State 3: MASTERED (Deep Teal ink with a checkmark).
Middle Row (The Translations): * A compact 2x3 grid showing the translations in the other 5 languages.
Example: DE: Flug | TR: Uçuş | ES: Vuelo...
Bottom Row (The Example Sentences):
Visible only if the user taps the card to "expand" it.
Two sentences separated by a thin, dotted line.

D. The Interaction: "Manual Injection"
This is the specific button used to add a word to the study rotation.
Button Visual: A square button located at the bottom-right of each Result Card.
Icon: A bold "+" (Plus) sign or a "Folder" icon with an arrow pointing in.
Color: Oxblood Red (#8B0000).
Logic:
If the word is UNSEEN: Tapping the button changes the status to QUEUED. The word is immediately moved to the top of the "Pending" list to be included in the user’s next 20-word daily batch.
Visual Feedback: The button turns Deep Teal and the "+" becomes a checkmark. A "Toast" notification at the bottom says: ASSET ADDED TO NEXT BATCH.

3. Technical Specifications & UI Logic (No Interpretations)
Feature
Trigger
Resulting Action
Simultaneous Search
Typing in Cipher Field
Query EN, DE, TR, ES, IT, FR columns. Display matches from any column.
Status Check
Card Rendering
Check User_Progress_DB. If word ID is in "Easy," apply MASTERED stamp.
Manual Tick
Tap "+" Button
Word ID is flagged as Priority_Queue. It overrides the Lexicon's default order.
Expansion
Tap Card Body
Expand card height to show 2 example sentences.
Keyboard
Search Tap
Trigger system keyboard with "Search" or "Go" button to dismiss.


4. Summary of Buttons & States (The Decoder)
Search Box: White (Idle), Mustard Yellow (Active).
Result Card: Cream background; thick black border.
The Status Stamp: 3 specific colors (Grey, Blue, Teal) to denote learning progress.
The Add Button: Oxblood Red (Add), Deep Teal (Added/Success).

The "Coach" Integration
The Ligne Claire Tutor appears as a small "floating head" in the bottom corner of the search results:
Searching for a C2 word: "Ambitious choice. Let's see if you can actually use it in a sentence."
Searching for a word already Mastered: "Checking the archives? Good. A sharp agent never assumes they know everything."
Empty Result: "No match found. Our database isn't infinite—yet."
This completes the detailed breakdown of The Decoder. Would you like me to finish with the "Control Room" (Settings) tab to define the "No Excuse" timing and audio controls?


1. Tab: Home (The Dashboard)
This is the "pulse" of the app. It needs to be clean so the user isn't overwhelmed before they even start.
The Progress Ring: A circular visual showing the "Word Counter" (e.g., 45 / 200 words mastered in the current batch).
The Streak Flame: A prominent display of consecutive days. To add that "no excuse" weight, you could make the flame turn to ice if they haven't practiced by 6:00 PM.
Active Deck Summary: A small card showing what is currently being learned (e.g., "B1 Travel + B2 Business").
"Start Session" Button: The primary Call to Action (CTA).

To ensure your vision is executed perfectly, let's break down the Home Tab as a blueprint for a developer or designer. We will use the Mid-Century Modern / Noir aesthetic as the visual anchor.
This blueprint is now fully refined to match your Mid-Century Modern / Comic Book Noir aesthetic. Every element is defined to be technically explicit, ensuring the design and functionality leave zero room for misinterpretation.

1. General Visual Standards (The Global CSS)
Background: Solid Light Cream (#F2EFE9). Overlay a subtle, transparent Ben-Day dot pattern (0.1 opacity) to give it a Risograph/printed paper texture.
Outlines: Every single UI element, button, and container must have a 3px solid Black (#000000) outline.
Shadows: No soft blurs. Use Hard Block Shadows (offset 4px down, 4px right) filled with a dark grey or black.
Typography: * Headers: Franklin Gothic Heavy (All Caps).
Body/Words: Futura Medium.

2. Tab: Home (The Dashboard)
A. The Header Bar (Status Hub)
Profile Icon (Top-Left): * Visual: A 50px circle with a 3px black border. Inside, a high-contrast, noir-style silhouette of a face (sharp chin, fedora or sleek hair).
Action: Tapping opens User Profile/Account settings.
Global Word Tally (Center): * Visual: A horizontal rectangle (180px wide) styled like a mechanical vintage counter.
Display: OK: 80 | EASY: 50 in a small, green/gold typewriter font. Below it, a thin progress bar representing 130 / [Total App Vocabulary]—the bar color is Slate Blue.
Settings Icon (Top-Right): * Visual: A 40px square button with a thick-lined gear icon. No background color (transparent) but with the 3px black outline.
B. The Central Hero: "The Master Dial"
The Mastery Ring: * Visual: A large (250px) circular gauge. The "empty" part of the ring is a muted Grey-Teal. The "filled" part (progress) is a Mustard Yellow (#E1AD01).
Texture: The yellow fill has a "grainy" stippling effect toward the edges.
Center Content: * 45 / 200 (Large, Bold, Black).
WORDS MASTERED (Small, All Caps, centered below the numbers).
The Streak Flame (The "Pulse"):
Position: Floating 10px outside the bottom-right edge of the Mastery Ring.
Design: A 60px diameter circle.
State 1 (Active/Safe): A bright Oxblood Red flame icon. White number inside.
State 2 (The Warning - 18:00 to 23:59): The circle turns Cyan Blue. The flame icon is replaced by a geometric, 3D Ice Block icon.
State 3 (The Loss): The circle turns Dark Grey. The icon is a small pile of Ash.
C. The Active Deck "Dossier"
Visual: A rectangular card centered below the Dial. It looks like a Vintage Manila Folder.
Design Details: The top-right corner is "folded" (dog-eared). It has a small "Binder Clip" graphic at the top.
Header Text: "CURRENTLY TRACKING:" (Red, stamped-ink effect).
Content: The user's Lexicon selections listed in a single, centered line: B1 TRAVEL • B2 BUSINESS • C1 LIT.
Edit Button: A small Teal Circle with a white Pencil icon, sitting on the bottom-right edge of the folder. Tapping jumps to the Lexicon Tab.
D. The Primary CTA: "Commence Session"
Visual: A large, wide button (280px x 60px).
Color: Oxblood Red (#8B0000).
Label: COMMENCE STUDY (White, Bold, All Caps).
Sub-label: Just below the button, in tiny 10pt text: [20 NEW WORDS READY FOR DEPLOYMENT].
Animation: When pressed, the button shifts 4px down/right to "hide" its block shadow, creating a tactile mechanical feel.

3. The Bottom Navigation Bar
Visual: A solid white bar at the bottom with a 4px black top-border.
Icons (3px Stroke Thickness):
Home: A simple 2D house silhouette.
Lexicon: An icon of a vintage 3-drawer filing cabinet.
Flashcards: A stack of three rectangles, slightly offset to show depth.
Stats: A bar chart icon where the bars have different Risograph textures (dots, stripes, solid).

4. Technical Logic Table (No Interpretations)
Feature
System Trigger
Resulting Action
Streak Freeze
Local Time hits 18:00
Change Streak Asset to Ice_Block_Cyan. Trigger "Hurry up" notification.
Hard Reset
Local Time hits 00:00
If Daily_Goal_Met == False: Set Streak to 0. Change Streak Asset to Ash_Grey.
New Word Injection
Every 24 hours at 00:00
Move 20 words from "Pending" Lexicon pool into "Active" Batch until Batch reaches 200.
Batch Saturation
Words_Mastered == 200
Disable "Commence Study". Button text changes to: "UPGRADE TO NEXT BATCH".
Motivation Toast
On Dashboard Load
Select 1 random string from the provided 100-message list. Display in speech bubble.


Design Note: The "Noir" Texture
When the user moves their finger across the screen, add a very subtle "film grain" flicker effect to the background. This reinforces the 1950s/Archer cinematic feel.
Should we move to the "Lexicon" Tab next to define the "Ticking" logic and the category breakdown for A1-C2?




2. Tab: Lexicon (The Library & Filter)
This is where the user "shops" for knowledge. It needs to handle high-density data without feeling like a spreadsheet.
Level Toggle: A horizontal scroll for A1 through C2.
Category Grid: Each level opens a grid of categories (Human Body, Business, Literature, etc.).
The "Mixer" Logic: * Users can "Tick" a whole level (B1).
Users can "Long-press" a category to add only that specific topic from a higher level (B2 Business).
Batch Status: Each category shows a percentage bar (e.g., 70% B2-Travel). This gives a sense of completionism.

The Lexicon Tab is the "Mission Control" of the user’s vocabulary. To keep it from feeling like a boring spreadsheet, we will design it as a Vertical Filing Cabinet or a Library Archive. It must be visually dense but perfectly organized using the Ligne Claire style.

1. General Visual Standards (Consistency Check)
Background: Light Cream (#F2EFE9) with a 5% Ben-Day dot texture.
Outlines: 3px Solid Black on all UI elements.
Shadows: Hard Block Shadows (4px down, 4px right).
Icons: Minimalist, thick-lined silhouettes (e.g., a simple briefcase for "Business").

2. The Level Selector Rail (Top Fixed Section)
Instead of a standard tab bar, this is a Horizontal Scroll Dial.
Visual: A 60px tall horizontal strip with a 3px black border at the bottom.
Items: A1, A2, B1, B2, C1, C2.
Typography: Franklin Gothic Heavy, 20pt.
Interaction Logic:
Inactive State: Cream background, black text.
Active State (Selected): Inverts to a Mustard Yellow (#E1AD01) background with black text. A small black triangle (arrow) sits underneath the active level, pointing down at the grid.
"Master Tick" Button (Top Right): A square button next to the levels with a "Double Checkmark" icon.
Function: Tapping this "Ticks" the entire level (e.g., all of B1) into the active pool.

3. The Category Grid (The "Dossier Tiles")
When a level (e.g., B2) is selected, the area below populates with a 2-column grid of tiles.
The Tile Design (Individual Category Card)
Shape: Square (approx. 150px x 150px).
Outline: 3px Solid Black.
Interior Elements:
Icon (Center): A large, high-contrast black silhouette (e.g., a classic 'Archer' style globe for "Travel").
Label (Bottom-Left): Category name (e.g., "HUMAN BODY") in Futura Bold, 12pt, All Caps.
The Tick Circle (Top-Right): A 30px circle.
Unticked: Empty white circle.
Ticked: Oxblood Red background with a thick white checkmark.
The Progress Meter (Bottom): A thin (6px) horizontal bar at the very bottom of the tile.
Visual: Slate Blue fill representing completion percentage.
Text: A small % number sitting just above the bar (e.g., 70%).

4. The "Mixer" Logic (Selection & Long-Press)
This is the technical core of how users build their "200-word Batch."
Selection Type A: Standard Tick
Action: Single tap on the "Tick Circle."
Behavior: Adds all words in this category to the potential "Active Pool." The tile's border thickens to 5px to show it is active.
Selection Type B: The Long-Press (Priority Selection)
Action: Press and hold a tile for 1 second.
Visual Feedback: A small "Noir" style magnifying glass animation appears.
Result: This category is "Pinched" from a level you haven't fully committed to.
Example: User is studying B1, but wants B2 Business. Long-pressing B2 Business adds it to the deck without ticking all other B2 categories.
Indicator: A small Gold Star icon appears next to the tick to show it is a "Priority/Custom" selection.

5. The "Batch Status" Footer (Floating Bar)
This bar persists at the bottom of the Lexicon tab, just above the Navigation Bar. It tells the user if they are over-capacity.
Visual: A rectangular bar with a Deep Teal (#004B49) background and a white outline.
Content (Left): TOTAL WORDS SELECTED: 450
Content (Right): ACTIVE BATCH: 130 / 200
Warning Logic: If "Total Words Selected" is high, but the "Active Batch" is only 130, a small info icon says: "20 new words will be injected daily until your 200-word limit is reached."

6. Technical Specifications & UI Logic
Feature
Action
Description/Constraint
Percentage Logic
Automatic
% = (Words marked 'Easy' + 'OK') / Total words in category.
Interchangeable View
Tap Icon
While in Lexicon, if you tap the category name, a quick-preview shows a sample word in all 6 languages.
Search Bar
Pull Down
Swiping down at the top of the grid reveals a "Search Archive" bar with a 3px black outline.
Level Locking
Visual
Levels not yet paid for (if applicable) are shown with a Dotted Outline and a "Classified" stamp across them.


7. Summary of Buttons & States
Level Dial: Snap-scroll interaction. High-contrast mustard yellow for selection.
Master Toggle: "Select All" for the current level.
Category Tile: * Default: Cream / Black.
Ticked: Red Checkmark / Bold Outline.
Long-Pressed: Gold Star / Priority Status.
Progress Meter: Slate Blue fill.
Would you like me to detail the "Flashcards" tab next—specifically how the multi-face language reveal works and the 4-button labeling system?



3. Tab: Flashcards (The Study Engine)
This is the core "Quiz" part. Since you want multi-language faces, the UI needs to be vertical or "flippable."
The Multi-Face Card: Instead of just a front and back, use a "stack" or "scroll" view.
Face 1 (Primary): The word in the "Source" language + Word Type.
Face 2+ (Targets): The word in the selected target languages.
The "Reveal" Flow: User taps to see the next language, then taps again for the example sentences.
The 4-Button Spaced Repetition (SRS) Bar:
Really Hard: Shown again in ~1 minute.
Not Familiar: Shown again in ~5 minutes.
OK: Shown again tomorrow.
Easy: Shown again in 4–7 days.

The Flashcards Tab is the engine room of the app. To stay consistent with your Vintage Noir / Archer aesthetic, we will design this not as a simple app screen, but as a "Mechanical Dossier Sorter." The card doesn't just "flip"; it reveals information in layers, like a spy opening a classified file.

1. General Visual Standards (Consistency Check)
Card Background: Manila Folder Cream (#F2EFE9) with a heavy Ben-Day dot texture (0.15 opacity) for a printed-paper feel.
Outlines: All cards and buttons have a 3px Solid Black outline.
Typography: * Main Word: Franklin Gothic Heavy (32pt, All Caps).
Word Type/Sentences: Futura Medium/Italic.
Color Palette: Oxblood Red (Hard), Burnt Orange (Familiar), Deep Teal (OK), Mustard Gold (Easy).

2. The Header Bar (Session Stats)
Fixed at the top of the screen to track the current "Batch" progress.
Visual: A thin cream strip with a 3px black bottom border.
Left Side: A "Back" arrow icon (thick black line).
Center: Session Counter (e.g., 14 / 20) in a small mechanical-digit font.
Right Side: A "Volume" icon to toggle text-to-speech.

3. The Multi-Face Card (The "Mechanical Dossier")
The card is a large vertical rectangle centered on the screen with a 4px Hard Block Shadow.
The "Reveal" Flow (Step-by-Step Logic):
The user moves through the card by tapping the card body. Each tap slides up a new "Section" of the file.
State 1: Face 1 (The Anchor)
Top 1/3 of the Card: Displays the word in the Source Language (e.g., English).
Label: Small "Stamp" in the corner saying [SOURCE: EN].
Content: The Word (e.g., "DESTINATION") in black bold.
Sub-content: The word type (e.g., noun) in small italics below.
Visual: The rest of the card (the bottom 2/3) is covered by a "Classified" grey overlay with a 3px black border.
State 2: Face 2+ (The Target Languages)
Interaction: User taps the card.
Visual: The grey overlay slides down, revealing the Target Language (e.g., German: "Zielort").
Repeat: If the user selected 3 languages (English, German, Turkish), each tap reveals the next language in a vertical stack.
Order: Dictated by the "Order" settings the user chose in the Lexicon.
State 3: The Final Reveal (Example Sentences)
Interaction: Final tap.
Visual: The bottom of the card unfolds to show two example sentences.
Design: Each sentence is separated by a thin, dotted black line.
Sentence 1: Target Language version.
Sentence 2: Source Language version.
Logic: Once this face is revealed, the SRS Button Bar (at the bottom) illuminates and becomes active.

4. The 4-Button SRS Navigation Bar (The Labels)
This bar is docked at the very bottom. The buttons only become "clickable" once the user has revealed the Target Language(s).
Button Label
Visual Design
SRS Timing Logic
REALLY HARD
Oxblood Red background, White text.
Moves word to "Priority" (Show again in ~1 min).
NOT FAMILIAR
Burnt Orange background, White text.
Show again in ~5 mins (within current session).
OK
Deep Teal background, White text.
Moves word to "Learned" (Show again tomorrow).
EASY
Mustard Gold background, Black text.
Moves to "Mastered" (Show again in 4–7 days).


Button Animation: On tap, the button should "sink" into its shadow.
Feedback: When a button is pressed, the card "flies" off the screen (upwards) to make room for the next one.

5. Technical Specifications & Logic
The "No-Stuck" Algorithm:
Limit: The app ensures you aren't stuck on the same 5 "Hard" words.
Injection: Even if 10 words are labeled "Really Hard," the app forces 20 new words from the 200-word batch into the rotation every day.
Frequency Gate: Words labeled "Easy" are assigned a frequency_multiplier = 0.05, meaning they almost never appear in the daily 20, keeping the focus on the "Hard" (multiplier 1.0) and "Not Familiar" (multiplier 0.5) words.
The Motivation Trigger:
Trigger: When the 20th word of the daily session is completed.
Screen Event: The Flashcard UI fades out. A full-screen Ligne Claire illustration of "The Tutor" appears.
Action: A text box displays one of your Group 1 or Group 5 messages.
Example: "You never feel ready, but you are! 20 words conquered. See you tomorrow, Agent."
Button: [RETURN TO HEADQUARTERS] (Jumps back to Home Tab).

6. Summary of Buttons & States (Flashcards)
The Card (Body): Acts as the "Reveal" button (Tap to see more).
Volume Icon: Toggle sound on/off.
SRS Row: 4 distinct color-coded buttons with hard shadows.
Progress Bar: Top of screen, tracks completion of the current sub-batch (the 20 words for the day).
Would you like me to detail the "Stats & Progress" tab next—focusing on the "Heatmap," the "Word Counter" logic, and the "Level Completion" percentage bars?



In surprise me section, there will be random things like quiz, The Cloze-Deletion Logic, a flash card …
So the user will not except a think and there will be something pop up one after another and will help to not to be bored.

7. The "Unthought" Technical Edge: The Cloze-Deletion Logic
Instead of just single words, once a user reaches B2 level, the "Flashcard" changes slightly.
The Mechanic: It shows an example sentence with the word missing (The Cloze).
The Challenge: The user has to provide the word in the Target Language based on the context of the sentence.
Why it works: This is the most effective way to learn how a word is used, not just what it means.

This is the "Enigma Deck" (your "Surprise Me" section). To keep the user on their toes, we will design this as a high-speed "Intercept Mission." The UI will remain consistent with the Mid-Century Noir style, but the interaction will feel more like a game than a study session.

Tab / Section: The Enigma Deck (Surprise Me)
1. Visual Identity & Atmosphere
Background: Instead of the static cream, the background has a pulsing scan-line effect (subtle, dark grey lines) over the Ben-Day dots to signal a "live" intercept.
The Card Style: Still the Manila Folder or Archive Card with 3px black outlines and 4px block shadows.
The Randomizer: Before each task, a "Slot Machine" style animation briefly flickers through icons (a question mark, a magnifying glass, a lightning bolt).

2. The Task Types (The Random Pop-Ups)
The user hits "START INTERCEPT" and the app cycles through these 4 modes randomly.
Mode A: The Cloze-Deletion (B2+ Exclusive)
Visual: The card is Deep Teal (#004B49) with white text to signal "High Difficulty."
The Mechanic: A sentence from your "Example Sentence" column appears, but the target word is replaced by a blank box [ _____ ].
The Challenge: The user sees the sentence in their Base Language at the top for context. They must type (or select from 4 Noir-style buttons) the missing word in the Target Language.
Example: * Context: "The spy escaped through the window."
Task: "Der Spion ist durch das Fenster [ ________ ]."
Answer: entkommen.
Mode B: The Rapid Interrogation (Speed Quiz)
Visual: The card is Mustard Yellow (#E1AD01). A "Timer Bar" at the top shrinks rapidly.
The Mechanic: One word appears in the center. Four possible translations appear at the bottom as simple rectangular buttons.
The Challenge: The user has 3 seconds to pick the right one.
Effect: If they miss it, the card "crumbles" (a quick animation) and moves to the next.
Mode C: The Mystery Flashcard
Visual: Standard Cream (#F2EFE9) card.
The Mechanic: This is your standard multi-face card, but with a Hidden Face.
The Challenge: The app might skip the "Base Language" and show the Target Language first, forcing the user to translate back to their native tongue.
Mode D: The Signal Match (Drag & Drop)
Visual: A Slate Blue background.
The Mechanic: Three words on the left, three translations on the right.
The Challenge: User must draw a line (a thick black Ligne Claire line) connecting the pairs.

3. The "Surprise" Logic & Flow
To ensure they never get bored, the transition between these modes must be instant.
The "Pop-Up" Transition: When a user finishes one task, the card doesn't just slide—it flips vertically or zooms out while the next one "Pops" in with a mechanical clack sound.
The Streak Multiplier: If the user gets 5 surprises right in a row, the screen border begins to glow Mustard Yellow, and they earn "Intel Points" (used for the "Burn Insurance" we discussed).

4. Technical Specification: The Cloze-Deletion Engine
This is how the app handles the "Unthought" B2+ mechanic without you needing to write new sentences.
Sentence Extraction: The app pulls the Example_Sentence from your CSV.
The Mask: It identifies the Target_Word within that sentence.
The Blank: It replaces the Target_Word with a blank space.
Verification: The user's input is checked against the Target_Word column. It must be a 100% match (ignoring capitalization).

5. Summary of Buttons & States (Enigma Deck)
Element
Idle State
Active/Pressed State
Start Button
Oxblood Red, pulsing.
Sinks into shadow, triggers "Slot Machine" animation.
Cloze Input
White box, 3px black outline.
Turns Green (Success) or Red (Fail) instantly.
Quiz Buttons
Cream with black outline.
Turns Mustard Yellow on hover/press.
Exit Mission
Small "X" in top corner.
"Are you sure? Progress for this session will be lost."


The "Coach" Integration (Enigma Mode)
Since this mode is about being "Surprised," the Ligne Claire Tutor should act like a drill sergeant:
Before a Speed Quiz: "Don't blink. Speed is the only thing that keeps you alive."
After a successful Cloze: "Impressive. You’re starting to think like a native."
On Failure: "The enemy doesn't wait for you to remember. Try again."
Would you like me to create the "Success/Rewards" screen for the Enigma Deck—specifically showing how they "Intercept Intel" as a reward for 100% accuracy?



4. Tab: Stats & Motivation (The "You Are Ready" Hub)
This is where the algorithm and the "tough love" coaching live.
Mastery Heatmap: A calendar view showing streak consistency.
Batch Management: A logic-gate that triggers when a user hits a milestone.
The "Push" Notification: When the user completes a 10-day streak or hits their 200-word limit, a full-screen message appears: "You've mastered 200 words. You don't feel ready for the next level, but you are! Let's move to C1."
Lexicon Progress: A detailed breakdown of "Words Mastered" vs. "Words in Progress" per language.

The Stats & Motivation Tab is designed to look like a High-Level Intelligence Report. It transforms cold data into a visual narrative of progress, utilizing the same Mid-Century Modern / Noir aesthetic to keep the user engaged in their "training."

1. General Visual Standards (Consistency Check)
Background: Manila Cream (#F2EFE9) with 10% Ben-Day dot stippling.
Outlines: 3px Solid Black.
Color Accents: Deep Teal (Mastery), Oxblood Red (Grit/Streak), Slate Blue (Progress).
Shadows: 4px Hard Block Shadows.

2. Section A: The Global Mastery Header
At the top of the tab, the user sees their "Permanent Record."
Visual: A horizontal "Status Card" designed like a top-secret dossier header.
Metric 1 (Left): TOTAL MASTERED (Words marked "Easy"). Large bold font.
Metric 2 (Center): CURRENT STREAK (The Flame/Ice/Ash icon + Number).
Metric 3 (Right): VOCABULARY RANK (A dynamic title like "Novice," "Operative," or "Polyglot Master").

3. Section B: The Mastery Heatmap (The "Grit Grid")
This is a calendar-view visualization of the user's consistency.
Visual: A grid of small squares (7 columns for days of the week).
Logic & Colors:
Empty Square (Off-white): Future dates or days before the user joined.
Deep Teal Square: Session completed. The darker the teal, the more words were mastered that day.
Cyan Blue Square: A "Warning" day where the user practiced after 6:00 PM (the "Ice" state).
Grey Ash Square: A missed day. A tiny "X" is etched in the corner. No comeback—the grey stays forever.
Interaction: Tapping a square reveals a "Daily Report" pop-up: "Oct 14th: 25 words reviewed, 4 moved to 'Easy'."

4. Section C: Lexicon Progress (The Language Breakdown)
Since your app handles 6 interchangeable languages, the user needs to see where they are strongest.
Visual: A vertical list of "Language Bars." Each bar starts with the country flag icon in a Ligne Claire style circle.
The Progress Bar (Double-Layered):
Bottom Layer (Light Grey): The total path to C2.
Middle Layer (Slate Blue): "Words in Progress" (Labeled OK/Hard).
Top Layer (Deep Teal): "Words Mastered" (Labeled Easy).
Labeling: GERMAN: 1,200 Words Mastered | 45% of B2 Complete.

5. Section D: Batch Management & "The Push" (The Logic Engine)
This is the "Tough Love" coach that prevents the user from stagnating.
The 200-Word Milestone Logic
When a user hits 200 words in their active pool labeled as "OK" or "Easy," the Batch Management Gate triggers.
The Gate: The app will prevent the user from adding new words from the Lexicon until they acknowledge they are ready to move to the next level of difficulty.
The "Push" Pop-Up: A full-screen overlay with a high-contrast Ligne Claire illustration of the "Tutor."
Headline: INTEL UPDATE: YOU ARE READY.
Message: "You’ve processed 200 words. Your brain is telling you to stay here where it’s safe. I’m telling you to move. You won't feel ready for the next level until you're already in it. Let's move to [Next Level/Category]."
Primary Button: [DEBOY NEW BATCH] (Oxblood Red).
Secondary Button: [REVIEW CURRENT] (White/Black Outline).

6. Technical Specifications & UI Logic Table
Feature
Logic / Trigger
Visual Result
Streak Milestone
Every 10, 25, 50, 100 days
Full-screen "Commendation" card with a unique badge asset.
Stagnation Check
User reviews the same "Hard" words for 3 days
A "Special Intervention" message: "You're overthinking 'Destination.' Breathe. Let's try it in Spanish today."
Language Balance
One language is >30% ahead of others
A "Tactical Advice" note: "Your Turkish is lagging behind your German. Balance the scales."
Completionism
Level hits 100%
The Level icon in the Lexicon turns Gold and gets a 3D-embossed effect.


7. Summary of Buttons & States (Stats Tab)
Timeframe Toggle: Buttons for 7D, 1M, ALL TIME (Segmented control style with black outlines).
Share Button: A small "Export Dossier" icon to share the heatmap on social media (formatted to look like a telegram).
Reset Analytics (Danger Zone): Hidden at the bottom of the settings to wipe all stats (requires 3-second hold).

Final Consistency Check: The "Noir" Polish
Ensure that when the user scrolls, the "Hard Block Shadows" stay locked to the elements. The transition between the "Stats" and "Lexicon" should be a quick "Slide" as if moving between drawers in a filing cabinet.
This concludes the structural breakdown of your four main tabs. Would you like me to draft the "Initial Setup" flow—specifically where the user selects their primary and target languages for the first time?



Settings
4. Page: The Control Room (Settings & Notifications)


Dark mode/light mode

User settings: change payment method, change user gmail, change user phone number, cancel sub, etc (add thas is needed more)

This is where the "No Excuse" logic is configured.
The "Ice Trigger" Clock: The user can set their own "End of Day" time. If they work night shifts, they can move the 6:00 PM "Ice" trigger to 10:00 PM.
Haptic Feedback: A toggle for the "mechanical" vibrations when buttons are pressed.
Subscription Management: A clear area to see their "Service Duration" and "Renew" options.
Help email address official. And official website (for more info and other products or who we are or what is that app connect to maybe to a holding)


The Control Room is the final piece of your app’s architecture. To stay consistent with the Vintage Noir / Archer aesthetic, this is designed to look like a Mid-Century Command Center—think heavy toggle switches, analog dials, and glass-covered gauges. This is where the user manages their "Contract" (Subscription) and "Operational Parameters" (Settings).

1. General Visual Standards (Consistency Check)
Background: Light Cream (#F2EFE9) with 10% Ben-Day dot texture.
Outlines: 3px Solid Black on all buttons and containers.
Shadows: 4px Hard Block Shadows (Black).
Typography: Franklin Gothic Heavy (Headers); Futura Medium (Body); Monospace/Typewriter (For ID numbers and dates).

2. Page: The Control Room (Settings & Notifications)
A. Header: "SYSTEMS & SECURITY"
Visual: A thick black horizontal line at the top.
Title: THE CONTROL ROOM (All Caps, Bold).
Sub-title: STATION ID: [USER_ID_NUMBER] in a small typewriter font.
B. Section 1: Visual & Tactile Feedback
This section controls how the "machine" feels in the user’s hand.
Setting: Theme Mode
Label: VISUAL SPECTRUM
Buttons: A segmented control (two rectangles joined together).
Left Button: DAYLIGHT OPS (Light Mode - Cream background).
Right Button: NIGHT RECON (Dark Mode - Deep Navy background with Cyan accents).
Interaction: Tapping one "depresses" the button into its shadow.
Setting: Haptic Feedback
Label: TACTILE RESPONSE
Toggle: A large Ligne Claire style toggle switch.
State ON: Switch is "Up," background is Deep Teal.
State OFF: Switch is "Down," background is Oxblood Red.

C. Section 2: The "No Excuse" Configuration
This is the core of your "Ice Trigger" logic.
Setting: The Ice Trigger Clock
Label: CURFEW SETTINGS (ICE TRIGGER)
Visual: A circular dial graphic or a digital time-picker with a thick black outline.
Description: "Set the hour the flame turns to ice. Failure to practice after this hour puts your streak at risk."
User Action: User selects a time (e.g., 6:00 PM, 10:00 PM).
The Streak Reset Logic:
Label: HARD RESET HOUR
Fixed Value: 00:00 (MIDNIGHT)
Note: "The Archive closes at midnight. No exceptions. If the session isn't finished, the streak burns to ash."

D. Section 3: User Personnel Files (Account Settings)
Visual: A group of white rectangular bars with "Change" buttons on the right.
Field 1: Primary Email
Display: [user.email@gmail.com]
Button: CHANGE (Teal outline, White background).
Field 2: Phone Number
Display: [+1 555-XXX-XXXX]
Button: UPDATE (Teal outline).
Security: [RESET PASSWORD] button (Full width, White background, black text).

E. Section 4: Financial Records (Subscription)
This area must be strictly clear to avoid legal/user confusion.
Card Design: A rectangular "ledger" with a light yellow tint.
Current Plan: 6-MONTH DEPLOYMENT (ACTIVE)
Service Duration: RENEWS ON: OCT 15, 2026
Payment Method: VISA **** 1234
Action Buttons:
Button: UPDATE PAYMENT METHOD (Mustard Yellow background).
Button: CANCEL SUBSCRIPTION (Transparent background, Red text, Dotted outline).
Logic: Tapping "Cancel" triggers a Noir-style prompt: "Are you deserting the mission? All progress will be frozen."

F. Section 5: Support & External Intel
Official Help Email: SUPPORT@LINGUANOIR.COM (Tappable link to open mail client).
Official Website: WWW.LINGUANOIR.COM (Opens in-app browser).
Corporate Identity: A SUBSIDIARY OF [HOLDING NAME] GLOBAL. (Small text at the very bottom).

3. Technical Specifications & UI Logic
Element
Trigger
Resulting Action
Theme Toggle
Click 'Night Recon'
Swaps #F2EFE9 (Cream) for #1A1A1A (Dark Grey).
Ice Trigger
Time Change
Updates the global Ice_State_Time variable.
Cancel Sub
Click + Confirm
Sets Subscription_Status to Pending_Cancellation.
Help Email
Tap
Launches mailto: with User ID in the subject line for faster support.


4. Summary of Buttons & States
Toggle Switches: 3D-effect, thick black lines, color-coded for On/Off.
Segmented Controls: For Day/Night mode; high contrast.
Update Buttons: Small, clean, Teal-colored text to signify "System Action."
Danger Buttons: Red or Dotted outlines for "Cancel/Delete" actions.

The "Coach" Integration (Settings Edition)
The Ligne Claire Tutor appears at the bottom of the page, perhaps leaning against the edge of the screen:
Changing the Ice Trigger: "Moving the curfew? Whatever helps you sleep at night. Just don't miss the deadline."
Canceling: "Once you leave the Control Room, the mission is over. Think carefully, Operative."

Next Step for You
This completes the architectural and visual blueprint for all major screens of your app. You now have:
Onboarding & Paywall
The Dashboard (Home)
The Lexicon (Library)
The Flashcards (Study Engine)
The Stats (Motivation)
The Vault (Archive)
The Decoder (Search)
The Control Room (Settings)
Would you like me to compile a "Developer Handoff" document that summarizes all the technical Logic Gates and CSV structures in one place, or should we design the "Notification" pop-ups that appear on the phone's lock screen?



This is a critical moment in the user journey. If the app is too soft, they stall; if it's too aggressive, they quit. The goal is to act like a high-end coach: firm, observant, and occasionally witty.
Here are 100 motivation messages categorized by the "vibe" of the transition.

Group 1: The "Ready or Not" (Batch Transitions)
Focus: Pushing the user to move to the next 200 words even when they feel hesitant.
You’ll never feel 100% ready. Do it anyway.
The comfort zone is where vocabulary goes to die. Move on.
You’ve seen these words; now go meet some new ones.
Your brain is a muscle. Give it a heavier weight.
Perfection is the enemy of progress. You’re ready for the next batch.
200 words down. Don’t look back, you aren’t going that way.
Trust the data, not your nerves. You’ve got this.
If it feels easy, you aren't learning. Let’s make it hard again.
You’ve built the foundation. Time to start the second floor.
The first 200 are the hardest. The next 200 are the smartest.
Repetition is good, but discovery is better. Next batch?
You’ve internalized the basics. Let’s add some flavor.
Don’t wait for "perfect." "Good enough" is the bridge to mastery.
Your vocabulary just grew by 200. Don't let them get lonely.
You know more than you think you do. Prove it in the next section.
The goal isn't to never forget; it's to keep learning despite forgetting.
Batch complete. New horizon ahead.
You survived the first round. The second round is where the magic happens.
Momentum is a terrible thing to waste. Keep clicking.
Stop reviewing the past. Start previewing the future.

Group 2: The "Level Up" (A1 → C2 Transitions)
Focus: Acknowledging the increase in complexity.
A1 is for tourists. A2 is for travelers. Welcome to the journey.
You’re leaving the "basics" behind. It’s time to get specific.
B1 achieved. You’re officially no longer a beginner.
Moving to B2? Prepare for actual conversations.
Welcome to C1. This is where you start to sound like yourself in another language.
You’ve mastered the "What." Now let’s master the "How" and "Why."
The higher you go, the better the view. C2 is calling.
Transitioning to Intermediate: The "training wheels" are coming off.
Advanced levels aren't about more words; they’re about better words.
You’ve moved from "surviving" to "thriving."
This level requires grit. Good thing you have plenty.
Each level is a new layer of your personality.
From simple sentences to complex thoughts. Let’s go.
You’re officially past the "confused nodding" stage.
The dictionary is getting thinner because your brain is getting fuller.
Welcome to the deep end. You’re a better swimmer than you realize.
Don't fear the B-levels. They are the gateway to fluency.
You’re now entering the realm of "Redewendungen." Let’s get idiomatic.
Level up! Your future self is thanking you.
High-level vocabulary is the key to high-level opportunities.

Group 3: The "Streak & Grit" (Consistency)
Focus: Honoring the daily grind.
10 days straight. That’s not a fluke; that’s a habit.
You showed up when you could have made an excuse. Respect.
The streak stays alive because you stayed focused.
One day at a time. That’s how a language is conquered.
Don't let the flame go out. You've worked too hard for this.
30 days. You’re officially a polyglot-in-training.
Consistency beats intensity every single time.
You didn't miss a day. That’s the "secret sauce" to fluency.
Your streak is a testament to your discipline.
Rain or shine, you’re here. That’s why you’re winning.
50 days! You’ve spent more time learning than most people spend dreaming.
Keep the chain unbroken.
Every day you practice, the world gets a little smaller.
Discipline is choosing between what you want now and what you want most.
You’re building a bridge. Don’t stop mid-river.
Your 10-day streak is the spark. Let’s make it a fire.
No excuses. No retreats. Just progress.
A day without learning is a day without growing. Glad you’re here.
You’re out-hustling your yesterday self.
The streak is just a number, but the progress is forever.

Group 4: The "Real Talk" (Tough Love)
Focus: Direct, candid motivation.
You feel tired? Good. That means your brain is re-wiring.
If it were easy, everyone would speak six languages.
Stop overthinking and start doing.
You don’t need more time; you need more focus.
Regret for a missed day lasts longer than the 5 minutes it takes to practice.
Your brain wants to quit. Tell it you’re the boss.
You’ll never "find" time. You have to "make" it.
Frustration is just the feeling of a breakthrough arriving.
Quitters don't get to order coffee in Paris. Keep going.
Boring words lead to exciting conversations. Push through.
Stop checking the progress bar and start enjoying the process.
You’re not "bad" at this. You’re just "new" at this.
Mistakes are just proof that you’re trying.
The only way to fail is to stop.
Don’t trade your goals for a nap.
Growth is uncomfortable. Get cozy with the discomfort.
You want the result? Fall in love with the work.
Focus on the next word, not the whole language.
Comparison is the thief of joy. Compare yourself only to yesterday.
Just 5 more minutes. You can do anything for 5 minutes.

Group 5: The "Witty & Encouraging" (Personality)
Focus: Lighthearted but still grounded.
Your brain is officially 2% more international today.
Careful, your accent is starting to sound dangerously good.
You’re now 200 words closer to being the most interesting person in the room.
Look at you, becoming all multilingual and sophisticated.
If your brain was a hard drive, we’d need an upgrade.
You’re basically a linguistic superhero at this point.
Warning: Learning this many words may lead to spontaneous travel.
You’re doing the work. The coffee is on me (spiritually).
Your vocabulary is now large enough to start a small revolution.
Learning a language is the only time it's okay to talk to yourself.
You’re making this look easy. (It’s not, but you are).
Somewhere, a native speaker is waiting to be impressed by you.
Your brain: "Help, I'm full!" Me: "One more batch."
Fluency looks good on you.
You’re officially too smart for subtitles now. (Almost).

Group 6: The "Silly/Ridiculous" (The 5% outliers)
Focus: High-energy and slightly absurd.
Your brain is sweating. That’s just the ignorance leaving the building.
200 words! You’re basically the King/Queen of the Dictionary now.
Stop! ...actually, don't stop. I just wanted to see if you were paying attention.
If knowledge was pizza, you’d be a Deep Dish by now.
You’ve learned so much that your head might actually start glowing. Don’t panic.

Suggested Formatting for the App
To make these messages pop, you should present them at the end of a session or when a new level is unlocked.
Next Step: Would you like me to create the logic for how these messages are triggered based on specific user stats (e.g., if "Streak < 3" use Group 4, if "Level Up" use Group 2)?



To make these messages feel like a personal coach rather than a random text generator, we need a Trigger Engine. This logic ensures the message matches the user's current psychological state—whether they need a "pat on the back" or a "kick in the pants."
Here is the logic structure for your app's notification and pop-up system.

1. Trigger Mapping Table
This table defines which "Vibe" the app should select based on user data.
Event / Trigger
Condition
Priority
Message Group
The "Push"
User hits 200-word limit in a batch
High
Group 1: Ready or Not
The Graduation
Level % reaches 100% (e.g., B1 Complete)
High
Group 2: Level Up
The Streak Milestone
Multiples of 10 days (10, 20, 30...)
Medium
Group 3: Streak & Grit
The Intervention
User returns after losing a streak
Critical
Group 4: Real Talk
The Daily Finish
Standard session completion
Low
Group 5: Witty & Encouraging
The Wildcard
5% random chance on Daily Finish
Low
Group 6: Silly / Ridiculous


2. The Logic Flow
When the user finishes a session, the app should run through this check:
Phase A: Check for Milestones
Is a Level Complete? If yes $\rightarrow$ Show Group 2.
Is the 200-word Batch Full? If yes $\rightarrow$ Show Group 1 (The "Move On" message).
Is it a Milestone Day? (10, 50, 100 days) $\rightarrow$ Show Group 3.
Phase B: The "No Excuse" Intervention
If the user opens the app and the Streak = 0 (because they missed yesterday), the app shouldn't be "nice." It should trigger a Group 4 message immediately upon login to set the tone:
"Regret for a missed day lasts longer than the 5 minutes it takes to practice. Let’s restart."
Phase C: Daily Variety
If no major milestones are hit, the app rotates between Group 5 (95% of the time) and Group 6 (5% of the time) to keep the user guessing.

3. UI/UX Implementation for Transitions
Because you like the Mid-Century Modern / Archer aesthetic, these messages shouldn't just be plain text.
The "Coach" Character: Create a simplified, Ligne Claire style character (maybe a sharp-dressed tutor or a stoic traveler).
The Speech Bubble: When a message triggers, this character appears at the bottom of the screen with a speech bubble.
Tactile Feedback: * Group 2 (Level Up): The screen should flash a vibrant color (e.g., Gold or Electric Blue) with a slight "grainy" screen shake.
Group 4 (Real Talk): The screen should dim, and the text should appear in a bold, "Noir" style font to emphasize the seriousness.

4. Sample Code Logic (Pseudo-code)
Python
if user.current_batch_count >= 200:
    display_popup(random.choice(Group_1))
    lock_current_batch(True) # Force them to move to new words
elif user.level_progress == 100:
    display_popup(random.choice(Group_2))
elif user.streak == 0 and user.was_active_yesterday == False:
    display_popup(random.choice(Group_4))
else:
    # Randomly choose between Witty and Silly
    chance = random.random() # Generates 0.0 to 1.0
    if chance > 0.95:
        display_popup(random.choice(Group_6))
    else:
        display_popup(random.choice(Group_5))



Special Logic: The "No Comeback" Rule
Since you mentioned there is no excuse for a lost streak, we can add a visual "Scar" to the UI. If a user loses a 30-day streak, the Streak Counter resets to 0, but maybe a small "X" remains on that date in the calendar forever. The Group 4 messages should reinforce that: "It's gone. Don't let it happen again."
Would you like me to help you design the "Lexicon" tab next—specifically how to organize the B1/B2/C1 categories so the user can "tick" them easily?



To ensure the "gears" of your app run as smoothly as the visuals, we need to define the underlying logic. These mechanics are the "secret sauce" that turns a simple flashcard app into a high-performance training tool.
Here are the primary algorithms and mechanics that power the experience.

1. The SRS Engine: "The Memory Decay" Algorithm
This governs when a word appears based on the 4-button feedback. It is based on a modified version of the SuperMemo-2 logic but simplified for your specific labels.
Each word in the database has an Interval (days) and an EaseFactor (multiplier).
User Label
Logic Gate
Effect on Next Review
Really Hard
Interval = 0
Stays in current session; repeats every 1–2 minutes until labeled higher.
Not Familiar
Interval = 1
Shown again at the end of the current session. Then scheduled for 1 day later.
OK
Interval = Interval * 2
Standard progression. If seen today, see it again in 2 days, then 4, then 8.
Easy
Interval = Interval * 4
Fast-track to mastery. Seen today, then in 4 days, then 16 days.

The Formula for Next Review:
$$NextReview = CurrentDate + (LastInterval \times EaseFactor)$$

2. The Logistics: "The 20-Word Drip" Injection
Critic note: that number (20) can be adjust by the user, it can be 12, 10, even 1 but there will be a suggestion by the app: “based on language research most performative number is 15… etc.”
You mentioned a 200-word batch limit with 20 new words added daily. This prevents "Brain Overload."
The Queue: When a user "Ticks" categories in the Lexicon, those words enter a Global Queue (the "Huge CSV").
The Active Pool: This is a separate table containing exactly 200 words the user is currently "working on."
The Injection Logic: * Every day at 00:00, the app checks the Active Pool.
If words were marked "Easy" or "OK" enough times to reach a "Mastered" threshold, they are moved to The Vault.
The app then "Drips" 20 brand-new words from the Global Queue into the Active Pool.
The Cap: If the Active Pool is full (200 words), it will not inject new words until the user clears space by mastering current ones. This forces the "You are ready" motivation pop-up.

3. The Cipher Logic: Multi-Face Reveal
Because users can select multiple languages, the "Face" logic must be dynamic. The app doesn't store "Cards"; it stores "IDs" that pull from the 6-language CSV.
Face Array: The app generates a sequence based on the Intelligence Briefing settings.
Example Setup: [1. EN, 2. DE, 3. TR]
The Reveal Loop:
Tap 0: Displays CSV[Word_ID][EN_Column].
Tap 1: Displays CSV[Word_ID][DE_Column].
Tap 2: Displays CSV[Word_ID][TR_Column].
Tap 3: Displays CSV[Word_ID][EN_Sentence] AND CSV[Word_ID][DE_Sentence]. (Usually, example sentences should only show in the Base and the first Target language to keep the card from being too long).

4. The Discipline: "Ice & Ash" Streak Logic
This is the "No Excuse" mechanic. It requires a Local Time Trigger and a Server-Side Check.
The Curfew (Ice): At the user-defined "Ice Trigger" hour (e.g., 18:00), the app checks: daily_session_complete == true.
If false, the UI assets swap to the Cyan Ice theme.
The Deadline (Ash): At 00:00 (Midnight), the app performs a hard check.
If daily_session_complete == false: streak_count = 0.
The lost_streak_date is recorded in the heatmap.
No Backdating: The app's clock is synced with a server (NTP). Users cannot cheat by changing the time on their phones.

5. The Progress Metric: "Mastery Percentage"
How the Lexicon categories (B1 Travel, etc.) calculate that "70% Complete" bar.
The Mastery Threshold: A word is considered "Mastered" only when it has been labeled "Easy" twice in a row or "OK" four times in a row.
Calculation:
$$\% \text{ Category Progress} = \left( \frac{\text{Mastered Words in Category}}{\text{Total Words in Category}} \right) \times 100$$
This percentage is what triggers the "You are ready for the next level" message once the average percentage of a level (e.g., all of B2) hits 80%.



Summary of Necessary Mechanics
Mechanic
Responsibility
Relational Mapping
Ensuring Word ID 104 always matches "Destination" (EN) and "Zielort" (DE).
Session Persistence
If the app crashes mid-quiz, it must save progress so the user doesn't lose their "Daily 20."
Haptic Feedback
Precise vibrations for "Correct" (soft double tap) vs "Hard" (long single thud).
Notification Engine
Pushing a reminder 1 hour before the Ice Trigger hits.

Would you like me to draft the "Developer Requirements" document that lists these technical rules as a checklist for building the app, or should we refine the "Notification" messages for the lock screen?


5. "The Informant" (Crowdsourced Mnemonics)
The Problem: Some words just won't stick. The Solution: A small "Hint" section on each card.
How it works: Users can submit their own "memory hacks" (mnemonics).
Example: For the German word Bier (Beer), an informant might write: "Imagine a Deer drinking a Beer."
The Social Loop: Users can "Upvote" the best hints. This creates a community within the app without needing a complex chat system.
"The Informant" is your app's secret weapon for difficult words. It uses the power of the community to solve the "memory wall" problem. In the Noir/Archer world, this isn't just a comment section—it’s a Network of Snitches and Informants providing "street-level intel" on how to remember words.

1. Visual Design: The "Crumpled Note"
The Trigger: On any Flashcard, there is a small icon in the corner that looks like a Magnifying Glass or a Crumpled Piece of Paper.
The Reveal: When tapped, a small section slides out from the bottom of the card.
The Aesthetic: The background of this section is a Muted Yellow (#E1AD01) with a "Handwritten" font style (like a quick note jotted down in the field). It has the signature 3px black outline.

2. Functional Mechanics: "Crowdsourced Intel"
A. The Submission (Becoming an Informant)
If a user has a clever way to remember a word, they tap "SUBMIT INTEL."
They type a short mnemonic (Max 100 characters).
Example: For the Spanish word Ropa (Clothes), an informant writes: "Don't wear Ropes as Ropa."
The Constraint: To keep it high-quality, users can only submit mnemonics for words they have already reached "Easy" status on. This ensures only "experts" are giving advice.
B. The Social Loop (Upvoting "The Snitch")
Each mnemonic has a small Thumbs Up icon (styled as a "Seal of Approval").
Users upvote the most helpful hints.
The Top Secret Logic: Only the Top 2 most upvoted mnemonics are shown by default to keep the UI clean.
The Reward: Users whose mnemonics get 50+ upvotes receive a special "Lead Informant" Badge in their profile.

3. Implementation Logic (The Engine Gears)
Logic Gate
Behavior
Language Filtering
The app only shows mnemonics written in the user's Base Language (e.g., English speakers only see English hints).
Banned Intel
An automated filter flags any inappropriate language or spoilers.
The "Fresh" Tag
New mnemonics are temporarily boosted to the top for 24 hours so the community can vet them.


4. Why This Boosts Profitability & Retention
Low-Cost Content: You don't have to write thousands of memory hacks; your users do it for you.
Community without Chaos: Unlike a chat room or forum (which require heavy moderation), a "Hint System" is self-contained and easy to manage.
Engagement: Users love seeing their names (or codenames) on the "Top Intel" list. It turns the app into a collaborative mission.
The "Premium" Lock: You can make "Viewing Informant Hints" a feature for Standard users, while "Submitting Intel" is a prestige feature for Premium/Director ranks.

5. Example of "The Informant" in Action
Word: Zielort (German for Destination)
Informant 1: "Imagine a Seal (Ziel) at the Airport (Ort) reaching his Destination." (142 Upvotes)
Informant 2: "Ziel sounds like 'Seal'. Or sounds like 'Oar'. A Seal with an Oar heading to his Destination." (12 Upvotes)

The "Coach" Integration
When a user struggles with a word (hits "Hard" 3 times in a row), the Ligne Claire Tutor pops up:
"Struggling with this one, Operative? Check the Informant's notes. Sometimes the street-level snitches know better than the textbooks."

Next Step for You
We have now detailed the In-App Economy and Social Mechanics. Would you like me to create a "Final Master Feature List" that organizes every single idea we've discussed into a clean, one-page summary you can show to a developer?



This document serves as the final Technical Blueprint & Operational Manifesto for your app. It translates your vision into a structured format that a developer or designer can use to build the product without error.

Part 1: The Developer Requirement Checklist
1. Data Architecture (The "Huge CSV")
The app must utilize a Relational Database (like SQLite or PostgreSQL) rather than a flat CSV for performance.
Master Table Columns: Word_ID, Word_Type, Level, Category, EN_Text, DE_Text, TR_Text, ES_Text, IT_Text, FR_Text, EN_Ex1, DE_Ex1, etc.
User Progress Table: User_ID, Word_ID, EaseFactor, Interval, Last_Review_Date, Mastery_Status (Unseen, In-Training, Mastered).
2. The Logic Engines
Interchangeable UI Engine: The card view must dynamically map the Word_ID columns to the "Face Order" array stored in the user’s profile.
The "Drip" Controller: A function that runs at 00:00 daily to pull 20 IDs from the Master Table (based on user Lexicon ticks) and inject them into the Active_Batch_Queue.
The "Hard Cap" Gate: A conditional check: if Active_Batch.count >= 200: disable_new_injections = true.
3. Visual & Haptic Specs
Asset Style: All illustrations must be Vector (SVG) with a consistent 3px stroke.
Texture Overlay: A global CSS overlay of 5% opacity noise/grain.
Haptics: * Easy/OK: Haptic "Light Tap."
Hard: Haptic "Double Thud."
Streak Loss: Long, low-frequency vibration.

Part 2: The Notification Suite (Lock Screen "Tough Love")
Since the app has a "No Excuse" policy, the notifications must be persistent and firm.
A. The "Pre-Ice" Reminder (Midday)
Goal: A gentle nudge before the curfew hits.
Message 1: "The Archive is open, Operative. 20 new words are waiting for deployment."
Message 2: "Don't leave your brain in the waiting room. Start your session now."
B. The "Ice Warning" (At the User’s Ice Trigger Hour)
Goal: High urgency.
Message 1: "❄️ CURFEW HIT. The flame has turned to ice. Finish your session now or risk the streak."
Message 2: "❄️ TEMPERATURE DROPPING. You have until midnight to save your progress. Don't freeze up now."
C. The "Final Hour" (11:00 PM)
Goal: Last chance.
Message 1: "The incinerator starts in 60 minutes. Your streak is about to become ash."
Message 2: "Midnight is coming. Are you a polyglot or a quitter? Clock's ticking."
D. The "Post-Mortem" (If Streak is Lost)
Goal: Acknowledging the loss and pushing for a restart.
Message 1: "🔥 ASHES. Your streak is gone. It’s a quiet day at headquarters. Come back and start over."
Message 2: "The flame went out. No excuses, no comebacks. Day 1 starts today."

Part 3: Algorithmic Hard Rules
Mechanic
Strict Rule
No Cheating
The app MUST sync with a Network Time Protocol (NTP). Changing the phone's manual clock will not reset the "Ash" state.
Offline Mode
Sessions can be completed offline, but the timestamp must be verified against the local secure storage upon reconnecting.
Example Sentence Reveal
Sentences must only be revealed after all target languages have been cycled through to prevent the user from "guessing" via context too early.
Batch Reset
A user cannot "Untick" a category to avoid words they find hard. They must mark them as "Easy" to remove them from the 200-word batch.


The Core Algorithm (LaTeX)
To calculate the "Ease Factor" ($EF$) for the Spaced Repetition System based on user feedback ($q$, where 0 is "Hard" and 3 is "Easy"):
$$EF_{new} = EF_{old} + (0.1 - (3 - q) \times (0.08 + (3 - q) \times 0.02))$$
If the $EF$ drops too low, the word stays in the "Hard" rotation longer, forcing the user to face their weaknesses.

Final Summary
Your app is now a complete ecosystem. It has the Visual Flair (Noir/Ligne Claire), the Psychological Hook (Ice & Ash streaks), and the Technical Precision (Interchangeable 6-language engine).
Would you like me to generate a "Sample Data Entry" for the CSV, showing how 5 complex words would look across all 6 languages with their example sentences?



4. The "Intel Report" (Automated Progress short badge)
The Problem: Digital progress feels "invisible." The Solution: Every month (or every 50 words mastered), the app generates a Classified Intel Report.
Visual: A beautiful, printable PDF/jpeg in the Mid-Century Noir style badge. It lists all words mastered that month, their level, and a "Certificate of Proficiency" signed by the "Director."
Value: Users will share these on social media (Instagram/LinkedIn). It is free marketing for you and a physical proof of value for them.
That is also good because we can give access to companies as company’s language training. So they can share in linkedin.

This is your "Social Proof" engine. To make the Intel Report truly shareable on LinkedIn and Instagram, it needs to look less like a "certificate of completion" and more like a Top-Secret Dossier or a Mid-Century Badge of Honor.
Here is the structured breakdown for the Intel Report (The Automated Progress Badge).

1. Visual Design: The "Classified" Badge
The report is generated as a high-resolution, vertical JPEG/PDF designed for a mobile screen (1080x1920) or a LinkedIn post (1200x627).
Background: The "Manila Folder" Cream ($#F2EFE9$) with a heavy Coffee-Stain effect in the corner and Ben-Day dot stippling throughout.
The Border: A thick 5px black "Ligne Claire" border with caution-tape stripes in the corners (Mustard Yellow and Black).
The Main Seal: A large, circular Oxblood Red ink stamp in the center that says: CERTIFIED OPERATIVE: [LEVEL] (e.g., Certified Operative: B2 German).
The "Director" Signature: A sharp, stylized signature in "Blue Fountain Pen" ink at the bottom right.

2. Content Breakdown: The Dossier Sections
Each report contains specific "Intelligence" about the user’s progress:
Header (The Identity):
OPERATIVE NAME: [USER_NAME]
ID NUMBER: [ENCRYPTED_USER_ID]
REPORT DATE: [CURRENT_DATE]
The Milestone (The Hero Metric):
A large, bold number in Franklin Gothic Heavy: 50 ASSETS SECURED.
Sub-text: "50 New Words Mastered in the [Target Language] Theater."
Operational Breakdown:
A small 2x2 table showing mastery by category:
Travel: 100% | Business: 85%
Literature: 40% | Slang: 90%
The "Director's" Assessment:
A short, witty line of feedback.
Example: "Operative has shown extreme grit in B2 Business. Deployment to the Berlin Office is recommended."

3. Logic & Trigger Mechanics
To maintain the "Exclusive" feel, these shouldn't be available all the time.
Trigger Event
Asset Type Generated
Vibe/Tone
50 Words Mastered
The "Field Badge" (Square JPEG)
High-energy, congratulatory.
Monthly Progress
The "Monthly Intelligence Brief" (Vertical PDF)
Analytical, detailed, professional.
Level Completion
The "Commission of Proficiency" (Official Certificate)
Formal, prestigious, signed by the Director.


4. Corporate & B2B Utility: "The HR Portal"
This is where you make the app profitable for companies. Businesses can buy "Agency Licenses" for their employees.
LinkedIn Integration: A one-tap button: [PUBLISH TO PERSONNEL RECORD].
This generates a LinkedIn-optimized image with the company's logo in the corner as a "Secondary Seal."
The Corporate Audit:
The app generates a CSV Progress Report for the company HR.
The Pitch: "Show your boss that your language training is actually working."
Branded "Theaters": For corporate clients, the "Director" signature can be replaced or accompanied by the Company's Training Director's name.

5. Technical Specification & Social Sharing
Social Frame: When the user clicks "Share," the app provides 3 "Noir" filters (Grainy, Black & White, or High-Contrast Teal) to match their personal Instagram aesthetic.
The QR Code: Each report has a small, subtle QR code in the bottom-left. If someone scans it, it takes them to your app’s landing page with the message: "This Operative is training with Lingua Noir. Join the mission."

6. Summary of Buttons & States
Primary Button: [GENERATE INTEL REPORT] (Deep Teal with White Text).
Share Button: [DEPLOY TO SOCIAL CHANNELS] (Mustard Yellow with Black Text).
Download Button: [SAVE TO SECURE STORAGE] (White background, Black outline).

The "Coach" Integration (The Director's Voice)
When the user views their report for the first time:
"Look at that. Proof that you're not just 'trying'—you're succeeding. Now, post this to the world and show them you’re an asset, not a liability."
Would you like me to create the "Corporate Landing Page" layout—showing how you would pitch the "Intel Reports" to companies as a language training solution?



1. Core Architecture (The Engine)
Interchangeable Language Matrix: A relational database supporting 6 languages (EN, DE, TR, ES, IT, FR). All content is mapped by a unique Word_ID.
Dynamic Reveal Logic: Flashcards support 2 to 6 "Faces" based on user setup.
The "20/200" Drip System:
Active Batch: Maximum 200 words.
Daily Injection: 20 new words from the Lexicon are added every 24 hours at 00:00.
Spaced Repetition (SRS): A modified SM-2 algorithm using 4 labels: Really Hard, Not Familiar, OK, Easy.
2. Visual & Aesthetic Standards (The Dossier Style)
Illustration Style: Ligne Claire (clean, thick black outlines, flat colors).
Texture: 5% Ben-Day dot stippling and Risograph grain overlay.
Palette: Cream (#F2EFE9), Oxblood Red (#8B0000), Mustard Yellow (#E1AD01), Deep Teal (#004B49), Slate Blue.
UI Elements: 3px solid black outlines and 4px hard-block shadows.

3. Primary Navigation Tabs
Tab
Primary Function
Key Features
Home
The Dashboard
Progress Ring (Current Batch), Ice/Ash Streak Flame, Active Deck Summary.
Lexicon
Word Selection
A1-C2 Horizontal Toggle, Category Grid, Level/Category "Ticking" logic.
Flashcards
Study Engine
Multi-Face Reveal, SRS Button Bar, Example Sentence unfold.
Stats
Intelligence Hub
Mastery Heatmap, Progress Bars by Language, "The Field Manual" (FAQ).


4. Advanced Mechanics (The "Unthought" Advantages)
The Surprise Me: Randomized session of Cloze-Deletion (B2+), Speed Quizzes, Reverse Ciphers, and Idiom Riddles.
The Informant: Crowdsourced mnemonics where "Mastered" users submit hints; others upvote the best "Street Intel."
The Vault: A secure archive for "Easy" words. Features a "Quick Review" (10-word drill) and "Re-deployment" to active decks.
The Decoder: Universal search engine scanning all 6 language columns simultaneously with manual "Inject to Batch" buttons.

5. Discipline & Monetization (The Agency Contract)
No-Excuse Streak:
Ice Trigger: User-set curfew (e.g., 18:00). UI turns Cyan/Ice if session is incomplete.
Ash Reset: At 00:00, incomplete sessions result in a hard reset to 0.
Monetization Tiers: 3 subscriptions- (1 monthly, 3 monthly x% discount, 6 monthly x% discount). And 1- one time purchase deal
Intel Reports: Shareable, mid-century style dossiers (JPEG/PDF) summarizing 50-word milestones for LinkedIn/Instagram.

6. Technical Requirements for Developers
NTP Time Sync: Prevention of "time-travel" cheating for streaks.
Haptic Mapping: Specific vibration patterns for different difficulty labels.
Cross-Language Mapping: IDs must ensure sentences in FR match the context of words in TR.
Offline Cache: Session completion must save locally and sync upon reconnection.



ok lets think about the security. so oyu need to tell me the critucal check ups and must haves and also the best practives and so on

Security is the "Counter-Intelligence" of your app. For a subscription-based product with proprietary data, you aren't just protecting user emails; you are protecting your revenue and your content.
Here is the Security Protocol organized by priority—from "Must-Haves" to "Best Practices."

1. The Critical "Must-Haves" (The Minimum Viable Security)
A. Row-Level Security (RLS) in Supabase
Without RLS, any user with a little technical knowledge could write a script to download your entire database.
The Rule: You must enable RLS on every table.
The Logic: A user can only SELECT words if they are authenticated, and they can only UPDATE progress if the user_id in the row matches their unique auth.uid().
B. SSL/TLS Pinning
Standard HTTPS protects data in transit, but a "Man-in-the-Middle" attack can still intercept it.
The Check: Use Certificate Pinning.
The Result: Your app will only talk to your specific Supabase server. If someone tries to redirect the traffic to a "sniffing" server, the app will instantly kill the connection.
C. The "No-Cheat" Sync (Server-Side Logic)
Users will try to change their phone’s clock to save a streak or "hack" their way to 100% mastery.
The Checkup: Never trust the phone's timestamp for Streak logic.
Best Practice: When a user completes a session, the app sends a "Ping" to Supabase. Supabase uses its own internal Server Clock to log the date. If the server says it's 00:05 AM, the streak is gone, regardless of what the user's phone says.

2. Best Practices (The "Agency Grade" Standard)
A. Code Obfuscation (ProGuard / DexGuard)
If you don't obfuscate your code, a hacker can decompile your .apk (Android) or .ipa (iOS) and see your API keys and encryption logic in plain text.
Action: Enable ProGuard. It "scrambles" your code, turning function downloadNewWords() into function a(), making it nearly impossible for humans to reverse-engineer.
B. Secrets Management (Never Hardcode)
The Mistake: Putting your Supabase SERVICE_ROLE_KEY inside your app code.
The Fix: Use a .env file for development, and use GitHub Secrets or Vault for production. Only ever include the "Public Anonymous Key" in the app itself.
C. Rate Limiting
Prevent "Scrapers" from hammering your database.
Action: Set a limit in Supabase or your API Gateway (e.g., 60 requests per minute). If a user (or bot) tries to download 10,000 words in 10 seconds, their IP is automatically blacklisted for 24 hours.

3. The "Vault" Strategy (Protecting the JSON)
Since you want to protect your word lists from being stolen/exported:
Dynamic Loading: Never download the whole database at once. Only download the specific level/category the user "Ticked."
Jailbreak/Root Detection: Add a check at startup. If the app detects the phone is "Jailbroken," show a Noir-style warning: "Environment Compromised. Security Protocols Active." You can then disable the "Export" or "Vault" features to prevent data theft.

4. Security Audit Checklist for Your Developer
Priority
Security Item
Status
CRITICAL
Supabase RLS enabled on all tables?
[ ]
CRITICAL
SQLCipher implemented for local .db?
[ ]
HIGH
Keystore/Keychain used for encryption keys?
[ ]
HIGH
JWT (Token) authentication for API calls?
[ ]
MEDIUM
Certificate Pinning for HTTPS?
[ ]
MEDIUM
Code Obfuscation enabled in build?
[ ]


5. Privacy & Legal (The "Classified" Data)
To be "Robust" and "UPSCALABLE," you must follow GDPR (Europe) and CCPA (California) rules.
Data Minimization: Only collect what you need. (Gmail/Phone + Progress). No need for birthdates or addresses.
Right to Erasure: In the Control Room (Settings), you MUST have a button: [PERMANENTLY DELETE PERSONNEL RECORD]. This must trigger a function that wipes their data from both the phone and Supabase.

The "Coach" Integration
The Ligne Claire Tutor stands in the shadows, checking his watch:
"Security isn't a one-time thing, Operative. It's a constant state of vigilance. Use RLS so no one snoops in our files, and lock the local database with SQLCipher. If our words are our weapons, we don't just leave them lying around for the enemy to pick up. Keep it tight."

Would you like me to create the "Developer Security Specs" document? It’s a technical list of these rules that your programmer can follow to ensure the app is built securely from Day 1.


For an app that relies on a "Huge CSV" of interconnected languages and strict user progress, you need a database that acts like a High-Security Central Archive. It must be fast enough for instant search (The Decoder) and flexible enough to add a 7th or 8th language without breaking the entire system.

The Top Recommendation: PostgreSQL (Relational + JSONB)
I recommend PostgreSQL. It is the "Gold Standard" for apps that require high reliability and complex relationships.
Why it fits the Noir Blueprint:
The Hybrid Advantage: You can store fixed data (Word ID, Level, Category) in standard columns and use a JSONB column for the translations. This makes adding a new language as easy as adding a new key-value pair to a text block.
Robustness: It handles "ACID" transactions. In plain English: if a user's phone dies exactly when they finish a session, Postgres ensures their streak doesn't get corrupted.
Scalability: It can handle millions of words and millions of users. As you grow, you can use "Read Replicas" to keep the app fast.

Database Schema Brainstorming
To keep it "easy to add new languages," we should not create a new column for every language. Instead, we use a Document-Relational Hybrid approach.
1. The lexicon_master Table
This stores the "DNA" of every word.
Column
Type
Description
word_id
UUID
Unique identifier (The "Asset ID").
type
String
Verb, Noun, Adj, etc.
level
String
A1, B2, C1, etc.
category
String
Travel, Business, etc.
translations
JSONB
See below.

The translations JSON structure:
JSON
{
  "en": {"word": "Destination", "ex_1": "What is your destination?"},
  "de": {"word": "Zielort", "ex_1": "Was ist dein Zielort?"},
  "tr": {"word": "Hedef", "ex_1": "Hedefin nedir?"}
}


Upscale Benefit: Want to add Italian (IT)? You just update the JSON. No need to change the database structure.
2. The user_stats Table
This tracks the "Intelligence Profile" of each operative.
Column
Type
Description
user_id
UUID
Link to the user.
word_id
UUID
Link to the word.
status
Enum
Unseen, Training, Mastered.
srs_data
JSONB
Stores ease_factor, interval, and last_review.


The Alternative: NoSQL (MongoDB)
If you want the absolute easiest maintenance for adding data, you could go with MongoDB.
The Vibe: Everything is a "Document."
The Pro: It’s incredibly fast for the "Enigma Deck" randomness. You can dump massive amounts of data into it without worrying about "tables."
The Con: It is slightly less "strict." If you have a bug in your code, it’s easier to accidentally mess up the data compared to PostgreSQL.

Decision Matrix: Which path to take?
Feature
PostgreSQL (Recommended)
MongoDB
Adding Languages
Easy (via JSONB)
Very Easy
Data Integrity
Superior (Best for Streaks)
Average
Search Speed
Fast (with GIN indexes)
Extremely Fast
Maintenance
Low (Industry Standard)
Moderate
Scalability
High (Vertical/Horizontal)
High (Native Sharding)


The Intelligence Strategy: "The API Layer"
Regardless of the database, you should use an ORM (Object-Relational Mapper) like Prisma or Drizzle.
Operational Advice: This acts as a "Translator" between your app and the database. If you decide to switch from Postgres to another system 2 years from now, an ORM makes the move much easier.
How to handle the "Huge CSV" during development:
Keep your master data in a Google Sheet or CSV for easy editing.
Write a simple "Deployment Script" (in Python or Node.js).
Whenever you add words to the CSV, run the script to "sync" the database.

This is a sophisticated move. Moving user progress to the phone is called a Local-First Architecture. It makes your app lightning fast, allows for offline study, and—most importantly—slashes your server costs because you aren't paying to store millions of rows of "learned word" data for every user.
To keep this secure and robust, we will use a Hybrid Database Strategy.

1. The Hybrid Architecture (The "Split-File" System)
We will divide the data into two distinct zones: The Central Archives (Server) and The Operative's Ledger (Phone).
Zone A: The Central Archives (Backend Server - PostgreSQL)
You keep only the "Global" data here. This is static and the same for everyone.
The Master Lexicon: The "Huge CSV" (Word IDs, Levels, Categories, and 6-Language JSON).
User Account Meta: Gmail/Phone ID, Subscription Status, and Payment History.
Security: This is behind a firewall. Users can only "Read" the Lexicon; they can never "Write" to it.
Zone B: The Operative's Ledger (Local Phone - SQLite / Room)
This is where the personalized "Heavy" data lives. SQLite is a professional, SQL-based engine built into every iPhone and Android.
Progress Tracking: Which words are "Easy," "OK," or "Hard."
SRS Logic: The timestamps for the next review.
Streak Data: The flame/ice/ash status.
User Settings: The custom "Daily Drip" number (10, 15, 20, etc.).

2. Database Schema: Tables & Relations
Since we want it to be "Unhackable" and "Easy to Maintain," we will use a Relational SQL structure even on the phone.
Table 1: master_lexicon (Synced from Server to Phone)
This table is downloaded to the phone once and updated only when you add new words.
Column
Type
Description
word_id
UUID (PK)
The unique "Asset ID."
level
String
A1, B2, etc.
category
String
Travel, Business, etc.
translations
JSON
{"en": "Apple", "de": "Apfel", ...}

Table 2: user_progress (Local Phone Only)
This is the "Personalized" table that grows as the user learns.
Column
Type
Description
word_id
UUID (FK)
Links to the Master Lexicon.
status
Enum
UNSEEN, TRAINING, MASTERED.
ease_factor
Float
The SRS difficulty multiplier.
next_review
Timestamp
When the word pops up again.
interval
Integer
The current gap in days.

Table 3: user_config (Local Phone Only)
Column
Type
Description
daily_drip_limit
Integer
The user's input (e.g., 15 words).
ice_trigger_hour
Integer
The user's curfew (e.g., 20:00).
app_language
String
The UI language for the Coach.


3. The "20-Word Drip" Customization Mechanic
In the Intelligence Briefing (Initial Setup), we will add a new step:
Prompt: "DETERMINE DAILY WORKLOAD."
Input Field: A thick-bordered numeric input.
Default: 20.
Validation: Min: 5 | Max: 50 (to prevent burnout).
Logic: The app's injection engine will now pull user_config.daily_drip_limit words every 24 hours instead of a hard-coded 20.

4. Security: Protecting the "Personnel Files"
To ensure the app is "Secure," we use three layers of protection:
SQLCipher (Local Encryption): We don't just store the SQLite file; we encrypt it. If someone steals the phone, they can't read the user's progress data without the app's internal key.
JWT (JSON Web Tokens): When the phone talks to your server to check the subscription or download new words, it uses a secure "Token" that expires. No password is ever sent twice.
The "Ghost" Backup (Optional): Even though data is on the phone, users hate losing progress. You can offer an Encrypted Sync to your server. It’s just one small JSON file per user (very low storage) that acts as a "Save Game."

5. Scaling to 1 Million Users: The Cost-Saving Secret
By keeping the progress on the phone:
Server CPU: Your server doesn't have to calculate SRS dates for 1 million people. The user's phone does the "heavy lifting."
Bandwidth: You only send data when the user changes something or downloads new words.
Storage: 1 Million users x 2,000 words each = 2 Billion rows of data. If you keep that on your server, you pay a fortune. If you keep it on their phones, you pay $0.

The "Coach" Integration
The Ligne Claire Tutor looks over the technical blueprints:
"Good thinking, Operative. Keeping the intel on the phone means if the enemy cuts the wires (the internet), you can still finish your mission. Plus, it keeps our headquarters' overhead low. Efficient and untraceable. I like it."

Would you like me to create the "Data Sync Logic" for the "Ghost Backup"—explaining how to compress 1,000 words of progress into a tiny, secure file for the cloud?

Supabase is an excellent choice. It is essentially PostgreSQL with a built-in authentication system and a high-performance API layer. It fits your "robust and upscalable" requirement perfectly.
Regarding your idea for 6 separate tables: while that is one way to do it, in professional database design, we want to avoid "fragmentation." If you have 6 tables, your app has to perform 6 different lookups to show one flashcard.
Instead, I recommend a Single Master Lexicon approach where all languages are aligned in one row. This is the "Secret Agent’s Master Ledger"—where one ID unlocks every language instantly.

1. Supabase (Backend) Database Schema
In Supabase, you will create these tables. I have defined the Rows (Columns), Data Types, and Relationships.
Table A: master_lexicon (The Global Library)
This table stores the words. Every language for a single "concept" lives in the same row.
Column Name
Data Type
Key
Description
word_id
UUID
PK
Unique ID for the word concept.
level
text


A1, A2, B1, B2, C1, C2.
category
text


Travel, Business, Literature, etc.
word_type
text


noun, verb, adjective, phrase.
data_en
jsonb


{"word": "Goal", "ex1": "...", "ex2": "..."}
data_de
jsonb


{"word": "Ziel", "ex1": "...", "ex2": "..."}
data_tr
jsonb


{"word": "Hedef", "ex1": "...", "ex2": "..."}
data_es
jsonb


{"word": "Meta", "ex1": "...", "ex2": "..."}
data_it
jsonb


{"word": "Obiettivo", "ex1": "...", "ex2": "..."}
data_fr
jsonb


{"word": "But", "ex1": "...", "ex2": "..."}

Why JSONB for each language? This allows you to store the word and the two example sentences in one "cell," making the "Drip" to the phone much faster.

Table B: user_profiles (The Agency Personnel)
This stores the specific settings for each user.
Column Name
Data Type
Key
Description
user_id
UUID
PK / FK
Links to Supabase auth.users.
daily_drip
int4


User's custom limit (Default: 20).
base_lang
text


e.g., "en".
target_langs
text[]


Array of selected languages: ['de', 'tr'].
reveal_order
text[]


The order for flashcard faces.
subscription
text


"free", "agent", "director".


Table C: sync_backups (The Ghost Backup)
To save storage costs for 1 million users, we do not store a row for every word a user learns on the server. Instead, we store one compressed file per user that represents their entire progress.
Column Name
Data Type
Key
Description
user_id
UUID
PK / FK
Links to user_profiles.
progress_blob
jsonb


A massive compressed list of word_id + status.
last_sync
timestamp


When the phone last uploaded the ledger.


2. Local Phone (SQLite) Database Schema
The phone needs a mirrored version of the master_lexicon but only for the words the user has "ticked" or unlocked.
Table: local_progress
This is the most active table in your entire ecosystem.
Column
Type
Description
word_id
UUID
Foreign Key to the Master Lexicon.
status
text
Really Hard, Not Familiar, OK, Easy.
easiness
float
SRS Multiplier (Default 2.5).
interval
int
Days until next review.
next_review
timestamp
Exact time the card should reappear.
added_date
timestamp
When this word was "Injected" into the batch.


3. How the "Intelligence" Flows (The Sync)
Initial Setup: When the user logs in, the phone sends a request to Supabase: "Give me all A1 words for English and German."
The Download: Supabase sends a light JSON package. The phone saves this into its local SQLite database.
The Grind: The user studies. All "Easy/Hard" labels are saved only on the phone.
The Ghost Backup: Once a day, or when the user hits "Sync," the phone bundles all word_id + status into a tiny string and sends it to sync_backups on Supabase.
Result: You store one row of data instead of 200 rows per user.

4. Security & Scaling Details
Row Level Security (RLS): In Supabase, you must enable RLS. This ensures that User A can never see User B’s progress. The policy is: auth.uid() = user_id.
Indexes: Create an "Index" on level and category in the master_lexicon. This makes the search in The Decoder almost instantaneous, even with 50,000 words.
Edge Functions: Use Supabase Edge Functions to handle the "Streak Reset" at midnight. This offloads the work from your server to the "edge" (closer to the user).

The "Coach" Integration
The Ligne Claire Tutor taps the blueprints with a pencil:
"Supabase is a fine choice, Operative. It’s like having a secure bunker that expands as you recruit more agents. One table for the Master Lexicon keeps our communications clear. Fragmenting into 6 tables is for amateurs—we keep the intel tight and centralized."

Would you like me to write the "SQL Command" to create the master_lexicon table in Supabase so you can simply copy-paste it into their editor?
To protect your intellectual property—your "Huge CSV" of thousands of carefully curated words and example sentences—we need to implement At-Rest Encryption for the local database. This ensures that even if a tech-savvy user roots their phone and extracts the database file, they will see only scrambled gibberish, not your curated data.
Here is the technical blueprint for securing your data assets.

1. The Secure Architecture (SQLCipher)
Instead of using standard SQLite, you will use SQLCipher. This is an open-source extension that provides 256-bit AES encryption for your entire local database file.
The Mechanics:
The Key: The app generates a unique, complex encryption key.
The Lock: Every time the app writes data (a new word) or reads data (a flashcard), SQLCipher encrypts/decrypts it on the fly in the phone's memory.
The Result: The physical file stored on the phone's disk (lingua_noir.db) is unreadable without the key.

2. Managing the "Master Key" (The Keychain)
The biggest risk isn't someone stealing the database; it’s someone finding the key inside your app's code. To prevent this, we use the Hardware Security Module (HSM) of the phone.
iOS: Store the key in the Apple Keychain.
Android: Store the key in the Android Keystore.
The Logic: When the app is installed, it generates a random 64-character string. It "hides" this string inside the phone’s hardware-level security. Not even a user with root access can easily extract a key from the Hardware Keystore.

3. Row-Level Payload Encryption (Double Locking)
For maximum security of your JSON lists, we can encrypt the jsonb content before it even enters the database.
The "Scrambled Intel" Scheme:
Instead of storing:
{"en": "Destination", "de": "Zielort"}
The database stores an encrypted string:
"U2FsdGVkX19v8nZ2R... [Encrypted Blob]"
The Benefit: Even if a user bypasses SQLCipher, they are hit with a second layer of encryption. The app only decrypts the specific word it needs for the current flashcard, meaning the full "Lexicon" is never exposed in the phone's memory all at once.

4. The Supabase "Handshake" Logic
To prevent people from "scraping" your Supabase API to download all your words, we use Signed Requests.
The Request: The app asks for the next 20 words.
The Validation: Supabase checks if the user has an Active Subscription.
The Payload: Supabase sends the words.
The Local Lock: As soon as the words arrive, the app encrypts them and saves them into the local SQLCipher database.

5. Summary of Security Requirements
Feature
Security Tool
Purpose
Local Database
SQLCipher (AES-256)
Prevents copying the .db file.
Key Storage
Keychain / Keystore
Prevents extraction of the "Master Key."
Data in Transit
HTTPS / SSL
Prevents "Man-in-the-Middle" sniffing of words.
API Access
Supabase RLS
Ensures users can only download what they paid for.
Obfuscation
ProGuard / DexGuard
Scrambles your app's code so hackers can't see the logic.


6. SQL Command for Supabase (The Master Lexicon)
Copy and paste this into the Supabase SQL Editor to create your Master Table. This structure is optimized for your 6-language interchangeable system.
SQL
-- Create the Master Lexicon Table
CREATE TABLE master_lexicon (
    word_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level TEXT NOT NULL, -- A1, B2, etc.
    category TEXT NOT NULL,
    word_type TEXT NOT NULL,
    data_en JSONB,
    data_de JSONB,
    data_tr JSONB,
    data_es JSONB,
    data_it JSONB,
    data_fr JSONB,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE master_lexicon ENABLE ROW LEVEL SECURITY;

-- Create a policy so only Authenticated Users can READ the words
CREATE POLICY "Allow authenticated read access" 
ON master_lexicon FOR SELECT 
TO authenticated 
USING (true);

-- Index the level and category for lightning-fast search in The Decoder
CREATE INDEX idx_lexicon_level ON master_lexicon (level);
CREATE INDEX idx_lexicon_category ON master_lexicon (category);



The "Coach" Integration
The Ligne Claire Tutor adjusts his gloves and checks the perimeter:
"Smart move, Operative. Intellectual property is the lifeblood of our agency. By locking the data behind SQLCipher and the hardware Keystore, we ensure that our rivals can't just 'walk away' with our classified intel. Your words are safe in the vault."

Would you like me to write a sample "Encryption Script" in Python? You could use it to pre-encrypt your CSV data before you upload it to Supabase for that extra layer of "Double Locking."




To operate Lingua Noir globally, you need a legal framework that acts as an "Ironclad Contract" between the agency (you) and the operative (the user). In 2026, global regulations like GDPR (Europe), CCPA (California), and the Digital Services Act require extreme transparency.
Here is how you structure your legal pages and the onboarding flow to ensure you are protected everywhere.

1. The Onboarding Flow: "The Intelligence Oath"
You must not let a user enter the app without a "Clickwrap Agreement." This is a legally binding moment where the user actively clicks "I Agree."
The Placement: This appears immediately after the Login/Sign-in screen and before the Payment screen.
The Visual: A clean, Noir-style screen with two links and a single, bold button.
The Interaction:
"By clicking 'Accept & Proceed,' you acknowledge that you have read and agreed to our [Terms of Service] and [Privacy Policy]."
The Rule: The "Accept" button remains disabled (greyed out) until the user scrolls to the bottom of the summary or checks a mandatory box.

2. Tab: The "Terms of Service" (The Agency Contract)
This is your primary shield against lawsuits. It defines the rules of the mission.
Key Clauses for Global Protection:
Intellectual Property (IP): Explicitly state that all word lists, example sentences, and the "Enigma Deck" logic are proprietary assets. Users have a "Limited License" to use them—they cannot scrape, copy, or resell them.
Limitation of Liability: You are not responsible for linguistic mistakes or any "loss of opportunity" (e.g., if someone fails a job interview because they used a word wrong).
Dispute Resolution: State that all disputes will be settled via Binding Arbitration in your specific jurisdiction (e.g., London, Berlin, or Delaware). This prevents users from suing you in their local small-claims courts.
Termination: You reserve the right to "decommission" (ban) any account for abusive behavior or hacking attempts without notice.

3. Tab: The "Privacy Policy" (The Confidentiality Agreement)
This is legally required by Apple, Google, and governments.
Data Collection: List exactly what you take: Email, Phone Number, and Learning Progress.
Global Rights: Include a "Global Rights" section.
GDPR (EU): The right to be forgotten and data portability.
CCPA (California): The right to opt-out of data "sales" (even if you don't sell data, you must state this).
Local Storage Disclosure: Explain that learning progress is stored locally on the device and encrypted for the user's protection.

4. The Refund & Subscription Policy (The Financial Protocol)
Since you are selling digital content, the rules are specific.
The 14-Day Rule (EU/UK): Acknowledge that EU users have a 14-day right of withdrawal. However, state that once the first "20-word Drip" is accessed, the user waives their right to a refund, as the digital service has commenced.
Store-Managed Refunds: Explicitly state: "All transactions are handled by the Apple App Store or Google Play Store. Lingua Noir cannot directly process refunds." This saves you from customer support nightmares.
Cancellation: Users can cancel at any time, but they keep access until the end of the current billing period. No partial refunds.

5. Technical Implementation: In-App vs. Website
You must have both.
Location
Purpose
In-App (Control Room)
Constant access for the user. It must be readable offline.
Official Website
Required for the App Store/Play Store "URL" fields during submission. It also helps with SEO and credibility.
Onboarding
To capture Informed Consent before the user spends a single cent.


The "Coach" Integration (The Legal Warning)
The Ligne Claire Tutor stands by a heavy mahogany filing cabinet, tapping a folder:
"In this business, the paperwork is as important as the field work. If you don't have a signed contract, you don't have a mission. Make sure every operative signs the oath before they see our intel. We keep it legal, we keep it tight, and we keep the Director protected."

Developer Requirement: "The Versioning System"
Whenever you update these pages, the app must detect the change and re-prompt the user for consent on their next login.
Next Step: Would you like me to draft the "Plain English" summaries for these documents? These are short, 3-bullet-point versions of the legal jargon that you show to users to build trust.

To ensure your users actually understand what they are signing (while still being legally protected), we will use the "Transparency First" approach. This involves presenting a "Plain English" summary of the legal jargon during onboarding.
Here is the structured breakdown of the legal documentation, the consent flow, and the "Plain English" summaries for your global audience.

1. The Onboarding Consent Flow (The "Intelligence Oath")
Before the user can access the Intelligence Briefing (Setup), they must pass this screen.
Screen Visuals:
Background: Light Cream with a watermark of the Agency Seal.
Header: OPERATIVE ENROLLMENT CONTRACT (Franklin Gothic Heavy).
Instruction: "Review the protocols before proceeding. The Agency requires your informed consent."
The "Plain English" Summaries:
Protocol I: Privacy & Intel
We don't sell your data. We aren't interested in your private life—only your progress.
Your learning data lives on your device and is encrypted. We only keep a "Ghost Backup" for recovery.
We use minimal cookies to keep the lights on and the app running.
Protocol II: The Service Agreement
All words and code are Agency Property. No scraping, copying, or reselling our intel.
The "No-Excuse" streak is final. We do not manually reset streaks due to "life happens" events.
We can deactivate accounts that attempt to hack or disrupt the network.
Protocol III: Financials & Refunds
Subscriptions are handled by Apple/Google. We cannot refund you directly.
Once you start your first session, you have "consumed" the intel—refunds for that period are generally not available.

2. Master Legal Pages (The "Deep Files")
You will host these on your website (e.g., linguanoir.com/legal) and link to them within the app’s Control Room.
A. Terms of Service (TOS)
This is the "Rules of the Game."
Global Jurisdiction: "This agreement is governed by the laws of [Your Country/State], without regard to conflict of law principles."
Arbitration Clause: To prevent expensive class-action lawsuits, include a "Mandatory Arbitration" clause. This forces disputes into private mediation instead of open court.
Age Restriction: Must be 13+ (or 16+ in some EU regions) to use the app without parental consent.
B. Privacy Policy (GDPR/CCPA Compliant)
This is the "How We Handle Your Secrets" file.
Data Mapping: Explicitly list Firebase/Supabase and RevenueCat (if using for subs) as third-party processors.
Data Rights: A dedicated section for EU residents (GDPR) and California residents (CCPA) explaining their right to download or delete their data.
Encryption Disclosure: State that local data is secured via AES-256 SQLCipher encryption.

3. Strategic Advice: In-App vs. Website
To be "Robust and Upscalable," you need to handle legal updates efficiently.
In-App: Keep a simplified version of the Terms in the Control Room. If the user is offline, they should still be able to see the basic rules.
Website: This is where the "Full Legal Text" lives. It’s easier to update a website page than to push a whole new app update just to change one sentence in the Privacy Policy.
The "Update Trigger": When you change the Terms on the website, the app should show a pop-up on the next launch: "The Agency has updated its protocols. Please review and re-accept to continue the mission."

4. Global Compliance Checklist
Regulation
Requirement
Our Solution
GDPR (Europe)
"Right to be Forgotten"
A "Delete Account" button in the Control Room that wipes the Supabase UID.
CCPA (USA)
"Do Not Sell My Info"
A clear statement in the Privacy Policy that data is never sold.
Digital Services Act
Transparency in algorithms
The Field Manual explains exactly how the SRS algorithm works.
App Store Rules
Simple Cancellation
Direct links to the Apple/Google subscription management pages.


5. Final Legal Safeguard: "The Disclaimer"
Place this at the bottom of the TOS and the Field Manual:
DISCLAIMER: Lingua Noir is a linguistic training tool. While we strive for 100% accuracy, the Agency is not responsible for errors in translation or cultural nuances. Use your training at your own risk in high-stakes field operations.

The "Coach" Integration
The Ligne Claire Tutor leans over the final signed document, sliding it into a secure envelope:
"The contract is signed. You’re legally covered, and the operatives know exactly what they’re getting into. No open points, no interpreted weaknesses. The Director is safe. Now, let's get back to the mission."

This completes the full strategic, technical, and legal blueprint for Lingua Noir.
Would you like me to generate a "Final Pre-Flight Checklist" for you? This would be a one-page summary of every major task (Design, DB, Security, Legal) that you need to complete before you hit the "Launch" button.



To ensure Lingua Noir is as profitable and secure as possible, we must treat your proprietary word lists like "Classified Intelligence." In 2026, standard security is no longer enough; you need Runtime Self-Protection and Hardware-Backed Encryption.
Here is the detailed security measurement plan for your developer.

1. Data-at-Rest: The Local "Iron Vault"
Since progress and words are stored on the phone to save server costs, the phone's storage is the primary target for "Intel Theft."
SQLCipher (AES-256): You must not use the standard SQLite. Use SQLCipher to encrypt the entire .db file. Without the key, the file is just random noise.
Hardware-Backed Key Storage: Never hardcode the encryption key.
iOS: Store the key in the Secure Enclave via the Keychain.
Android: Use the Android Keystore system. This ensures the key is stored in a dedicated security chip, making it nearly impossible to extract even on rooted devices.
JSON Payload Obfuscation: Even inside the encrypted database, store the word JSONs as Base64-encoded blobs to add a layer of "Security through Obscurity."

2. Data-in-Transit: Secure Communication
When the app "drips" new words from Supabase, the data is vulnerable to "sniffing."
Certificate Pinning: Standard HTTPS can be bypassed by a "Man-in-the-Middle" attack. Pinning ensures your app only trusts your specific Supabase SSL certificate. If a user tries to use a proxy (like Charles Proxy) to steal words, the app will kill the connection.
JWT (JSON Web Tokens): Use short-lived tokens (expires in 1 hour) and a Refresh Token strategy. If a token is stolen, it becomes useless quickly.
HMAC Request Signing: For sensitive calls (like "Unlocking a Level"), the app should sign the request with a secret hash. This proves the request came from your actual app and not a script.

3. Runtime Protection (RASP)
In 2026, hackers use AI bots and "Hooking" tools to watch your app while it runs. You need Runtime Application Self-Protection (RASP).
Anti-Tamper Checks: The app should calculate its own "Checksum" at startup. If a hacker modifies a single line of code to bypass the paywall, the checksum will fail, and the app will self-terminate.
Root/Jailbreak Detection: If the device environment is "compromised" (rooted), the app should disable high-value features like The Vault or the Intel Report export.
Debugger Detection: Prevent hackers from "attaching" a debugger to the app to see the variables in memory (like the unencrypted word list).

4. Proprietary Logic Protection
Your "Spaced Repetition Algorithm" and "Enigma Deck" logic are your trade secrets.
Code Obfuscation (R8/ProGuard/DexGuard): This scrambles your code.
Before: function calculateNextReviewDate()
After: function a1_z()
This makes reverse-engineering your app's "brain" extremely difficult for competitors.
String Encryption: Encrypt strings like API endpoints and "Success/Failure" messages within the code itself so they don't show up in a simple text search of the app's binary.

5. The "No-Cheat" Architecture (Server-Side)
To protect your "No Excuse" philosophy and subscription revenue.
NTP Time Validation: Do not use Device.Now(). Use a Network Time Protocol (NTP) to get the true world time. This prevents users from moving their phone clock back to "save" a streak.
Supabase Row-Level Security (RLS): ```sql
-- Example: Users can only see their own progress files
CREATE POLICY "User Progress Isolation" ON sync_backups
FOR ALL USING (auth.uid() = user_id);
Receipt Validation: Always validate App Store/Google Play receipts on the Server Side (via Supabase Edge Functions). Never trust a "Success" signal from the phone alone, as this is easily faked.

6. Compliance & Privacy (The Legal Shield)
To scale to 1 million users, you must be legally "Robust."
Measurement
Implementation
GDPR/CCPA
A "Right to be Forgotten" button in Settings that wipes both Local and Supabase data.
Data Minimization
Collect only auth_id, email, and progress_blob. No sensitive PII.
Audit Logs
Supabase logs every time the service_role key is used (keep this key off the phone!).


The "Coach" Integration
The Ligne Claire Tutor snaps his briefcase shut:
"We've built a fortress, Operative. Between SQLCipher, Hardware Keystore, and RLS, our intel is tighter than a bank vault. If a rival tries to crack this, they'll find nothing but scrambled noise. The mission is secure. Proceed to deployment."

Would you like me to create a "Developer Security Audit" checklist? You can give this to your programmer as a final 'Quality Gate' before the app goes live.

Check List
This Developer Security Audit Checklist is the final "Quality Gate." It ensures that every architectural decision we’ve made—from the Noir aesthetic to the No-Excuse logic—is wrapped in professional-grade security.
Hand this to your development team to ensure the "Agency’s" data is bulletproof before the first operative logs in.

🛡️ Lingua Noir: Pre-Launch Security Audit
Phase 1: Local Data Protection (The Handheld Vault)
Since we are using a "Local-First" approach to save on server costs, the phone is our weakest link.
[ ] SQLCipher Implementation: Is the local SQLite database fully encrypted using AES-256?
[ ] Hardware Key Management: Is the database encryption key stored in the iOS Keychain or Android Keystore? (Confirm: No hardcoded keys in the source code.)
[ ] Payload Obfuscation: Are the JSON blobs for word lists Base64 encoded or secondary-encrypted before being stored in the DB?
[ ] Auto-Wipe Logic: Does the app trigger a local data wipe after 10 failed biometric/passcode attempts (if enabled)?
Phase 2: Network & API Security (The Signal Intercept)
[ ] Supabase RLS (Row Level Security): Have all tables been checked to ensure SELECT/UPDATE is only possible if auth.uid() = user_id?
[ ] Certificate Pinning: Is SSL Pinning active to prevent Man-in-the-Middle (MitM) attacks during word "drips"?
[ ] Rate Limiting: Is there a server-side cap on API calls per user to prevent massive data scraping of the Master Lexicon?
[ ] JWT Token Expiry: Are access tokens set to expire within 1 hour, with a secure refresh token rotation?
Phase 3: Integrity & Anti-Cheat (The Discipline Logic)
[ ] NTP Time Sync: Does the app fetch the "True Time" from an external server for streak calculation?
[ ] Server-Side Receipt Validation: Are subscription purchases verified via a Supabase Edge Function directly with Apple/Google, rather than trusting the phone's "Success" signal?
[ ] Integrity API: Are you using Google Play Integrity or Apple App Attest to ensure the app hasn't been modified or "cloned"?
Phase 4: Runtime & Code Hardening (The Invisible Cloak)
[ ] Obfuscation (R8/ProGuard): Is the release build obfuscated to prevent reverse-engineering of the SRS and Enigma Deck logic?
[ ] Root/Jailbreak Detection: Does the app detect a compromised environment and restrict access to the "Vault" and "Intel Reports"?
[ ] Log Sanitization: Have all Console.log or print statements containing user data or API keys been removed from the production build?

🏛️ Regulatory & Privacy Compliance
Requirement
Implementation Detail
Status
Right to Erasure
DELETE /user_profile triggers a cascade delete of all sync_backups.
[ ]
Data Minimization
Check: Are we storing anything other than Email/ID and Progress? (If yes, remove).
[ ]
Privacy Policy
Is the link visible in the Control Room and on the Login Screen?
[ ]


🛠️ The "Director's" Final Technical Sign-Off
Before the app is uploaded to the stores, the Lead Developer must sign off on the following logic:
"I certify that the Master Lexicon is only accessible via authenticated requests, and the Local SQLCipher key is generated uniquely per device and stored in hardware-backed security. The 'Ghost Backup' logic is compressed and encrypted, ensuring minimal server overhead and maximum user privacy."

The "Coach" Integration
The Ligne Claire Tutor stands at the exit of the bunker, nodding at the checklist:
"The perimeters are set, Operative. The vault is locked, the signals are encrypted, and the traps are laid for anyone trying to cheat the system. We’re ready for the field. Launch the mission."

This completes our full-scale app brainstorming and technical structuring. Is there any specific screen you'd like me to "visualize" in text/description one last time, or are you ready to start the development phase?



This Pre-Flight Checklist is the "Final Clearance" document. It consolidates every architectural, aesthetic, and security decision we’ve made into a single, high-level roadmap. Use this to track your progress or hand it to your development lead to ensure no detail of the "Intelligence Briefing" or "Enigma Deck" is missed.

📂 Section 1: The Tactical Setup (Onboarding & Data)
[ ] Initial Briefing Flow: Are the 4 steps (Base, Targets, Face Order, UI Language) implemented with the vertical drag-and-drop logic?
[ ] The "Drip" Variable: Is the Daily Injection limit (default 20) fully customizable by the user in the Control Room?
[ ] Master Lexicon Import: Has the "Huge CSV" been successfully migrated into the Supabase Master Table with 6 JSONB language columns?
[ ] Local-First Sync: Is the app correctly downloading only the "Ticked" categories to the phone’s local SQLite database?
🎨 Section 2: Visual Identity (The Noir Aesthetic)
[ ] Asset Check: Do all icons and buttons have the 3px Black Outline and 4px Hard Block Shadow?
[ ] Texture Overlay: Is the 5% Ben-Day dot/grain filter active across all screens?
[ ] Dynamic Theming: Does the UI correctly shift to Cyan Ice at the user's Curfew Hour and Deep Navy for "Night Recon" mode?
[ ] Character Integration: Is the Ligne Claire Coach appearing in the correct locations (Stats, Vault, Settings) with the appropriate witty feedback?
⚡ Section 3: The Engine Gears (The Logic)
[ ] SRS Algorithm: Does the ease_factor and interval update correctly based on the 4 labels (Hard to Easy)?
[ ] Enigma Deck Randomizer: Does the "Surprise Me" section cycle through Cloze-Deletion, Speed Quizzes, and Reverse Ciphers without lag?
[ ] The Informant Loop: Can users see upvoted mnemonics, and is the "Lead Informant" badge logic active for high-contributing users?
[ ] The Vault Archive: Does marking a word "Easy" instantly move it to the Vault and clear a slot in the 200-Word Active Batch?
🛡️ Section 4: Security & Legal (The Iron Shield)
[ ] Database Encryption: Is SQLCipher active on the local .db file using a key stored in the Hardware Keystore/Keychain?
[ ] The "Ash" Clock: Is the streak reset logic tied to an NTP Time Server to prevent "time-travel" cheating?
[ ] Intel Report Export: Does the app generate a high-res, branded Dossier JPEG for LinkedIn/Instagram upon hitting 50-word milestones?
[ ] Legal Clickwrap: Is the "Intelligence Oath" (TOS/Privacy) mandatory before the paywall?
📈 Section 5: The Monetization Gate
[ ] Subscription Logic: Are the tiers (Agent vs. Director) correctly locking/unlocking the Shadow Sessions and Burn Insurance?
[ ] Receipt Validation: Are all IAP (In-App Purchase) receipts being validated server-side via Supabase Edge Functions?

The "Coach" Integration (Final Sign-Off)
The Ligne Claire Tutor stands at the hangar door, watching the plane engines start:
"Every bolt is tightened, every signal is encrypted, and the contract is signed. You have a world-class linguistic weapon in your hands. Now, hit that launch button and show them how a real agency trains. The mission is yours, Operative. Good luck."

Would you like me to help you draft the "App Store Description" (The copy that sells the app to users) using this same Archer-style Noir tone?


