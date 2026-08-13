# How to start — Android Studio + Claude Code

1. **Install the plugin (one-time):** Android Studio → Settings/Preferences → Plugins → Marketplace → search "Claude Code" → Install → restart Android Studio.
2. **Put these 8 files in your Flutter project root** (same folder as `pubspec.yaml`):
   - `CLAUDE.md`
   - `PhysiX_Technical_Blueprint.md`
   - `kinematics_v1.json` (also copy into `assets/content/kinematics_v1.json` once the project is scaffolded — Step 1 covers this)
   - `icon_full_bleed_1024.png`
   - `icon_adaptive_background.png`
   - `icon_adaptive_foreground.png`
   - `icon_mark_transparent.png`
   - `physix_in_motion_logo_reference.jpg` (kept for provenance only)
   - `codemagic.yaml` (cloud iOS/Android build config — see the no-Mac section below)
   - `.github_workflows_ios-build.yml` (optional GitHub Actions alternative — move to `.github/workflows/ios-build.yml` if used)
3. **Open the integrated terminal in Android Studio** (View → Tool Windows → Terminal) and run:
   ```
   claude
   ```
   This activates the IDE integration (diff viewer, file context, diagnostics sharing) automatically. If you haven't installed the Claude Code CLI itself yet, running `claude` for the first time will prompt you through it — it requires a paid Claude plan (Pro, Max, Team, or Enterprise).
4. **Paste the prompt below as your first message.**

---

# iOS side — building without a Mac (Windows workflow)

Since you're on Windows, Xcode itself isn't an option locally — it's macOS-only and there's no workaround for that specific piece of software. The actual solution isn't "get a Mac," it's **cloud CI**: a service spins up a real macOS virtual machine, pulls your code, and runs the iOS build there, and you never touch Xcode directly.

**One thing this does not change, worth being clear about:** cloud CI solves the "no Mac hardware" problem, not the "Apple requires signing" problem. You still need an active **Apple Developer Program membership ($99/year)** to code-sign the app and distribute via TestFlight — that requirement comes from Apple, not from where the build runs. Cloud CI removes the Mac purchase, not this fee.

**Recommended: Codemagic — config already included as `codemagic.yaml` in this project.** Free tier: 500 macOS build minutes/month (~25–50 iOS builds — plenty for a solo/two-person thesis project's cadence), automatic code signing via an App Store Connect API key, works identically on a private or public repo.

1. Push this Flutter project (including `codemagic.yaml`) to a GitHub (or GitLab/Bitbucket) repository.
2. Sign up at codemagic.io, connect your GitHub account, select this repo — Codemagic detects `codemagic.yaml` automatically.
3. Before your first build, edit the placeholders inside `codemagic.yaml`: `BUNDLE_ID`, the email recipient, and create the two credential groups it references (`app_store_credentials`, `android_signing`) in Codemagic's UI under your app's settings — this is where the $99/year Developer Program membership is actually required, for the App Store Connect API key. Codemagic's setup wizard walks through generating both if you don't have them yet.
4. Click **Start Build**, select `ios-workflow` (or `android-workflow` for the Android release APK — one config file handles both platforms). Codemagic builds on a macOS VM and either publishes straight to TestFlight (if the `app_store_connect` publishing block is filled in) or emails you the `.ipa`.

**Alternative: GitHub Actions — config included as `.github_workflows_ios-build.yml` in this project** (rename/move it to `.github/workflows/ios-build.yml` in your repo — GitHub only recognizes workflows at that exact path). **Only genuinely free if the repository is public** — on a private repo, macOS runner minutes drain your monthly free allowance at a 10x multiplier, so a private repo's free quota (2,000 minutes) becomes an effective ~200 macOS-minutes, exhausted after just a few builds. It also builds **unsigned** by default (`--no-codesign`); producing a TestFlight-ready signed build means manually exporting your Apple certificate and provisioning profile as GitHub encrypted secrets and scripting the import — the commented-out steps in the file show where that goes, but it's real setup work Codemagic avoids entirely. Use this path only if you've separately decided to make the repo public.

**If you ever do get occasional access to a Mac** (a lab machine, a friend's, a cloud Mac rental), Xcode still works exactly as described in most guides — mainly useful there for visually managing signing certificates the first time, or Organizer-based TestFlight uploads — but it's genuinely optional given the cloud CI path above; nothing in this project requires it.

---


# Kickoff prompt — paste this into Claude Code

```
Read CLAUDE.md in this project root in full before doing anything else — it's the
operating agreement for this build, including a locked tech stack, an ordered
checklist, and a "don't do this" list. Read PhysiX_Technical_Blueprint.md next for
the full architecture, UI/UX spec, database schema, and risk register it references.

Project: PhysiX in Motion — an offline, gamified Grade 11 STEM physics app
(Motion in One Dimension: Displacement, Velocity, Acceleration), built for a
thesis, in Flutter, developed in Android Studio.

Four requirements that override any default assumption you'd normally make:

1. MINIMAL, CLEAN DESIGN. One primary action per screen, generous whitespace,
   no decorative clutter, no more than ~2 new concepts on any single screen.
   Follow blueprint §3.1's UI/UX principles and the §3.1a color token table
   exactly (navy/cyan/orange, light + dark mode) — don't introduce a different
   visual direction or default Material theme styling.

2. LOCAL DATABASE ONLY. SQLite via `drift`, on-device, single-user per install.
   No backend, no cloud sync, no network calls, no analytics/tracking SDK,
   anywhere in the app. If a feature seems to need a server, that's a sign to
   redesign the feature, not to add one — this is a hard constraint from the
   thesis's offline-first scope.

3. BOTH PLATFORMS. Android AND iOS, from one Flutter codebase, min SDK
   Android 26 / iOS 13. Don't build Android-only and treat iOS as an
   afterthought — validate both are buildable from early on, per CLAUDE.md's
   Step 9 distribution plan (Android direct APK, iOS via TestFlight).

4. WORK IN ORDERED SLICES. Implement Step 1 from CLAUDE.md's checklist, then
   stop and wait for my review before starting Step 2. Do not batch multiple
   steps together even if the next one looks obvious. Flag it explicitly if
   you think a later step should change something from an earlier one, rather
   than silently changing it.

The app icon and content pack are already finalized and included in this
project (icon_full_bleed_1024.png + the Android adaptive pair, and
kinematics_v1.json) — use them as specified in CLAUDE.md, don't regenerate or
redesign either.

Start with Step 1 — repo & tooling — now.
```
