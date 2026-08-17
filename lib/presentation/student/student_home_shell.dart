import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';
import '../../data/evaluation/evaluation_providers.dart';
import '../../data/gamification/gamification_service.dart';
import '../../data/session/current_student_provider.dart';
import '../../data/session/stage_progress_repository.dart';
import '../../data/session/student_profile_provider.dart';
import 'evaluation/evaluation_terminal_screen.dart';
import 'graph_visualizer/graph_visualizer_screen.dart';
import 'mission_mode/mission_mode_screen.dart';
import 'motion_lab/motion_lab_screen.dart';
import 'profile/profile_screen.dart';
import 'trip_tracker/trip_tracker_screen.dart';

// ============================================================================
// TEACHER ROSTER INTEGRATION & OFFLINE SYNC (compressed QR path implemented)
// ============================================================================
//
// PhysiX in Motion has two independent, fully offline student -> teacher
// sync paths, per blueprint §1.3 ("Tier 1 — Per-device, export/import file
// ... shared via Nearby Share / Bluetooth / SD-card copy / QR code (small
// payloads only)"). Both are Tier-1 in the blueprint's sense — QR is just
// one of its sanctioned transports for the same one-way flow, not a second
// cross-device mechanism — so CLAUDE.md constraint 4 stays respected:
//
//   A. Full file bundle (every table) — "Share My Results" on Profile &
//      Badges -> AutoBackupService.snapshotNow() -> share_plus -> the
//      teacher's file-based Import screen -> TeacherImportService. This is
//      the authoritative, complete record; use it whenever a full backup
//      or a cracked-screen recovery is needed.
//   B. Compressed QR (this section) — built here in _buildStudentQrPayload
//      and _buildAnsString, ingested by QrIngestService. Small enough
//      (well under 1 KB) to render as a single, immediately-scannable QR
//      frame, and — because of the `ans` field below — carries real
//      per-item answers, not just a summary score.
//
// 1) THE QR PAYLOAD SCHEMA ---------------------------------------------
//
//    Built by _buildStudentQrPayload() further down this file:
//
//    {
//      "userId": string,        // Users.user_id on the student's own device
//      "studentId": string,     // StudentProfile.studentId (LRN / class number)
//      "sectionPin": string,    // StudentProfile.sectionPin
//      "quizScore": string,     // "correct/total", e.g. "8/10"
//      "ans": string,           // 10 chars, one per quiz item — see (2)
//      "labTrials": int,        // Motion Lab trial count (display-only,
//                                // not written to motion_trials by the
//                                // scanner — see QrIngestService)
//      "completionPct": int,    // % of the 5 5E stages completed
//      "generatedAt": string    // ISO-8601
//    }
//
// 2) THE COMPRESSED `ans` ANSWER STRING ---------------------------------
//
//    Built by _buildAnsString(orderedItems, responses): one character per
//    quiz item, in orderQuizItemsByNumber order (lib/data/evaluation/
//    evaluation_providers.dart — sorts q1..q10 by the numeric suffix of
//    item_id), e.g. "AABCDABCDA" for a 10-item pack. This is what lets a
//    single QR scan populate real quiz_item_responses rows — see (3) —
//    rather than just a summary score, while still safely fitting one QR
//    frame (~10 bytes for the answers themselves, versus the full bundle's
//    prediction_log/motion_trials/mission_attempts/quiz_item_responses
//    arrays in AutoBackupService._buildPayload(), which can easily exceed
//    a single frame's practical capacity once a student has accumulated
//    many trials).
//
//    Two call sites build this string, from two different data sources
//    that both resolve to the SAME ordering, so a QR generated from either
//    one decodes identically on the teacher side:
//      - _handleEvaluationFinished: straight from the just-finished
//        attempt's own in-memory responses (passed through
//        EvaluationTerminalScreen.onFinished).
//      - _dashboardStatsProvider: queries quiz_item_responses for the
//        student's latest completed attempt, for the Dashboard's
//        persistent "Show My QR Code" button.
//
// 3) HOW THE TEACHER PORTAL'S CAMERA SCANNER PARSES + INGESTS THESE -----
//
//    Implemented: lib/presentation/teacher/roster/scan_qr_screen.dart
//    (camera preview via `mobile_scanner`, on-device only) feeds each
//    decoded frame's raw JSON string into
//    lib/data/teacher/qr_ingest_service.dart's QrIngestService.ingest():
//      a. Matches sectionPin against this teacher's own ClassSections,
//         then studentId/userId against Users (see QrIngestService's own
//         doc comment for the exact matching precedence — userId first,
//         then officialStudentId+section, so it never conflates two
//         same-named students). The display name is never carried in the
//         QR itself (removed to keep the payload small and avoid encoding
//         a student's full name into a scannable code) — it's resolved
//         from whatever's already on that roster entry, or a generic
//         placeholder for a student the teacher has never added/scanned
//         before.
//      b. Upserts a summary quiz_attempts row from `quizScore`.
//      c. Re-derives orderQuizItemsByNumber() locally and walks `ans`
//         character-by-character, upserting one quiz_item_responses row
//         per quiz item (isCorrect computed by comparing the character to
//         that item's correct_answer) — deterministic IDs make re-scanning
//         the same QR safe (refreshes in place, no duplicates).
//      d. Falls back to a summary-only attempt (no item responses) if
//         `ans` is missing or the wrong length, rather than failing the
//         whole scan.
//
//    Because (c) writes real quiz_item_responses, QR-ingested students DO
//    show up in the Reports/Export item-level analyses and in the
//    per-question (Q1-Q10) breakdown on the student detail screen — not
//    just in aggregate class-average/completion metrics.
// ============================================================================

