# CLAUDE.md — PhysiX in Motion

Read this file in full before writing any code. It is the working agreement for this project, not just background — follow the constraints and the ordered checklist below exactly, and stop where instructed.

## What this is

**PhysiX in Motion** — an offline, gamified mobile physics app for Grade 11 STEM students, built as the applied deliverable for a thesis (*Developing and Evaluating PhysiX in Motion: A Gamified Mobile Application for Grade 11 STEM Physics*). v1 covers exactly one topic: **Motion in One Dimension (Displacement, Velocity, Acceleration)**, structured around a 5E lesson plan (Engage/Explore/Explain/Elaborate/Evaluate).

**The full spec lives in `PhysiX_Technical_Blueprint.md` in this repo — read it before starting any step below.** This file is the condensed, actionable checklist version of that document; the blueprint is the source of truth whenever the two disagree.

## Reference files in this project

- `PhysiX_Technical_Blueprint.md` — full architecture, UI/UX spec, database schema, risk register, phased plan. **Read fully first.**
- `kinematics_v1.json` — the seed content pack (10 quiz items, 2 mission levels, all 5E stage content, badge rules). Ships as `assets/content/kinematics_v1.json`.
- `physix_in_motion_logo_reference.jpg` — original design reference (glowing cyan X/crossbars, orbital ellipse, orange endpoint marker, dark navy gradient). Kept for provenance only — superseded by the production assets below for actual icon generation.
- `icon_full_bleed_1024.png` — production-ready combined icon (1024×1024, full-bleed, no baked-in corner rounding). Use for iOS and as the Android legacy/fallback icon.
- `icon_adaptive_background.png` / `icon_adaptive_foreground.png` — Android adaptive icon layer split (background = navy gradient only; foreground = the X/orbit/dot mark, transparent, scaled into Android's safe zone). Feed both into `flutter_launcher_icons`' adaptive icon config.
- `icon_mark_transparent.png` — mark only, transparent background, for in-app use (splash screen, headers).
- `icon_ios_fullbleed_1024.png` — submission-ready iOS icon: full-bleed 1024×1024, no pre-applied corner rounding (iOS masks corners itself).
- `icon_android_background_1024.png` + `icon_android_foreground_1024.png` — Android adaptive icon layers: background is the flat navy gradient (no mark), foreground is the mark alone on a transparent layer, scaled to stay within Android's ~66% safe zone so it survives circle/squircle/rounded-square launcher masks. Use both together in `flutter_launcher_icons`' adaptive icon config, not the iOS file.
- `icon_mark_transparent_1024.png` — mark only, transparent background, no icon-safe-zone scaling — for in-app use (splash screen, headers, About screen), not for launcher icon generation.

Use these four files with `flutter_launcher_icons` per Step 9 below; do not redesign the mark itself.

## Non-negotiable constraints

Do not deviate from these without asking first — they are deliberate decisions made across a long design process, not defaults to reconsider:

1. **Completely offline. No backend, no network calls, no analytics/tracking SDKs, anywhere in the app.** This is a thesis requirement, not a cost-cutting choice. If a feature seems to need a server, the answer is "it doesn't get built that way," not "add a server."
2. **Cross-platform from one codebase** — Android and iOS both, via Flutter.
3. **Content is JSON, not hardcoded.** `kinematics_v1.json` is the final content-architecture decision. Never inline quiz text, scenario copy, or answer keys directly into widget code.
4. **Local SQLite only** (via `drift`), single device, no cloud sync. Tier-1 export/import (a shareable file) is the only cross-device mechanism — see blueprint §1.3 and §5.
5. **No public student leaderboard by default.** `app_settings.leaderboard_visible` defaults `false`. Teacher must explicitly opt in per class. This is a pedagogical decision from the thesis lit review, not a placeholder.
6. **Dark mode is in scope**, following system setting by default, per blueprint §3.1 principle 6 and the §3.1a color token table.

## Tech stack (locked)

- Flutter, min SDK Android 26 / iOS 13
- State management: Riverpod
- Local DB: `drift` + `sqlite3_flutter_libs`
- Charts: `fl_chart`
- Export/share: `share_plus`
- Other: `uuid`, `path_provider`, `permission_handler`

## Folder structure (per blueprint §1.2)

```
lib/
  core/         # physics engine (pure Dart, no Flutter imports), gamification rules engine, theme/colors, constants
  domain/       # entities, use-cases
  data/         # drift tables/DAOs, content importer, repositories
  presentation/ # one folder per feature: trip_tracker/, motion_lab/, graph_visualizer/, mission_mode/, evaluation/, badges/, settings/, teacher_dashboard/, roster/, lesson_plan_viewer/, reports/
```

Keep `core/physics_engine/` and `core/gamification/` free of any Flutter import — they must be unit-testable in isolation.

---

## Build checklist — work through in this exact order

**Work in the ordered slices below. Implement one numbered step, then stop and wait for review before starting the next.** Do not jump ahead or batch multiple steps into one pass, even if the next step looks obvious — this project has been deliberately over the small decisions (naming, palette, scope boundaries), and slicing the build the same way keeps mistakes small and reviewable.

- [ ] **Step 1 — Repo & tooling.** `flutter create`, add the locked packages above, set min SDK versions, scaffold the folder structure. Done when the app builds and launches on both platforms with a placeholder role-select screen.

- [ ] **Step 2 — Data layer.** Implement the full schema from blueprint §5 in `drift`. Build `ContentImporter` to read `assets/content/kinematics_v1.json` on first launch.
  - [ ] **Step 2.3 — content-integrity validation (required, do not skip).** Before writing anything to the DB: assert `quiz_items.length == 10`; every `correct_answer` exists in that item's own `choices_json`; every `mission_levels.target_variable` is one of `{v0, v, a, t, d}`; every `stage_id` reference resolves. On failure, abort with a specific field-level error, never a silent partial import. Package as a standalone script runnable in CI too.
  - Done when: fresh install seeds correctly (verify `quiz_items` count == 10), and deliberately corrupting one JSON field causes a clear abort, not a crash or silent partial seed.

- [ ] **Step 3 — Physics/scoring engine.** Pure-Dart SUVAT solver, `checkNumericAnswer`/`checkMcqAnswer`, `computeSpeedVelocity`. Write a golden-file unit test for every one of the 10 quiz items and both mission levels in `kinematics_v1.json`, asserting the engine's computed answer matches `correct_answer` within `tolerance`. Wire into CI so a failing golden test blocks the build. Done when 100% of those tests pass.

- [ ] **Step 4 — Gamification engine.** Rule evaluator reading `badges.unlock_rule_json` against aggregated student stats; points ledger writer. Done when completing both mission levels + ≥80% on Evaluation unlocks the two seeded badges.

- [ ] **Step 5 — Student Portal**, build in 5E order (each stage's output feeds the next):
  1. Trip Tracker (Engage) → `prediction_log`
  2. Motion Lab (Explore) → `motion_trials`, live chart
  3. Graph Visualizer (Explain) → reads `motion_trials`, read-only teaching aid
  4. Mission Mode (Elaborate) → `mission_attempts`, `points_ledger`
  5. Evaluation Terminal (Evaluate) → `quiz_attempts`, `quiz_item_responses`, badge check
  6. Profile & Badges → aggregate view, Tier-1 export button
  7. **Settings** (shared shell, reachable via header icon from Profile & Badges / Teacher Dashboard, not a bottom-nav tab) → Appearance (Light/Dark/Match device, applies instantly, no restart), Simple graphics toggle, and teacher-only rows (Extended time, Class Leaderboard visibility default-off). See blueprint §3.2/§3.3.
  - [ ] **Step 5.6 — auto-backup on stage completion (required).** On completion of every 5E stage, silently snapshot that student's session data to a local backup file — no user action required. "Share My Results" sends this existing backup rather than assembling one on tap. Add a non-blocking banner if a completed Evaluate session hasn't been exported within 24 hours.
  - Done when: full Engage→Evaluate flow works in airplane mode with no crashes, all six tables populate correctly, and force-closing mid-Motion-Lab still leaves a recoverable backup from the last completed stage.

- [ ] **Step 6 — Teacher Portal.** Roster CRUD, Tier-1 import screen, dashboard (avg pre/post, completion %, most-missed item — cap at 4 top-line metrics per blueprint §3.1 principle 5), Lesson Plan viewer (deep-links into matching student module), raw CSV/JSON export for research stats. Include a 3–4-step first-run guided tour. Done when importing 3 test export bundles produces correct aggregate numbers, verified by hand.

- [ ] **Step 7 — Inclusive UX pass.** 200% font scaling with no clipping, full screen-reader semantic labels, WCAG AA contrast — **checked independently in both light and dark mode** against the §3.1a token table, not assumed from one pass. Verify the dark/light/match-device Settings toggle switches without requiring an app restart.

- [ ] **Step 8 — Low-spec performance pass.** Test on the lowest-spec Android device available (2GB RAM / Android 8 target). Profile chart re-render cost; cap rendered trial history if needed. Done when no frame drops >100ms on the target device.

- [ ] **Step 9 — Validator & pilot build, Android + iOS.** Signed release APK (direct install, no store account) for Android. For iOS: **dev machine is Windows, no local Xcode** — build via cloud CI (Codemagic recommended, free tier 500 macOS build minutes/month; GitHub Actions `macos-latest` runner as an alternative), not `flutter build ipa` run locally. TestFlight distribution still requires Apple Developer Program enrollment ($99/year) regardless of which machine builds the app — that's an Apple signing requirement, not a build-location one; flag this dependency early, it has its own lead time separate from build time. Include an in-app "Validator Mode" surfacing `quiz_items.tos_competency` per item. Generate launcher icons via `flutter_launcher_icons` using `icon_full_bleed_1024.png` (iOS / Android legacy) and the `icon_adaptive_background.png` / `icon_adaptive_foreground.png` pair (Android adaptive icon) — these are already correctly formatted, no further reformatting needed. Full detail in blueprint §7 Step 9 and `CLAUDE_CODE_KICKOFF_PROMPT.md`'s iOS section.

---

## Things not to do

- Don't add a backend, remote database, or any network permission "just in case" — re-read constraint 1 if this seems tempting.
- Don't hardcode any quiz/scenario/badge content into widget code — it all comes from the JSON pack.
- Don't build a public-by-default leaderboard.
- Don't skip Step 2.3 or Step 5.6 even in an early/rough pass — they're fixes for specific identified risks (content corruption, data loss on device failure), not polish.
- Don't rename the app, change the color tokens, or redesign the logo mark itself (the glowing X/orbit design in `physix_in_motion_logo_reference.jpg` is final) — reformatting it into proper icon specs per Step 9 is expected and required; changing the design is not.
