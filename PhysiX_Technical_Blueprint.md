# PhysiX in Motion — Technical Blueprint
### Offline Gamified Mobile Physics Application for Grade 11 STEM
### Companion Engineering Spec to the Thesis Manuscript & 5E Lesson Plan (Motion in One Dimension)

**Prepared for:** Bation & Acob — *Developing and Evaluating PhysiX in Motion: A Gamified Mobile Application for Grade 11 STEM Physics*
**Purpose of this document:** a build-ready spec another model (or a human dev team) can implement directly from — architecture, UI/UX, phased plan, DB schema, risks, and step-by-step implementation instructions.

---

## 0. Grounding Assumptions (stated explicitly — flag if wrong)

The manuscript and lesson plan constrain the design more than a blank-slate app would. These are load-bearing:

| Constraint (from your docs) | Design consequence |
|---|---|
| "PhysiX in Motion is designed to function on smartphones and tablets running Android **and** iOS," fully offline | Cross-platform framework, **zero backend dependency** for core learning loop |
| No internet at all, even LAN-optional per Scope §1.4/§3.1 | All content, physics engine, and scoring must run **on-device**; no server round-trips |
| Two user types (teacher, student) implied by "teacher's guide," "monitor individual performance markers... locally," badges | Single codebase, **role-based mode**, not two separate apps |
| 5E lesson plan already names concrete app modules: **Trip Tracker, Motion Lab, Graph Visualizer, Mission Mode ("Commute Challenge"), Evaluation Terminal, achievement badges** | These are not optional nice-to-haves — they are the MVP feature list, verbatim |
| Validation via Panel of Validators + pilot testing with pre/post-test, Cronbach's Alpha, Hake Gain (§3.6–3.8) | The app must **locally log** every interaction needed for those statistics (attempts, timestamps, scores, item-level responses) so the data can be exported for the researchers' analysis |
| Students are minors; RA 10173 (Philippine Data Privacy Act) applies | No cloud sync of student data by default; export is explicit, teacher-initiated, and anonymizable |
| Inclusivity / UDL emphasis, low-bandwidth/low-spec devices (§1.1, §1.4) | UI must tolerate small screens, limited storage, older Android versions; avoid heavy 3D/particle-heavy engines |

**Recommended stack (assumption — swap if you have a preference):**
- **Flutter** (Dart) — one codebase for Android + iOS, small binary footprint compared to React Native + native modules, strong offline story, good for custom physics-graph rendering via `CustomPainter`/`fl_chart`.
- **SQLite via `drift`** (typed, offline, migration-friendly) as the single local data store — no backend at all for v1.
- **Riverpod** or **Bloc** for state management (either is fine; Riverpod is lighter for a student team).
- No Firebase, no REST API in v1. This is not a cost-cutting shortcut — it is what "completely offline" requires structurally.

If a truly offline classroom-wide leaderboard/analytics view for the teacher is wanted *without* internet, see §2.3 (LAN-based sync) — this is optional, not required for MVP.

---

## 1. System Architecture

### 1.1 High-level shape

```
┌─────────────────────────────────────────────────────────────────┐
│                         PhysiX in Motion Mobile App                        │
│                     (single Flutter codebase)                    │
│                                                                    │
│  ┌───────────────┐        ┌────────────────┐                     │
│  │  Auth/Profile  │───────▶│  Role Router    │                     │
│  │  (local PIN)   │        │ Student | Teacher│                    │
│  └───────────────┘        └────────┬────────┘                     │
│                                     │                              │
│         ┌───────────────────────────┼────────────────────────┐   │
│         ▼                           ▼                        ▼   │
│  ┌─────────────┐           ┌────────────────┐        ┌────────────┐
│  │  Student     │           │   Teacher      │        │  Shared     │
│  │  Portal      │           │   Portal       │        │  Services   │
│  │              │           │                │        │             │
│  │ • Trip       │           │ • Class roster │        │ • Physics   │
│  │   Tracker    │           │ • Lesson plan  │        │   Engine    │
│  │ • Motion Lab │           │   viewer (5E)  │        │   (SUVAT)   │
│  │ • Graph      │           │ • Live         │        │ • Gamifi-   │
│  │   Visualizer │           │   progress     │        │   cation    │
│  │ • Mission    │           │   dashboard    │        │   Engine    │
│  │   Mode       │           │ • Item         │        │ • Content   │
│  │ • Evaluation │           │   analysis     │        │   Repository│
│  │   Terminal   │           │ • Export/Print │        │   (JSON     │
│  │ • Badges &   │           │   reports      │        │   lesson    │
│  │   Profile    │           │ • Content      │        │   packs)    │
│  │              │           │   editor       │        │             │
│  └──────┬──────┘           └────────┬───────┘        └──────┬──────┘
│         │                           │                        │      │
│         └───────────────┬───────────┴────────────────────────┘      │
│                          ▼                                          │
│                 ┌──────────────────┐                                │
│                 │  Local Repository │  (drift/SQLite, on-device)     │
│                 │  Layer            │                                │
│                 └────────┬─────────┘                                │
│                          ▼                                          │
│                 ┌──────────────────┐                                │
│                 │  Device storage   │                                │
│                 └──────────────────┘                                │
└─────────────────────────────────────────────────────────────────┘
                          │
                          ▼ (optional, not required for MVP)
              ┌─────────────────────────────┐
              │  Local export/import layer    │
              │  (CSV/JSON file, QR code, or  │
              │  device-to-device LAN sync)    │
              └─────────────────────────────┘
```

### 1.2 Layered architecture (clean-architecture style, per module)

```
presentation/   → Widgets, screens, view-state (per feature: trip_tracker/, motion_lab/, mission_mode/, evaluation/, teacher_dashboard/)
domain/         → Entities (Trial, Attempt, Badge, Student, ClassSection), use-cases (ComputeKinematics, ScoreQuiz, AwardBadge)
data/           → Repositories, DAOs (drift), local content loader (bundled JSON lesson packs)
core/           → Physics engine (pure Dart, unit-testable, no Flutter deps), gamification rules engine, constants
```