/// Stage index (0..4) -> display title, in 5E order. Mirrors [kFiveEStages]
/// from stage_progress_repository.dart.
const _stageTitles = [
  'Trip Tracker',
  'Motion Lab',
  'Graph Visualizer',
  'Mission Mode',
  'Evaluation Terminal',
];

const _stageSubtitles = [
  '1. Engage',
  '2. Explore',
  '3. Explain',
  '4. Elaborate',
  '5. Evaluate',
];

const _stageInstructions = [
  'ENGAGE — Trip Tracker\n\nPredict who wins the race and why, then compare '
      'your prediction against the outcome. This sets up the question the '
      'rest of the lesson answers.',
  'EXPLORE — Motion Lab\n\nWalk your own path and record the distance, '
      'displacement, and time. Each trial plays back as a simulation and '
      'plots on the live displacement-time chart.',
  'EXPLAIN — Graph Visualizer\n\nRead the graphs your Motion Lab trials '
      'produced, tap two points to find the slope, and work through the '
      'four kinematic equations.',
  'ELABORATE — Mission Mode\n\nApply the kinematic equations to solve real '
      'commute scenarios. Both mission levels must be solved correctly to '
      'complete this stage.',
  'EVALUATE — Evaluation Terminal\n\nAnswer all 10 questions in the formal '
      'quiz. Your score, points, and any newly unlocked badges appear as '
      'soon as you finish.',
];

/// Bundled stats the Dashboard tab reads in one shot: overall 5E progress,
/// Motion Lab trial count, the student's section PIN, and their latest
/// completed quiz score (plus that attempt's compressed answer string for
/// the QR code — see [_buildAnsString]).
class _DashboardStats {
  const _DashboardStats({
    required this.student,
    required this.completedStages,
    required this.labTrialsCount,
    required this.latestQuizAttempt,
    required this.latestAnsString,
  });

  final UserRow student;
  final Set<String> completedStages;
  final int labTrialsCount;
  final QuizAttemptRow? latestQuizAttempt;
  final String? latestAnsString;
}

final _dashboardStatsProvider = FutureProvider.autoDispose<_DashboardStats>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final student = await ref.watch(currentStudentProvider.future);

  final completedStages = await StageProgressRepository(db)
      .completedStages(userId: student.userId, packId: kActiveContentPackId);

  final trials =
      await (db.select(db.motionTrials)..where((t) => t.userId.equals(student.userId))).get();

  final latestQuizAttempt = await (db.select(db.quizAttempts)
        ..where(
          (t) =>
              t.userId.equals(student.userId) &
              t.packId.equals(kActiveContentPackId) &
              t.completedAt.isNotNull(),
        )
        ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
        ..limit(1))
      .getSingleOrNull();

  String? latestAnsString;
  if (latestQuizAttempt != null) {
    final orderedItems = orderQuizItemsByNumber(
      await (db.select(db.quizItems)..where((t) => t.packId.equals(kActiveContentPackId))).get(),
    );
    final responses = await (db.select(db.quizItemResponses)
          ..where((t) => t.attemptId.equals(latestQuizAttempt.attemptId)))
        .get();
    latestAnsString = _buildAnsString(orderedItems, responses);
  }

  return _DashboardStats(
    student: student,
    completedStages: completedStages,
    labTrialsCount: trials.length,
    latestQuizAttempt: latestQuizAttempt,
    latestAnsString: latestAnsString,
  );
});

/// Builds the compressed per-item answer string (see qr_ingest_service.dart)
/// from [orderedItems] (canonical q1..q10 order) and a set of responses —
/// one character per item, in position order, '-' for any item with no
/// matching response.
String _buildAnsString(List<QuizItemRow> orderedItems, List<QuizItemResponseRow> responses) {
  final byItemId = {for (final r in responses) r.itemId: r.givenAnswer};
  return orderedItems.map((item) => byItemId[item.itemId] ?? '-').join();
}

/// Student Portal shell. Index 0 is the Dashboard (introduces the app,
/// surfaces headline stats, and lists the 5E stages with their lock state).
/// Indices 1-5 mirror [kFiveEStages] in order via the existing screens.
/// Stages unlock sequentially: stage N is reachable once stage N-1 has been
/// completed, per [StageProgressRepository]. Profile & Badges (and Settings
/// behind it) stay reachable via the Dashboard's header icon rather than a
/// tab, matching blueprint §3.2/§3.3.
class StudentHomeShell extends ConsumerStatefulWidget {
  const StudentHomeShell({super.key});

  @override
  ConsumerState<StudentHomeShell> createState() => _StudentHomeShellState();
}

class _StudentHomeShellState extends ConsumerState<StudentHomeShell> {
  int _index = 0;

  void _goToTab(int index) {
    if (index == 0) {
      // Dashboard stats can go stale while another tab is active (the
      // IndexedStack keeps every tab alive), so refresh on the way back.
      ref.invalidate(_dashboardStatsProvider);
    }
    setState(() => _index = index);
  }

  /// Attempts to switch to stage [stageIndex] (0..4). Falls back to a
  /// profile-required dialog when the local Section PIN / Student ID
  /// profile isn't complete yet (a one-time local gate — see
  /// student_profile_provider.dart — required before Engage), or to a
  /// locked-stage dialog when the previous stage isn't complete yet.
  void _requestStage(int stageIndex, Set<String> completedStages, bool profileComplete) {
    if (!profileComplete) {
      _showProfileRequiredDialog(context);
      return;
    }
    final unlocked = stageIndex == 0 || completedStages.contains(_stageKey(stageIndex - 1));
    if (unlocked) {
      _goToTab(stageIndex + 1);
    } else {
      _showLockedStageDialog(context, stageIndex);
    }
  }