Keep the **physics engine and scoring engine as pure Dart packages with zero Flutter imports** — this lets another model/dev unit-test kinematics formulas and quiz scoring independent of UI, and reuse them later for other topics (forces, energy — per the manuscript's stated future scope).

### 1.3 "Completely offline" but still multi-user: how the teacher sees data

Three tiers, cheapest-first — implement Tier 1 for MVP, treat 2–3 as stretch:

1. **Tier 1 — Per-device, export/import file.** Each student's phone is authoritative for their own data. Teacher's phone has a "Import Class Results" screen: student taps "Share My Results" → generates a signed local JSON/CSV → shared via Nearby Share / Bluetooth / SD-card copy / QR code (small payloads only) → teacher imports. No network stack needed at all. **This satisfies "completely offline" literally and is what should ship first.**
2. **Tier 2 — Local Wi-Fi Direct/Hotspot session (no internet, LAN only).** Teacher device runs a lightweight embedded HTTP server (e.g., `shelf` package) on a phone-created hotspot; student devices join the same hotspot and POST results in real time during "Mission Mode" for a live leaderboard. Zero internet, but does require devices to be in physical proximity and a hotspot toggle. Good demo feature for the defense, not required for pilot validity.
3. **Tier 3 — Bluetooth mesh sync** for classrooms without Wi-Fi radios enabled — highest complexity, lowest ROI; skip unless a validator specifically asks for it.

### 1.4 Content model: how lesson data ships

Physics content (kinematics formulas, quiz items, scenario text, Iligan-City commute scenarios) should **not** be hardcoded in Dart. Ship it as versioned JSON "lesson packs" bundled in `assets/content/kinematics_v1.json`, loaded into SQLite on first launch. This is what makes the 5E-lesson-plan parallel actually maintainable: a teacher/researcher edits content without touching code, and it's how you'll add "forces" or "energy transfer" modules later without an app rewrite.

---

## 2. Mapping the App 1:1 to the 5E Lesson Plan

This is the single most important design constraint — the app *is* the lesson plan's technology, not a generic simulator bolted on afterward.

| 5E Stage | Lesson Plan Activity | App Module | Core Interaction | Data Logged |
|---|---|---|---|---|
| **Engage** (10 min) | Habal-habal vs. jeepney puzzle, intro animation | **Trip Tracker** | Watch 2 vehicle icons race on a route; tap "Predict Outcome" to record a hypothesis (distance vs. displacement) before instruction | `prediction_log` (pre-instruction guess, timestamp) |
| **Explore** (15 min) | "Walk the Line" measurement activity (8–10m, tape measure, stopwatch) | **Motion Lab (sandbox)** | Manual data-entry form: distance, displacement, time per trial; app auto-computes speed/velocity and renders a live displacement-time graph | `motion_trials` table |
| **Explain** (15 min) | Teacher-led derivation of 4 kinematic equations; class discusses slope/area | **Graph Visualizer** | Renders each group's own trial data as d-t and v-t graphs; tappable slope/area overlays; step-by-step equation derivation viewer | reads from `motion_trials`; no new writes (read-only teaching aid) |
| **Elaborate** (10 min) | Localized commute word problems ("catch the last boat," "stop before the hump") | **Mission Mode — "Commute Challenge"** (Level 1: avg. velocity; Level 2: acceleration/deceleration) | Gamified problem screens; student computes manually then inputs answer; app's physics engine verifies against tolerance | `mission_attempts`, points, streaks |
| **Evaluate** (10 min) | 10-item quiz, instant feedback, walkthroughs | **Evaluation Terminal** | Timed 10-item MC quiz pulling from the bundled item bank (the exact items in Appendix/lesson plan can seed it); auto-scored offline; per-item explanation shown on miss | `quiz_attempts`, `quiz_item_responses`; feeds Hake Gain / pre-post analysis |
| *(cross-cutting)* | Badges "to verify mastery of the day's competencies" | **Badges & Profile** | Rule engine awards badges on thresholds (e.g., "Vector Voyager": ≥80% on displacement items; "Motion Master": completes both Mission Mode levels) | `badges_earned` |

**Reusability note for future topics:** the manuscript states the app will eventually cover motion, forces, and energy transfer. Design each of Trip Tracker / Motion Lab / Mission Mode / Evaluation Terminal as a **topic-agnostic shell** driven by the JSON content pack, so "Rotational Kinematics" or "Forces" is a new content pack, not new screens.

---

## 3. UI/UX Design

### 3.1 Principles (derived directly from your Chapter I framing)

1. **Cognitive-load-first, not decoration-first.** The manuscript explicitly blames "text-heavy, poorly structured interfaces" for overload before students reach the physics. → One primary action per screen, generous whitespace, icon + short label (never icon-only), max ~2 new concepts per screen.
2. **UDL-aligned.** Font scaling respecting system accessibility settings, minimum touch target 48dp, color is never the *only* signal (pair color with icon/pattern for correct/incorrect feedback — colorblind-safe), full VoiceOver/TalkBack labels, adjustable pacing (no forced timers in Explore/Explain modules; only Mission Mode/Evaluation are timed, and even then allow an "extended time" toggle for the teacher to enable).
3. **Protective competition, not public shaming** (directly citing Malayao et al., 2026; Tolentino, 2025 in your own lit review). → **No cross-student public leaderboard visible to students by default.** Points/streaks are private to the student; the *teacher* portal can see an aggregate/anonymized class view; an opt-in "Class Leaderboard" can be toggled on by the teacher only, and should default to first-name-initial or avatar rather than full name + rank-shaming.
4. **Local-context visuals.** Habal-habal, jeepney, tricycle, and Iligan City barangay/port references from the lesson plan should appear as actual sprite/vehicle art and route names — this is what makes it "PhysiX in Motion for Iligan" rather than a generic PhET clone, and it's explicitly the pedagogical hook in the Engage stage.
5. **Low-spec tolerance.** No heavy particle effects; animations capped and skippable; app size budget (assets, not code) under ~150MB so it fits on storage-constrained devices mentioned in your Limitations section.
6. **Dark mode, following system setting by default.** Both portals ship a dark theme alongside light, with a per-user toggle in Settings defaulting to "match device setting" rather than forcing one. This isn't just cosmetic — a classroom with harsh overhead lighting and a student using the app at home in the evening are genuinely different contexts, and forcing one theme fights the device's own accessibility settings for some users. Every themed color needs a dark-surface counterpart — see §3.1a below for the full token table (navy/cyan/orange, matching the approved app icon).

### 3.1a Color system (light/dark) — navy/cyan/orange, matching the approved icon

| Token | Light | Dark | Notes |
|---|---|---|---|
| Primary accent (cyan) | `#0E9AAE` (deepened for light-surface contrast) | `#22D3EE` (full brightness, matches icon) | Primary buttons, active nav state, prediction-selected border |
| Surface / card background | `#FFFFFF` / `#EAF7FA` (tinted card) | `#12162D` / `#1E204A` (tinted card, matches icon's navy) | Never pure black — icon's navy (`#12162D`) is the dark-mode base, not `#000000` |
| Text primary | near-black | near-white | Standard inversion; re-run contrast checks per Step 7, don't assume inversion preserves ratio |
| Secondary accent (orange) | `#E8862E` (deepened for light-surface contrast) | `#FF9F43` (matches icon's endpoint-dot orange) | Correct-answer states, badge highlights, the "final value" marker pattern used in the icon itself — reuse this visual idea (a small orange dot marking a key data point) in Graph Visualizer and Mission Mode feedback for consistency |
| Reasoning chips | `#E8F6F8` bg / `#0E4C57` text (light) | dark-surface equivalent, same hue family | Shifted from the earlier purple to a cyan-family tint for palette consistency |

**What this changes:** every hex value in every mockup screen described in §3.3 (Trip Tracker's teal accents, the badge colors, button fills) should be read as this table's cyan/orange, not the retired teal/mint/coral. **What this doesn't change:** the actual layout, copy, and interaction design of every screen — cognitive-load principles, the reasoning-chip pattern, the badge unlock logic — none of that was palette-dependent, so nothing structural moves. Local-context visuals (habal-habal/jeepney art, route illustrations) should be recolored to sit naturally against navy/cyan rather than the earlier mint-green route-map treatment.

**Implementation note for the coding model:** define these as a single `AppColors` abstraction with light/dark variants (Flutter's `ColorScheme`/`ThemeData.dark()` pattern), never hardcode a hex value directly in a widget — every color reference should resolve through the theme so switching modes doesn't require touching screen code.

### 3.2 Information architecture

**Shared entry screen:** role toggle (Student / Teacher) → local PIN/passcode (no email, no internet auth) → role-specific home.

**Settings — reachable from both portals** (icon in the top-right of the header, not a bottom-nav tab, since it's cross-cutting rather than part of the 5E flow):
- **Appearance:** three-way choice — **Light / Dark / Match device setting** (default: Match device setting). Switching applies immediately, no restart.
- **Simple graphics** toggle (Risk #2 fix) — disables chart animation, caps rendered trial history at 10 points
- **Extended time for timed activities** (teacher-side only — UDL accommodation from §3.1 principle 2)
- **Class Leaderboard visibility** (teacher-side only, default off — §3.1 principle 3 / Risk #6 fix)
- Student side additionally shows: last export/backup timestamp, app version, offline storage used

**Student Portal — bottom nav (5 tabs, mirrors the 5E flow left→right):**
`Home (Trip Tracker) · Motion Lab · Mission Mode · Evaluation · Profile & Badges`

**Teacher Portal — bottom nav (4 tabs):**
`Dashboard · Class Roster · Lesson Plan (5E viewer) · Reports/Export`

### 3.3 Key screens (wireframe-level spec, enough for another model to build from)

**Student — Trip Tracker (Engage)**
- Header: lesson title + progress dot indicator (5E stage tracker: E-E-E-E-E pips, current stage highlighted)
- Center: animation/illustration of habal-habal vs. jeepney on a route (static sprite sequence acceptable for MVP — full animation is a stretch goal)
- CTA button: "Predict the Winner" → 2-option choice (habal-habal / jeepney) + short free-text or single-select "why" (scaffolded options: "it covers more distance," "it's faster," "it changes direction less")
- Footer: "Continue to Motion Lab" (unlocks after prediction submitted)

**Student — Motion Lab (Explore, sandbox)**
- Form: 3 numeric inputs per trial (distance walked, displacement, time), "+ Add Trial" for repeated trials (mirrors "Walk the Line" walking there/back)
- Auto-computed read-only fields appear on entry: speed, velocity (signed, with direction label)
- Live chart panel below (displacement vs. time), redraws per trial added
- "Send to Graph Visualizer" button

**Student — Graph Visualizer (Explain)**
- Toggle: displacement-time / velocity-time
- Tap-and-drag on any two points → shows computed slope with unit, labeled "this is velocity" / "this is acceleration"
- Shaded-area tool under v-t curve → labeled "this is displacement"
- Side panel: the 4 kinematic equations, each with a "Show derivation" expandable stepper (matches teacher's guided algebra in the lesson plan)

**Student — Mission Mode (Elaborate)**
- Level select card (Level 1: "Catch the Last Trip" — avg. velocity; Level 2: "Stop at the Hump" — deceleration)
- Problem screen: localized scenario text + given values + numeric-entry answer field + calculator/scratchpad toggle
- On submit: engine checks against tolerance (± rounding allowance), shows instant correct/incorrect + short explanation, awards points/streak
- Discrepancy prompt if wrong: "Compare with your manual computation — where did it diverge?" (matches lesson plan's explicit discussion step)

**Student — Evaluation Terminal (Evaluate)**
- 10-item MC quiz, one item per screen, progress bar, optional soft timer
- Immediate per-item feedback + short explanation on submit (per lesson plan: "Provide instant feedback... solution walkthrough")
- Summary screen: score, badges unlocked, "Review Missed Items"

**Student — Profile & Badges**
- Avatar, XP bar, earned badges grid, "Share My Results" (Tier-1 export button, §1.3)
- Settings icon in header → opens Settings screen (see §3.2)

**Shared — Settings** (student and teacher variants share one screen shell, teacher sees additional rows)
- **Appearance** section: segmented control — Light / Dark / Match device — applies instantly, previewable without leaving the screen
- **Accessibility** section: Simple graphics toggle; (teacher view only) Extended time toggle
- (Teacher view only) **Class options** section: Class Leaderboard visibility toggle, defaulted off, with a one-line explanation of what turning it on does before the teacher confirms
- **About** section: app version, last backup/export timestamp (student), offline storage used

**Teacher — Dashboard**
- Class-wide summary cards: avg. pre/post score delta, % completed each 5E stage, most-missed quiz item (auto-flagged for re-teaching)
- Per-student row list, tap for individual detail (their trial data, mission attempts, quiz responses)
- "Import Student Results" (Tier-1 sync entry point)

**Teacher — Lesson Plan viewer**
- Renders the 5E lesson plan (Engage/Explore/Explain/Elaborate/Evaluate) read-only, with inline "Open in app" deep-links to jump straight to the matching student module for live demo during class — this is the literal "parallel" between lesson plan and app the brief asks for.

**Teacher — Reports/Export**
- Export CSV/JSON of raw item-level responses (for the Table of Specifications-aligned pre/post analysis, Cronbach's Alpha, Hake Gain — this is a research necessity, not a nice-to-have) and a printable PDF summary.

---

## 4. Development Phases

Two tracks run in parallel: the **research track** (already defined by your SAM/mixed-methods design in Ch. III) and the **engineering track** this document adds underneath it. Engineering phases are timed to hand off deliverables exactly when the research phases need them.

| Research Phase (yours, Ch. III) | Engineering Phase (this doc) | Engineering Deliverable | Est. Duration |
|---|---|---|---|
| Phase 1: Needs Assessment — *already complete* | **Eng-0: Setup** | Repo scaffold, CI, drift schema v1, design tokens/theme, content-pack JSON schema defined | 1 week |
| Phase 2: Designing the App | **Eng-1: UX & Content Authoring** | Wireframes/hi-fi mocks for all screens in §3.3; kinematics content pack (JSON) authored from the lesson plan and 10-item quiz bank | 2 weeks |
| Phase 3: Development | **Eng-2: Core Engine** | Pure-Dart physics engine (SUVAT solver, unit conversion, tolerance-based answer checker) + gamification rules engine, fully unit-tested | 2 weeks |
| Phase 3 (cont.) | **Eng-3: Student Portal MVP** | Trip Tracker → Motion Lab → Graph Visualizer → Mission Mode → Evaluation Terminal → Badges, wired to local DB | 4 weeks |
| Phase 3 (cont.) | **Eng-4: Teacher Portal MVP** | Dashboard, roster, lesson-plan viewer, Tier-1 export/import | 2 weeks |
| Phase 4: Validation | **Eng-5: Validator & Pilot Build** | Signed Android APK (direct install) **and** iOS TestFlight build, both distributed to validators/pilot participants; validator checklist mapped to Appendix H instrument; bug triage. See §7 Step 9 for the full dual-platform distribution procedure. | 1 week (+ Apple Developer enrollment lead time if not already done) |
| Phase 5: Refinement | **Eng-6: Iteration** | Fix content-accuracy, usability, inclusivity issues flagged by validators | 1–2 weeks |
| Phase 6: Pilot Testing | **Eng-7: Pilot Hardening** | Crash reporting (local log file, not cloud), performance profiling on low-spec test device, offline data-integrity tests | 1 week |
| Phase 7: Perceptions/Evaluation | **Eng-8: Data Export for Analysis** | Verified CSV/JSON export matches the pre/post-test + item-response format your stats plan (paired t-test, Hake Gain) needs | ongoing support |

**Total engineering estimate: ~14–16 weeks** for a 2-person student dev team building the kinematics module end-to-end at production-pilot quality. If this is being built solo, expect closer to 20–24 weeks — budget accordingly against your thesis timeline.

---

## 5. Database Schema (local SQLite, single device, per install)

Design notes:
- Every student device and every teacher device runs the **same schema**; `users.role` distinguishes them.
- No `password_hash` server round-trip — local PIN, hashed with a simple salted hash (e.g., `bcrypt` via a pure-Dart port, or even just SHA-256 + salt since this is not internet-facing — the threat model is "sibling picks up phone," not remote attack).
- All timestamps are stored as `INTEGER` (Unix epoch ms) for offline-safe ordering without timezone drift.
- `content_version` fields let you ship a new lesson pack (e.g., "forces_v1.json") later without breaking old attempt records.

```sql
-- ============ IDENTITY ============

CREATE TABLE users (
    user_id         TEXT PRIMARY KEY,          -- UUID
    role            TEXT NOT NULL CHECK (role IN ('student','teacher')),
    display_name    TEXT NOT NULL,
    pin_hash        TEXT NOT NULL,
    avatar_id       TEXT,
    grade_level     TEXT,                      -- e.g. 'Grade 11'
    strand          TEXT,                      -- e.g. 'STEM'
    section_id      TEXT REFERENCES class_sections(section_id),
    created_at      INTEGER NOT NULL,
    last_login_at   INTEGER
);

CREATE TABLE class_sections (
    section_id      TEXT PRIMARY KEY,
    teacher_id      TEXT REFERENCES users(user_id),
    section_name    TEXT NOT NULL,             -- e.g. 'STEM 11-A'
    school_name     TEXT,
    created_at      INTEGER NOT NULL
);

-- ============ CONTENT (bundled, versioned, mostly read-only) ============

CREATE TABLE content_packs (
    pack_id         TEXT PRIMARY KEY,          -- e.g. 'kinematics_v1'
    topic_name      TEXT NOT NULL,             -- 'Motion in One Dimension'
    version         TEXT NOT NULL,
    melc_codes      TEXT,                      -- DepEd competency codes, comma-separated
    imported_at     INTEGER NOT NULL
);

CREATE TABLE lesson_stages (
    stage_id        TEXT PRIMARY KEY,          -- e.g. 'kinematics_v1_engage'
    pack_id         TEXT REFERENCES content_packs(pack_id),
    stage_name      TEXT NOT NULL CHECK (stage_name IN
                     ('engage','explore','explain','elaborate','evaluate')),
    module_key      TEXT NOT NULL,             -- 'trip_tracker','motion_lab', etc.
    sequence_order   INTEGER NOT NULL,
    display_title   TEXT NOT NULL,
    body_json       TEXT NOT NULL              -- scenario text, prompts, media refs
);

CREATE TABLE quiz_items (
    item_id         TEXT PRIMARY KEY,
    pack_id         TEXT REFERENCES content_packs(pack_id),
    stage_id        TEXT REFERENCES lesson_stages(stage_id),
    item_type       TEXT NOT NULL CHECK (item_type IN ('mcq','numeric')),
    prompt          TEXT NOT NULL,
    choices_json    TEXT,                      -- for MCQ: [{"key":"A","text":"..."}]
    correct_answer  TEXT NOT NULL,              -- key or numeric value
    tolerance       REAL,                       -- for numeric items, e.g. ±0.5
    explanation     TEXT,
    tos_competency  TEXT,                       -- maps to Table of Specifications row
    difficulty      TEXT CHECK (difficulty IN ('easy','average','difficult'))
);

CREATE TABLE mission_levels (
    level_id        TEXT PRIMARY KEY,
    pack_id         TEXT REFERENCES content_packs(pack_id),
    level_number    INTEGER NOT NULL,
    title           TEXT NOT NULL,             -- 'Catch the Last Trip'
    scenario_text   TEXT NOT NULL,
    given_values    TEXT NOT NULL,              -- JSON: {"v0":0,"a":2,"t":5}
    target_variable TEXT NOT NULL,              -- e.g. 'v'
    correct_answer  REAL NOT NULL,
    tolerance       REAL NOT NULL DEFAULT 0.1
);

-- ============ STUDENT ACTIVITY / EVIDENCE ============

CREATE TABLE prediction_log (               -- Engage: Trip Tracker
    log_id          TEXT PRIMARY KEY,
    user_id         TEXT REFERENCES users(user_id),
    stage_id        TEXT REFERENCES lesson_stages(stage_id),
    predicted_option TEXT NOT NULL,
    reasoning_key   TEXT,
    submitted_at    INTEGER NOT NULL
);

CREATE TABLE motion_trials (                -- Explore: Motion Lab
    trial_id        TEXT PRIMARY KEY,
    user_id         TEXT REFERENCES users(user_id),
    group_id        TEXT,                      -- optional, if run as small-group activity
    trial_number    INTEGER NOT NULL,
    distance_m      REAL NOT NULL,
    displacement_m  REAL NOT NULL,
    time_s          REAL NOT NULL,
    computed_speed  REAL,                       -- derived, cached
    computed_velocity REAL,                     -- derived, cached, signed
    recorded_at     INTEGER NOT NULL
);

CREATE TABLE mission_attempts (             -- Elaborate: Mission Mode
    attempt_id      TEXT PRIMARY KEY,
    user_id         TEXT REFERENCES users(user_id),
    level_id        TEXT REFERENCES mission_levels(level_id),
    submitted_answer REAL NOT NULL,
    is_correct      INTEGER NOT NULL,           -- 0/1
    attempt_number  INTEGER NOT NULL,           -- retries allowed
    points_awarded  INTEGER DEFAULT 0,
    submitted_at    INTEGER NOT NULL
);

CREATE TABLE quiz_attempts (                -- Evaluate: Evaluation Terminal (session header)
    attempt_id      TEXT PRIMARY KEY,
    user_id         TEXT REFERENCES users(user_id),
    pack_id         TEXT REFERENCES content_packs(pack_id),
    attempt_type    TEXT CHECK (attempt_type IN ('pretest','posttest','formative')),
    started_at      INTEGER NOT NULL,
    completed_at    INTEGER,
    total_score     REAL,
    max_score       REAL
);

CREATE TABLE quiz_item_responses (          -- item-level detail (needed for TOS / item analysis)
    response_id     TEXT PRIMARY KEY,
    attempt_id      TEXT REFERENCES quiz_attempts(attempt_id),
    item_id         TEXT REFERENCES quiz_items(item_id),
    given_answer    TEXT NOT NULL,
    is_correct      INTEGER NOT NULL,
    time_spent_ms   INTEGER,
    answered_at     INTEGER NOT NULL
);

-- ============ GAMIFICATION ============

CREATE TABLE badges (
    badge_id        TEXT PRIMARY KEY,
    badge_name      TEXT NOT NULL,             -- 'Vector Voyager'
    description     TEXT NOT NULL,
    icon_asset      TEXT NOT NULL,
    unlock_rule_json TEXT NOT NULL             -- {"type":"quiz_score_gte","value":0.8,"stage":"evaluate"}
);

CREATE TABLE badges_earned (
    user_id         TEXT REFERENCES users(user_id),
    badge_id        TEXT REFERENCES badges(badge_id),
    earned_at       INTEGER NOT NULL,
    PRIMARY KEY (user_id, badge_id)
);

CREATE TABLE points_ledger (
    entry_id        TEXT PRIMARY KEY,
    user_id         TEXT REFERENCES users(user_id),
    source_type     TEXT NOT NULL,              -- 'mission_attempt','quiz_attempt','streak_bonus'
    source_id       TEXT,
    points          INTEGER NOT NULL,
    created_at      INTEGER NOT NULL
);

-- ============ SYNC / EXPORT (Tier 1, §1.3) ============

CREATE TABLE export_bundles (
    bundle_id       TEXT PRIMARY KEY,
    user_id         TEXT REFERENCES users(user_id),
    generated_at    INTEGER NOT NULL,
    payload_json    TEXT NOT NULL,              -- snapshot of the tables above for this user
    imported_by_teacher_id TEXT,
    imported_at     INTEGER
);

-- ============ APP/DEVICE SETTINGS ============

CREATE TABLE app_settings (
    key             TEXT PRIMARY KEY,
    value           TEXT NOT NULL
);
```

**Indexing notes for the implementing model:** add indexes on `motion_trials(user_id)`, `quiz_item_responses(attempt_id)`, `mission_attempts(user_id, level_id)` — these are the hot paths for the teacher dashboard's per-student rollups.

---

## 6. Risk Register

**Content architecture decision (final): JSON content pack**, not hardcoded Dart constants (see §7 Step 2). This is reflected below — each risk now has a concrete, buildable **Fix** (a specific artifact or step, not just a principle), plus a **Status** showing whether the fix is a design decision already locked in this document or an action still owed during build. Risk #12 is new — it's the direct trade-off cost of choosing JSON over hardcoding, and needs its own concrete fix rather than being absorbed into #3/#11.

| # | Risk | Category | Likelihood | Impact | Fix | Status |
|---|---|---|---|---|---|---|
| 1 | Local-only data means a lost/wiped/factory-reset student phone = permanent loss of that student's pre-test, trial, and quiz data before it's exported | Technical / Research validity | Medium | High | **Auto-backup, not just prompted export**: on completion of every stage (not only Evaluate), silently write a timestamped snapshot to a local backup file in app-private storage, independent of the student remembering to tap "Share." Tier-1 share becomes "send the existing backup," not "generate one from memory." Add a banner if a completed session hasn't been shared to a teacher within 24 hours. | Design locked — add as Step 5.6 in §7 |
| 2 | Device fragmentation — old Android (low API level) or budget devices choke on chart rendering | Technical | Medium | Medium | Hard floor: Android 8 / API 26, iOS 13 (already in Step 1). Add a **"Simple graphics" toggle** in Settings that disables chart animation and caps rendered trial history at 10 points — user-controlled degradation instead of hoping performance is fine everywhere. | Design locked — add toggle to Step 5 (Motion Lab/Graph Visualizer) and Step 8 |
| 3 | Physics engine bugs silently mis-score Mission Mode/Evaluation, corrupting pre/post-test data your stats depend on | Technical / Research validity | Low-Medium | High | Golden-file unit test suite: every one of the 10 quiz items and both mission levels in `kinematics_v1.json` gets a corresponding unit test asserting the engine's computed answer matches `correct_answer` within `tolerance`, run in CI on every commit. A content or engine change that breaks a golden test **fails the build**, not just a code review. | Design locked — CI gate added to Step 3 |
| 4 | Tolerance thresholds for numeric answers (Mission Mode) too strict/loose, unfairly marking correct reasoning wrong or vice versa | Pedagogical | Medium | Medium | Tolerance is already a JSON field (`mission_levels.tolerance`, `quiz_items.tolerance`), not a code constant — validators can request a specific number change and it ships without a rebuild. Add one explicit line item to the validator checklist (Step 9): "confirm each tolerance value with the subject-matter validator by name." | Design locked (enabled directly by the JSON decision) |
| 5 | Teachers (majority not physics-trained, per your own Ch. I citation of Beley, 2025) struggle to operate the teacher portal or interpret the dashboard | Adoption | High | High | In-app first-run guided tour for the Teacher Portal (3–4 tooltip steps max); dashboard hard-capped at 4 top-line metrics (§3.3); Teacher's Guide content lives as in-app contextual help text, not a separate PDF. | Design locked — add "first-run tour" as explicit deliverable in Step 6 |
| 6 | Gamification (points/leaderboard) triggers exactly the performance anxiety your own literature review warns about (Tolentino, 2025; Malayao et al., 2026) | Pedagogical / Ethical | Medium | High | `app_settings.leaderboard_visible` defaults to `false` at the schema level (§5) — teacher must actively opt in per class; no code path renders a public rank unless this flag is explicitly set. Badge copy ("Vector Voyager," "Motion Master") reviewed by validators for mastery-framing, not rank-framing. | Design locked — default value specified in §5 schema |
| 7 | Minor's data privacy — even local export could be mishandled (e.g., emailed insecurely, shared publicly) | Legal / Ethical (RA 10173) | Low-Medium | High | Export bundles use `student_id`, not full name, unless the teacher explicitly toggles "include names" per export. Add a manifest/permissions audit as a checklist item in Step 10: confirm the shipped app requests **zero** network, analytics, or tracking permissions — provable, not just claimed, since the whole point of "offline" is that there's nothing to audit for leakage. | Design locked — audit step added to Step 10 |
| 8 | Scope creep: manuscript's Scope §1.4 says "limited to one specific physics topic" but stakeholders may push for forces/energy mid-build | Project | Medium | Medium | Content-pack JSON architecture already isolates this — a new topic is a new `content_pack_id` and JSON file, not new screens or a schema change. Formal rule for the build: no second content pack is authored or bundled until `kinematics_v1` passes Step 9 (validator build). | Design locked |
| 9 | Validation/Pilot timeline slippage cascades into thesis defense timeline | Project | Medium | High | Phase table (§4) already sequences Eng-5 (validator build) ahead of the research plan's Phase 4 need date, with buffer inside Eng-3/Eng-4. Explicit fallback if slippage still happens: cut Tier 2/3 sync (§1.3) first — they're the only features with zero dependency from any other module. | Design locked |
| 10 | Cross-platform inconsistency: iOS vs Android rendering/permission differences (storage access for export, Bluetooth/Wi-Fi Direct APIs for Tier 2/3 sync) | Technical | Medium | Medium | Tier 1 (file export via `share_plus`) ships first since it's platform-agnostic. Tier 2 LAN sync, if attempted at all, is explicitly scoped Android-first with iOS as stretch, so a platform-specific blocker there never blocks the MVP. | Design locked |
| 11 | Content-accuracy risk: an engine or quiz-key error is caught late by validators, requiring rework across Motion Lab, Mission Mode, and Evaluation simultaneously (they share the engine) | Technical / Pedagogical | Low | High | Two layers now, not one: (a) the centralized pure-Dart engine (§1.2) means a fix propagates everywhere at once; (b) because content is JSON, validators can review the **actual shipping content file directly** — human-readable, no code literacy needed — before Step 9's build, catching key errors earlier than a code review ever would. | Design locked |
| 12 | **(New — direct cost of the JSON decision)** A malformed or manually-edited content pack (bad JSON, a `correct_answer` key that doesn't exist in `choices_json`, a `stage_id` reference that doesn't resolve) fails silently at runtime instead of at compile time, since JSON has no compiler | Technical | Medium | High | **Startup content-integrity check**, not optional: `ContentImporter` runs a validation pass before writing anything to the DB — asserts `quiz_items.length == 10`, every `correct_answer` exists in that item's `choices_json`, every `mission_levels.target_variable` is one of the five kinematic variables, every `stage_id` reference resolves. On failure: refuse to seed, surface a specific error (which field, which item), never a silent partial import. Add the same check as a pre-commit/CI script so a bad JSON edit is caught before it's even bundled into a build, not just at first launch. | **New fix — add as Step 2.3 in §7, not yet in the implementation steps below** |

**Net effect of "fixing all the risks":** ten of the twelve are now locked design decisions already reflected in this document (schema defaults, CI gates, phase sequencing) rather than open mitigation ideas — they don't need a future decision, just building as specified. Two require one additional concrete step each, both added directly into §7 below: Step 2.3 (content-integrity validation) and Step 5.6 (auto-backup on stage completion).

---

## 7. Implementation Steps (handoff spec for another model / dev team)

This section is written as an ordered, checkable build plan. Treat each numbered item as a unit of work; each includes what "done" looks like.

### Step 1 — Repo & tooling
1. `flutter create physix` targeting Android + iOS; set min SDK Android 26, iOS 13.
2. Add packages: `drift`, `drift_dev`, `sqlite3_flutter_libs`, `riverpod`, `fl_chart`, `uuid`, `path_provider`, `share_plus` (Tier-1 export), `permission_handler`.
3. Set up folder structure per §1.2 (`core/`, `domain/`, `data/`, `presentation/`).
4. **Done when:** empty app builds and launches on both platforms with a placeholder role-select screen.

### Step 2 — Data layer
1. Implement the schema in §5 as `drift` tables + DAOs.
2. Write a `ContentImporter` that reads `assets/content/kinematics_v1.json` on first launch and populates `content_packs`, `lesson_stages`, `quiz_items`, `mission_levels`.
3. **Step 2.3 — Content-integrity validation (fixes Risk #12):** before `ContentImporter` writes anything to the database, run a validation pass over the parsed JSON: `quiz_items.length == 10`; every `quiz_items[].correct_answer` exists as a `key` inside that item's own `choices_json`; every `mission_levels[].target_variable` is one of `{v0, v, a, t, d}`; every `stage_id` referenced anywhere resolves to an entry in `lesson_stages`. On any failure, abort the import and surface the specific field and item that failed — never a silent partial seed. Package the same check as a standalone script (`tools/validate_content.dart` or similar) runnable in CI against any future edit to the JSON file, so a bad content change is caught before it's bundled into a build, not just at first launch on a device.
4. **Done when:** a fresh install seeds the kinematics content pack automatically (verified by querying `quiz_items` count == 10), and deliberately corrupting one field of the JSON (e.g., an invalid `correct_answer` key) causes the validator to abort with a specific, correct error message rather than a crash or a silent partial import.

### Step 3 — Physics/scoring engine (pure Dart, no Flutter imports)
1. Implement SUVAT solver: given any 3 of `{v0, v, a, t, d}`, solve for the missing 1–2 using the four kinematic equations named in the lesson plan.
2. Implement `checkNumericAnswer(given, correct, tolerance)` and `checkMcqAnswer(given, correctKey)`.
3. Implement `computeSpeedVelocity(distance, displacement, time)` for Motion Lab auto-calculation.
4. Unit-test every function against the 10 answer-keyed items already in the lesson plan (e.g., item 6: rest→20 m/s in 4s ⇒ a=5 m/s², already answer-keyed as B).
5. **Done when:** 100% of the lesson plan's 10 evaluation items and all worked examples pass as unit tests.

### Step 4 — Gamification engine
1. Implement rule evaluator reading `badges.unlock_rule_json` against a student's aggregated stats.
2. Implement points ledger writer triggered on `mission_attempts` and `quiz_attempts` completion.
3. **Done when:** completing both Mission Mode levels + scoring ≥80% on Evaluation Terminal unlocks the two badges defined in the seeded content pack.

### Step 5 — Student Portal screens (build in 5E order — this order matters for testability, each stage's output feeds the next)
1. **Trip Tracker** (Engage): prediction UI → writes `prediction_log`.
2. **Motion Lab** (Explore): trial entry form → writes `motion_trials`, auto-computes speed/velocity via Step 3 engine, renders live chart.
3. **Graph Visualizer** (Explain): reads `motion_trials`, renders d-t/v-t charts, slope/area interaction, equation-derivation stepper (static content from `lesson_stages.body_json`).
4. **Mission Mode** (Elaborate): level list → problem screen → engine-checked submission → writes `mission_attempts`, `points_ledger`.
5. **Evaluation Terminal** (Evaluate): 10-item runner → writes `quiz_attempts` + `quiz_item_responses`, immediate feedback, badge check on completion.
6. **Profile & Badges**: aggregate view + Tier-1 export button (writes `export_bundles`, invokes `share_plus`).
7. **Step 5.6 — Auto-backup on stage completion (fixes Risk #1):** on completion of *every* 5E stage (not only Evaluate), silently write a timestamped snapshot of that student's session data to a local backup file in app-private storage — no user action required. The existing "Share My Results" button in Profile & Badges now sends this already-generated backup rather than assembling one from scratch on tap. Add a non-blocking banner ("Last shared: 2 days ago") if a completed Evaluate session hasn't been exported to a teacher within 24 hours.
8. **Done when:** a single student can complete the entire Engage→Evaluate flow offline (airplane mode test) start to finish with no crashes, data is queryable in all six tables, and force-closing the app mid-Motion-Lab still leaves a recoverable backup snapshot from the last completed stage.

### Step 6 — Teacher Portal screens
1. Roster CRUD against `class_sections`/`users`.
2. Import screen: read a shared `export_bundles` file, upsert into local tables tagged with `imported_by_teacher_id`.
3. Dashboard: aggregate queries (avg pre/post, completion %, most-missed item via `quiz_item_responses` grouped by `item_id`).
4. Lesson Plan viewer: render `lesson_stages` content read-only with deep-links into the matching student module (for live classroom demo).
5. Export: dump raw tables to CSV/JSON for the researchers' statistical analysis (paired t-test / Hake Gain / Cronbach's Alpha inputs).
6. **Done when:** importing 3 test student export bundles produces correct aggregate numbers on the dashboard, verified by hand-calculation.

### Step 7 — Inclusive UX pass

1. Run through every screen with system font scaling at 200% — nothing should clip or overlap.
2. Add semantic labels for all interactive elements (screen-reader pass).
3. Verify color-contrast ratios (WCAG AA minimum) on all feedback states (correct/incorrect) — **run this check twice, once per theme**, against the §3.1a light/dark token table. Dark-mode contrast failures are common even when the light-mode version passes, since inverting text/background doesn't automatically preserve ratio — check each pair directly rather than assuming.
4. Verify the Settings toggle correctly switches between light, dark, and "match device setting," and that switching doesn't require an app restart.
5. **Done when:** a screen-reader can navigate the full Engage→Evaluate flow without a sighted assist, and every screen passes contrast checks in both light and dark mode independently.

### Step 8 — Low-spec performance pass
1. Test on the lowest-spec Android device available (aim: 2GB RAM, Android 8).
2. Profile chart re-render cost in Motion Lab/Graph Visualizer; cap trial history rendered at once if needed.
3. **Done when:** no frame drops >100ms during normal use on the target low-spec device.

### Step 9 — Validator & pilot build (Android + iOS)

**First, a cost distinction worth being precise about — "testing on your own device" and "distributing to validators/pilot participants" are not the same thing, and only one of them is free on iOS.**

| | Testing on your own personal device (dev/debug builds) | Distributing to validators/pilot participants (release builds, other people's devices) |
|---|---|---|
| **Android** | Free — `flutter run` over USB, or `flutter build apk` + direct install, no account needed | Free — direct signed APK, no store account needed (Step below) |
| **iOS** | Free — connect via cable, build/run through Xcode with a free Apple ID; no Developer Program enrollment required for this | **Not free** — requires the $99/year Apple Developer Program for TestFlight (or the 7-day-expiring sideloading workaround, impractical for a validator panel or classroom — see earlier discussion) |

So Android is free at every stage of this project, personal testing through pilot distribution alike. iOS is free only up through *your own* device testing during development (Eng-2 through Eng-4) — the moment the app needs to reach someone else's iPhone for validation or piloting, the $99/year requirement applies. That's the specific point where the two platforms' costs diverge, and it's worth planning the Apple Developer enrollment around that moment rather than assuming free personal-device testing extends to the pilot phase.

Distribution at this stage is **pilot/validator testing only** — not a public app-store release. That distinction matters: it's free (aside from the Apple fee below), faster, requires no store review, and keeps you fully inside the "completely offline, no infrastructure" story the thesis is built on. Do the two platforms in this order, since Android has no gatekeeping cost and can happen immediately.

**9a. Personal-device testing — free on both platforms, do this throughout Eng-2–Eng-4, not just at pilot time:**

*Android:*
1. Enable Developer Options + USB Debugging on the phone (Settings → About Phone → tap Build Number ~7 times, then Developer Options → USB Debugging).
2. Connect via USB, run `flutter devices` to confirm it's detected, then `flutter run` — installs directly with hot reload active.
3. No account, no fee, no expiry — this works indefinitely for as many personal Android devices as you connect.

*iOS (Xcode direct-install path):*
1. Connect the iPhone to a Mac via cable; on the phone, enable Developer Mode (Settings → Privacy & Security → Developer Mode) and trust the computer when prompted.
2. Open the project's iOS target in Xcode, sign in with a **free Apple ID** under Xcode → Settings → Accounts (no paid Developer Program needed for this step).
3. Select the connected device as the run target and build — Xcode handles signing automatically with the free account.
4. **Limitation to plan around:** builds installed this way expire after **7 days** and need reconnecting to Xcode to reinstall; a free account also caps how many app "slots" can be active on one device at once. Fine for your own ongoing development testing; not workable for handing off to validators or a pilot classroom (that's what 9c below is for).

**9a.5. Storing the code and hosting the install file on GitHub:**

One clarification worth having ready if a panel member asks about it: **the app itself stays fully offline** — nothing about this changes that. GitHub is only used to *host the installer file* so it can be downloaded once, the same way any software (including fully offline desktop programs) still needs to be downloaded from somewhere the first time. It's a distribution detail, not an architecture change — no different in kind from handing someone a USB drive, just easier to scale to a validator panel or a classroom.

*Setting up the repository (one-time):*
1. Create a free GitHub account at github.com if you don't already have one.
2. Create a new repository (e.g., `physix` or `kinematix`) — Private is fine while building; you can make it Public later if you want it open for review or discoverable.
3. On your development machine, in the Flutter project folder: `git init`, then `git add .`, `git commit -m "Initial commit"`.
4. Connect it to the GitHub repo and push: `git remote add origin https://github.com/<your-username>/<repo-name>.git`, then `git branch -M main`, then `git push -u origin main`.
5. **Add a `.gitignore` for Flutter before your first commit** (Flutter's own `flutter create` generates one automatically — keep it) so build artifacts and local config don't get pushed unnecessarily.
6. From here on, commit and push regularly (`git add . && git commit -m "..." && git push`) as you build through Steps 1–8 — this is also what lets Claude Code's work be checkpointed and reviewed slice by slice, matching the "implement one step, then stop for review" workflow from §8.

*Publishing a release with the installable APK (once you have a working build):*
1. Run `flutter build apk --release` locally to produce the `.apk` (path: `build/app/outputs/flutter-apk/app-release.apk`).
2. On your repo's GitHub page, go to **Releases** (right-hand sidebar) → **"Create a new release."**
3. Give it a tag (e.g., `v1.0-pilot`) and a title (e.g., "PhysiX in Motion — Pilot Build 1").
4. Drag the `app-release.apk` file into the release's asset upload area, then **Publish release.**
5. GitHub now gives that file a permanent, stable download URL — this is the exact link the QR code in 9b.4 should point to.
6. For a new build later, repeat with a new tag (e.g., `v1.1-pilot`) rather than overwriting — keeps a clean version history, which is also useful evidence for your methodology chapter if you need to show iteration between validator rounds.

**9b. Android — direct APK, no store account needed:**
1. Run `flutter build apk --release` — produces a single signed `.apk` file (you'll need a release keystore first; `flutter build apk` will prompt/guide this if one isn't configured yet).
2. Distribute the `.apk` directly to validators/pilot teachers via any offline-appropriate channel — file transfer, USB, local share — consistent with the app's own no-network design.
3. Testers install by opening the file and allowing "install from unknown sources" once (a one-time device setting, not a recurring step).
4. **QR code install (recommended for validator/pilot sessions):** host the release `.apk` at a stable link — a GitHub Release asset URL or an itch.io project page (both free, both covered earlier) — then generate a QR code pointing to that exact URL (any free QR generator works; the QR code itself is just an encoded link, no special app-store integration needed). Print it on the validator checklist or display it at the start of a pilot session so each device scans, downloads, and installs in one motion — no typing a URL, no cable, no file transfer app needed.
5. **Done when:** a validator or pilot-class device with zero prior setup can scan the QR code, download, and open the app from the shared APK link alone, no Play Store, no internet required beyond the one-time download itself.

**9c. iOS — TestFlight (requires a paid Apple Developer account; building on Windows via cloud CI, since Xcode is macOS-only):**
1. Enroll in the Apple Developer Program ($99/year) if not already enrolled — required for any iOS distribution beyond a single personal device, **regardless of what machine builds the app.** Cloud CI (next step) removes the need to own a Mac; it does not remove this requirement, since Apple's signing infrastructure is what actually gates installation.
2. **Build via cloud CI, not local Xcode:** push the project to GitHub, connect it to **Codemagic** (free tier: 500 macOS build minutes/month), select the Flutter Workflow → iOS, and connect your Apple Developer Portal account under Distribution → iOS code signing (Automatic mode) — Codemagic generates and manages certificates/provisioning profiles without ever touching a physical Mac. Alternative: a GitHub Actions workflow on a `macos-latest` runner running `flutter build ipa` (free for public repos), with signing set up manually. Full step-by-step in `CLAUDE_CODE_KICKOFF_PROMPT.md`'s iOS section. If occasional Mac access becomes available later, Xcode can still be used the conventional way (`flutter build ipa` + Organizer upload) — it's an alternative path, not a requirement, given the above.
3. Set up an **internal or external TestFlight group** in App Store Connect (reachable independent of which machine produced the build) — external supports up to 10,000 testers and needs only a lightweight Apple review (typically faster and less strict than a full App Store submission) before testers can install. An external group can generate a **public TestFlight link**.
4. **QR code install:** convert that public TestFlight link into a QR code the same way as the Android one (9b.4) — testers scan it, it opens the free TestFlight app (prompting install if they don't have it yet), then installs PhysiX in Motion through it. Same one-scan experience as Android, just routed through Apple's required signing layer instead of a direct file.
5. **Done when:** an invited iOS tester can scan the QR code, install via TestFlight, and the app behaves identically offline to the Android build — no feature gap between platforms at pilot stage.

6. Prepare an in-app "Validator Mode" that surfaces the Table-of-Specifications tag (`quiz_items.tos_competency`) alongside each item, so validators can check curriculum alignment directly against Appendix G without a separate spreadsheet.
7. **Overall done when:** both Android and iOS builds are distributed — each reachable by a single QR-code scan — and the validator checklist (Appendix H items) can be completed entirely from either device + the Lesson Plan viewer, no external documents needed except the checklist itself.

**Note on public app-store release:** submitting to the Google Play Store ($25 one-time fee) or a full Apple App Store listing ($99/year, same enrollment as TestFlight above) is a separate, later milestone — not required for the thesis pilot, and worth treating as its own post-defense phase since it adds store review time, a required privacy policy URL, a completed Data Safety/content-rating questionnaire, and — since the audience includes minors — compliance with Google Play Families Policy and Apple's Kids Category guidelines. The app's zero-network, on-device-only design is a genuine strength here (there's no tracking/ad SDK to declare), but the exact policy requirements should be checked directly against Google's and Apple's current published policies at submission time rather than assumed from this document, since store policies change independently of this build.

### Step 10 — Pilot-readiness hardening
1. Add local crash logging (write to a local file, never auto-uploaded) so post-pilot debugging doesn't require internet.
2. Add a data-integrity self-check on launch (verify no orphaned rows, DB migrations applied cleanly).
3. Dry-run the full Tier-1 export→import cycle with 5 simulated students on one teacher device.
4. **Done when:** pilot classroom can run start-to-finish (Engage through teacher's post-lesson data import) with zero manual DB intervention.

---

## 8. What to hand to a coding-focused model next

If you're about to pass this to a coding agent (e.g., Claude Code) to actually write the Flutter project, give it, in order:
1. This document.
2. `kinematics_v1.json` — already authored, matches §5's `lesson_stages`/`quiz_items`/`mission_levels` shape, and is the final content-architecture decision (JSON, not hardcoded — see §6, Risk #12 for the one trade-off this introduces and its required Step 2.3 fix).
3. A one-line instruction: "Implement Step 1 through Step 2.3 of the Implementation Steps section only, then stop for review" — build in the ordered slices above rather than everything at once, so each layer can be checked before the next is built on top of it. Step 2.3 (content-integrity validation) should not be skipped even in an early slice — it's what keeps a bad JSON edit from silently corrupting seeded data later.