  void _handleEvaluationFinished(
    int correctCount,
    int totalCount,
    GamificationOutcome? outcome,
    List<QuizItemResponseRow> responses,
  ) {
    // Snapshot everything the QR payload needs before invalidating —
    // completedStages/student come from the Dashboard's already-loaded
    // stats (the IndexedStack keeps that tab alive, so this is normally
    // already resolved); the quiz attempt just completed hasn't landed in
    // that cache yet, so 'evaluate' is added in explicitly.
    final previousStats = ref.read(_dashboardStatsProvider).valueOrNull;
    final completedAfterEvaluate = {...previousStats?.completedStages ?? const <String>{}, 'evaluate'};
    final completionPct = (completedAfterEvaluate.length / kFiveEStages.length * 100).round();
    final profile = ref.read(studentProfileProvider).valueOrNull ?? StudentProfile.empty;
    final userId =
        previousStats?.student.userId ?? ref.read(currentStudentProvider).valueOrNull?.userId ?? '';
    final labTrials = previousStats?.labTrialsCount ?? 0;
    // Compressed per-item answer string for the QR (see
    // qr_ingest_service.dart's `ans` handling) — built straight from this
    // just-finished attempt's own responses, ordered to match
    // orderQuizItemsByNumber so position i always means "quiz item i+1"
    // on both the generation and ingestion sides.
    final orderedItems = ref.read(activeQuizItemsProvider).valueOrNull ?? const <QuizItemRow>[];
    final ans = _buildAnsString(orderedItems, responses);

    ref.invalidate(_dashboardStatsProvider);
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        var popped = false;
        void popOnce() {
          if (popped || !dialogContext.mounted) return;
          popped = true;
          Navigator.of(dialogContext).pop();
        }

        // Automatically returns to the Dashboard even if the student never
        // taps the button.
        Timer(const Duration(seconds: 4), popOnce);

        return AlertDialog(
          title: const Text('Evaluation complete'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score: $correctCount / $totalCount',
                  style: Theme.of(dialogContext).textTheme.titleLarge,
                ),
                if (outcome != null) ...[
                  const SizedBox(height: 8),
                  Text('+${outcome.pointsAwarded} points'),
                  if (outcome.newlyUnlockedBadges.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'New badge${outcome.newlyUnlockedBadges.length > 1 ? 's' : ''}: '
                      '${outcome.newlyUnlockedBadges.map((b) => b.badgeName).join(', ')}',
                    ),
                  ],
                ],
                const SizedBox(height: 16),
                Center(
                  child: _StudentQrCode(
                    payload: _buildStudentQrPayload(
                      userId: userId,
                      studentId: profile.studentId,
                      sectionPin: profile.sectionPin,
                      quizScore: '$correctCount/$totalCount',
                      ans: ans,
                      labTrials: labTrials,
                      completionPct: completionPct,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Show this to your teacher to record your results.',
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: popOnce,
              child: const Text('Back to Dashboard'),
            ),
          ],
        );
      },
    ).then((_) {
      if (mounted) _goToTab(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(_dashboardStatsProvider);
    final profileAsync = ref.watch(studentProfileProvider);
    final completedStages = statsAsync.valueOrNull?.completedStages ?? const <String>{};
    final profileComplete = profileAsync.valueOrNull?.isComplete ?? false;

    final screens = [
      _DashboardTab(
        statsAsync: statsAsync,
        profileAsync: profileAsync,
        onOpenProfile: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
        onOpenStage: (stageIndex) => _requestStage(stageIndex, completedStages, profileComplete),
        onProfileSaved: () {
          ref.invalidate(studentProfileProvider);
          ref.invalidate(_dashboardStatsProvider);
        },
      ),
      TripTrackerScreen(onContinue: () => _goToTab(2)),
      MotionLabScreen(onSendToGraphVisualizer: () => _goToTab(3)),
      const GraphVisualizerScreen(),
      const MissionModeScreen(),
      EvaluationTerminalScreen(onFinished: _handleEvaluationFinished),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (destinationIndex) {
          if (destinationIndex == 0) {
            _goToTab(0);
            return;
          }
          _requestStage(destinationIndex - 1, completedStages, profileComplete);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Engage',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Explain',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag),
            label: 'Elaborate',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Evaluate',
          ),
        ],
      ),
    );
  }
}

String _stageKey(int stageIndex) => kFiveEStages[stageIndex];

void _showLockedStageDialog(BuildContext context, int stageIndex) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Stage locked'),
      content: SingleChildScrollView(
        child: Text(
          'Finish "${_stageTitles[stageIndex - 1]}" before you can start '
          '"${_stageTitles[stageIndex]}". Stages unlock in order as you '
          'complete each one.',
          style: const TextStyle(height: 1.4),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}

void _showProfileRequiredDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Complete your profile first'),
      content: SingleChildScrollView(
        child: Text(
          'Enter your Section PIN and Student ID on the Dashboard before '
          'starting any stage. This is a one-time local setup — it isn\'t '
          'checked against your teacher\'s roster on this device, but it '
          'travels with your results when you share them later.',
          style: const TextStyle(height: 1.4),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}

/// Builds the compressed local JSON payload carried by the student's QR
/// code — see part (2) of the Teacher Roster Integration notes at the top
/// of this file. Deliberately NOT the full Tier-1 export bundle (that
/// stays file-based via "Share My Results"); this is just enough for
/// QrIngestService to identify the student, file a summary quiz_attempts
/// row, AND (via [ans]) populate real quiz_item_responses rows. [ans] is a
/// 10-character string, one letter per quiz item in
/// [orderQuizItemsByNumber] order (see [_buildAnsString]) — small enough
/// to still fit a single QR frame.
///
/// Deliberately does NOT carry the student's display name — a real device
/// scan test (worst-case name, this app's actual QR sizes) showed name
/// length was the single largest contributor to payload size, pushing the
/// rendered code into a denser QR version than the display size can
/// reliably scan. The teacher side resolves the name from its own roster
/// (matched by studentId/userId — see QrIngestService) instead.
String _buildStudentQrPayload({
  required String userId,
  required String studentId,
  required String sectionPin,
  required String quizScore,
  required String ans,
  required int labTrials,
  required int completionPct,
}) {
  return jsonEncode({
    'userId': userId,
    'studentId': studentId,
    'sectionPin': sectionPin,
    'quizScore': quizScore,
    'ans': ans,
    'labTrials': labTrials,
    'completionPct': completionPct,
    'generatedAt': DateTime.now().toIso8601String(),
  });
}

/// Minimum logical size for the student's QR code, used consistently by
/// every display site (the Dashboard's "Show My QR Code" dialog and the
/// automatic post-Evaluate popup). A real-device scan test measured actual
/// module density at this app's old sizes (160/200px) on a 440dpi phone
/// and found both landed under ~0.5mm/module — too dense to scan reliably
/// screen-to-screen. 220px keeps density meaningfully above that floor;
/// do not shrink below it without re-measuring (see
/// test/presentation/student_qr_code_test.dart).
const kStudentQrDisplaySize = 220.0;

/// Renders [payload] (see [_buildStudentQrPayload]) as a QR code. Always
/// drawn on a white backing regardless of app theme — QR scanners need a
/// light quiet zone and dark-module contrast that a dark-mode background
/// would break.
///
/// Explicitly sized (width/height, not just the inner QrImageView's `size`)
/// so the whole subtree presents a tight width to its AlertDialog ancestor.
/// QrImageView builds a LayoutBuilder internally, and AlertDialog's content
/// sizing queries intrinsic width on its content column — Flutter hard-
/// forbids querying intrinsic dimensions through a LayoutBuilder
/// ("LayoutBuilder does not support returning intrinsic dimensions"),
/// which crashes both dialogs that embed this widget without this fixed
/// size. A widget test caught this (see
/// test/presentation/student_qr_code_test.dart) — there was no prior
/// coverage of either QR dialog actually rendering.
class _StudentQrCode extends StatelessWidget {
  const _StudentQrCode({required this.payload});

  final String payload;

  static const _outerSize = kStudentQrDisplaySize + 24; // + Container's 12px padding per side

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _outerSize,
      height: _outerSize,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: QrImageView(
        data: payload,
        version: QrVersions.auto,
        size: kStudentQrDisplaySize,
        backgroundColor: Colors.white,
      ),
    );
  }
}

/// Full "My QR Code" dialog — used by the Dashboard's persistent button.
/// The Evaluate-stage score dialog embeds [_StudentQrCode] directly instead
/// (see _handleEvaluationFinished) since it already has its own dialog
/// chrome.
void _showQrCodeDialog(
  BuildContext context, {
  required String studentId,
  required String sectionPin,
  required String quizScore,
  required String? ans,
  required int labTrials,
  required int completionPct,
  required String userId,
}) {
  final payload = _buildStudentQrPayload(
    userId: userId,
    studentId: studentId,
    sectionPin: sectionPin,
    quizScore: quizScore,
    ans: ans ?? '',
    labTrials: labTrials,
    completionPct: completionPct,
  );

  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('My QR Code'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StudentQrCode(payload: payload),
            const SizedBox(height: 12),
            Text('Student ID: $studentId', style: Theme.of(dialogContext).textTheme.bodySmall),
            Text('Section PIN: $sectionPin', style: Theme.of(dialogContext).textTheme.bodySmall),
            Text('Quiz score: $quizScore', style: Theme.of(dialogContext).textTheme.bodySmall),
            Text('Lab trials: $labTrials', style: Theme.of(dialogContext).textTheme.bodySmall),
            Text('Completion: $completionPct%', style: Theme.of(dialogContext).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(
              'Show this to your teacher to scan into the Class Roster.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.of(dialogContext).textPrimary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void _showStageInstructions(
  BuildContext context,
  int stageIndex,
  bool isUnlocked,
  void Function(int stageIndex) onOpenStage,
) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('${_stageSubtitles[stageIndex]}: ${_stageTitles[stageIndex]}'),
      content: SingleChildScrollView(
        child: Text(_stageInstructions[stageIndex], style: const TextStyle(height: 1.4)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Close'),
        ),
        if (isUnlocked)
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onOpenStage(stageIndex);
            },
            child: const Text('Go to stage'),
          ),
      ],
    ),
  );
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({
    required this.statsAsync,
    required this.profileAsync,
    required this.onOpenProfile,
    required this.onOpenStage,
    required this.onProfileSaved,
  });

  final AsyncValue<_DashboardStats> statsAsync;
  final AsyncValue<StudentProfile> profileAsync;
  final VoidCallback onOpenProfile;
  final void Function(int stageIndex) onOpenStage;
  final VoidCallback onProfileSaved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhysiX in Motion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.badge_outlined),
            tooltip: 'Profile & Badges',
            onPressed: onOpenProfile,
          ),
        ],
      ),
      body: SafeArea(
        child: statsAsync.when(
          data: (stats) => profileAsync.when(
            data: (profile) => _DashboardBody(
              stats: stats,
              profile: profile,
              onOpenStage: onOpenStage,
              onProfileSaved: onProfileSaved,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Padding(padding: const EdgeInsets.all(24), child: Text('$error')),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(padding: const EdgeInsets.all(24), child: Text('$error')),
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.stats,
    required this.profile,
    required this.onOpenStage,
    required this.onProfileSaved,
  });

  final _DashboardStats stats;
  final StudentProfile profile;
  final void Function(int stageIndex) onOpenStage;
  final VoidCallback onProfileSaved;

  @override
  Widget build(BuildContext context) {
    final progressFraction = stats.completedStages.length / kFiveEStages.length;
    final progressPercent = (progressFraction * 100).round();
    final quizAttempt = stats.latestQuizAttempt;
    final quizScoreLabel = quizAttempt == null
        ? 'Not attempted'
        : '${quizAttempt.totalScore?.toInt() ?? 0} / ${quizAttempt.maxScore?.toInt() ?? 0}';

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome to PhysiX in Motion', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'This portal walks you through Motion in One Dimension using the '
                  '5E lesson plan: predict a race in Trip Tracker, gather your own '
                  'data in Motion Lab, read the graphs in Graph Visualizer, apply '
                  'the kinematic equations in Mission Mode, then prove what you '
                  'know in the Evaluation Terminal. Each stage unlocks the next.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (!profile.isComplete) ...[
          Text('Set up your profile to begin', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Enter the Section PIN and Student ID your teacher gave you. This '
            'is stored locally on this device only — it unlocks Trip Tracker '
            '(Engage) and every stage after it.',
            style: TextStyle(color: AppColors.of(context).textPrimary.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 12),
          _ProfileForm(initialProfile: profile, onSaved: onProfileSaved),
        ] else ...[
          Text('Your progress', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: progressFraction, minHeight: 10),
          ),
          const SizedBox(height: 6),
          Text('$progressPercent% of the 5E lesson complete'),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              _StatTile(label: 'Progress', value: '$progressPercent%', icon: Icons.trending_up),
              _StatTile(
                label: 'Lab trials',
                value: '${stats.labTrialsCount} / 3',
                icon: Icons.science_outlined,
              ),
              _StatTile(label: 'Section PIN', value: profile.sectionPin, icon: Icons.pin_outlined),
              _StatTile(label: 'Student ID', value: profile.studentId, icon: Icons.badge_outlined),
              _StatTile(label: 'Quiz score', value: quizScoreLabel, icon: Icons.quiz_outlined),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const Key('showMyQrCodeButton'),
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Show My QR Code'),
              onPressed: () => _showQrCodeDialog(
                context,
                userId: stats.student.userId,
                studentId: profile.studentId,
                sectionPin: profile.sectionPin,
                quizScore: quizScoreLabel,
                ans: stats.latestAnsString,
                labTrials: stats.labTrialsCount,
                completionPct: progressPercent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showEditProfileDialog(context, profile, onProfileSaved),
              child: const Text('Edit profile'),
            ),
          ),
          const SizedBox(height: 12),
          Text('5E Lesson Plan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (var stageIndex = 0; stageIndex < kFiveEStages.length; stageIndex++)
            _StageCard(
              stageIndex: stageIndex,
              isUnlocked: stageIndex == 0 ||
                  stats.completedStages.contains(_stageKey(stageIndex - 1)),
              isComplete: stats.completedStages.contains(_stageKey(stageIndex)),
              onOpenStage: onOpenStage,
            ),
        ],
      ],
    );
  }
}

void _showEditProfileDialog(
  BuildContext context,
  StudentProfile profile,
  VoidCallback onProfileSaved,
) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Edit profile'),
      content: SingleChildScrollView(
        child: _ProfileForm(initialProfile: profile, onSaved: onProfileSaved, isDialog: true),
      ),
    ),
  );
}

/// Section PIN / Student ID entry form — used both for the Dashboard's
/// initial one-time profile gate and for the "Edit profile" dialog
/// afterward. Purely local: see the Teacher Roster Integration notes near
/// the top of this file for why these values aren't validated against any
/// teacher roster on this device.
class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({
    required this.initialProfile,
    required this.onSaved,
    this.isDialog = false,
  });

  final StudentProfile initialProfile;
  final VoidCallback onSaved;
  final bool isDialog;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  late final _sectionController = TextEditingController(text: widget.initialProfile.sectionPin);
  late final _studentIdController = TextEditingController(text: widget.initialProfile.studentId);
  bool _saving = false;

  @override
  void dispose() {
    _sectionController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _sectionController.text.trim().isNotEmpty && _studentIdController.text.trim().isNotEmpty;

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(appDatabaseProvider);
    await saveStudentProfile(
      db,
      sectionPin: _sectionController.text,
      studentId: _studentIdController.text,
    );
    widget.onSaved();
    if (widget.isDialog && mounted) Navigator.of(context).pop();
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _sectionController,
          decoration: const InputDecoration(labelText: 'Section PIN (e.g. 11-STEM-A)'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _studentIdController,
          decoration: const InputDecoration(labelText: 'Student ID'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSave && !_saving ? _save : null,
            child: Text(widget.isDialog ? 'Save' : 'Save & Continue'),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors.primaryAccent),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.stageIndex,
    required this.isUnlocked,
    required this.isComplete,
    required this.onOpenStage,
  });

  final int stageIndex;
  final bool isUnlocked;
  final bool isComplete;
  final void Function(int stageIndex) onOpenStage;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final Color iconColor;
    final IconData iconData;
    if (isComplete) {
      iconColor = colors.secondaryAccent;
      iconData = Icons.check_circle;
    } else if (isUnlocked) {
      iconColor = colors.primaryAccent;
      iconData = Icons.play_circle_outline;
    } else {
      iconColor = colors.textPrimary.withValues(alpha: 0.4);
      iconData = Icons.lock_outline;
    }

    final String subtitle;
    if (isComplete) {
      subtitle = 'Completed — tap to revisit';
    } else if (isUnlocked) {
      subtitle = 'Unlocked — tap for instructions';
    } else {
      subtitle = 'Locked — finish the previous stage first';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: isUnlocked ? 2 : 0,
      color: isUnlocked ? null : colors.surfaceCard.withValues(alpha: 0.6),
      child: ListTile(
        leading: Icon(iconData, color: iconColor),
        title: Text(
          '${_stageSubtitles[stageIndex]}: ${_stageTitles[stageIndex]}',
          style: TextStyle(
            fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
            color: isUnlocked ? colors.textPrimary : colors.textPrimary.withValues(alpha: 0.5),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: colors.textPrimary.withValues(alpha: isUnlocked ? 0.7 : 0.4)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: colors.textPrimary.withValues(alpha: isUnlocked ? 0.6 : 0.3),
        ),
        onTap: () => _showStageInstructions(context, stageIndex, isUnlocked, onOpenStage),
      ),
    );
  }
}
