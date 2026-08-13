import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/content/content_importer.dart';
import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/teacher/dashboard_repository.dart';
import 'package:physix_in_motion/data/teacher/teacher_import_service.dart';

/// Step 6's "done when" (blueprint §7): "importing 3 test export bundles
/// produces correct aggregate numbers, verified by hand." This test builds
/// 3 synthetic bundles with hand-computed expected values (see the comment
/// above each field below) and checks the dashboard's aggregation against
/// them exactly.
void main() {
  late AppDatabase db;
  const packId = 'kinematics_v1';
  const teacherId = 'teacher-1';

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final rawJson = File('assets/content/kinematics_v1.json').readAsStringSync();
    await ContentImporter(db).importIfNeeded(rawJson);
  });

  tearDown(() async {
    await db.close();
  });

  Map<String, dynamic> quizResponse({
    required String id,
    required String attemptId,
    required String itemId,
    required bool correct,
    required int answeredAt,
  }) {
    const correctAnswers = {
      'kinematics_v1_q1': 'C',
      'kinematics_v1_q2': 'C',
      'kinematics_v1_q3': 'C',
      'kinematics_v1_q4': 'C',
      'kinematics_v1_q5': 'B',
      'kinematics_v1_q6': 'B',
      'kinematics_v1_q7': 'C',
      'kinematics_v1_q8': 'B',
      'kinematics_v1_q9': 'A',
      'kinematics_v1_q10': 'A',
    };
    final correctKey = correctAnswers[itemId]!;
    return {
      'responseId': id,
      'attemptId': attemptId,
      'itemId': itemId,
      'givenAnswer': correct ? correctKey : (correctKey == 'A' ? 'B' : 'A'),
      'isCorrect': correct,
      'timeSpentMs': 5000,
      'answeredAt': answeredAt,
    };
  }

  /// Builds one student's posttest quiz_item_responses: all 10 items,
  /// incorrect on exactly the items listed in [incorrectItemNumbers].
  List<Map<String, dynamic>> posttestResponses({
    required String attemptId,
    required Set<int> incorrectItemNumbers,
  }) {
    return [
      for (var i = 1; i <= 10; i++)
        quizResponse(
          id: '$attemptId-r$i',
          attemptId: attemptId,
          itemId: 'kinematics_v1_q$i',
          correct: !incorrectItemNumbers.contains(i),
          answeredAt: 1000 + i,
        ),
    ];
  }

  Map<String, dynamic> bundleFor({
    required String userId,
    required String displayName,
    required String sectionName,
    required bool engageComplete,
    required bool exploreComplete,
    required bool elaborateComplete, // both levels correct
    double? pretestRatio, // out of 10
    required double posttestRatio, // out of 10
    required Set<int> posttestIncorrect,
  }) {
    final posttestScore = (10 - posttestIncorrect.length).toDouble();

    return {
      'user_id': userId,
      'pack_id': packId,
      'generated_at': DateTime.now().toIso8601String(),
      'student': {
        'display_name': displayName,
        'grade_level': 'Grade 11',
        'strand': 'STEM',
        'section_name': sectionName,
      },
      'prediction_log': !engageComplete
          ? []
          : [
              {
                'logId': '$userId-pred1',
                'userId': userId,
                'stageId': 'kinematics_v1_engage',
                'predictedOption': 'habal_habal',
                'reasoningKey': 'is_faster',
                'submittedAt': 1000,
              },
            ],
      'motion_trials': !exploreComplete
          ? []
          : [
              {
                'trialId': '$userId-trial1',
                'userId': userId,
                'groupId': null,
                'trialNumber': 1,
                'distanceM': 8.0,
                'displacementM': 8.0,
                'timeS': 4.0,
                'computedSpeed': 2.0,
                'computedVelocity': 2.0,
                'recordedAt': 1000,
              },
            ],
      'mission_attempts': [
        {
          'attemptId': '$userId-mission1',
          'userId': userId,
          'levelId': 'kinematics_v1_level_1',
          'submittedAnswer': 10.0,
          'isCorrect': true,
          'attemptNumber': 1,
          'pointsAwarded': 20,
          'submittedAt': 1000,
        },
        if (elaborateComplete)
          {
            'attemptId': '$userId-mission2',
            'userId': userId,
            'levelId': 'kinematics_v1_level_2',
            'submittedAnswer': -3.0,
            'isCorrect': true,
            'attemptNumber': 1,
            'pointsAwarded': 20,
            'submittedAt': 1001,
          },
      ],
      'quiz_attempts': [
        if (pretestRatio != null)
          {
            'attemptId': '$userId-pretest',
            'userId': userId,
            'packId': packId,
            'attemptType': 'pretest',
            'startedAt': 900,
            'completedAt': 950,
            'totalScore': pretestRatio,
            'maxScore': 10.0,
          },
        {
          'attemptId': '$userId-posttest',
          'userId': userId,
          'packId': packId,
          'attemptType': 'posttest',
          'startedAt': 1900,
          'completedAt': 1950,
          'totalScore': posttestScore,
          'maxScore': 10.0,
        },
      ],
      'quiz_item_responses': posttestResponses(
        attemptId: '$userId-posttest',
        incorrectItemNumbers: posttestIncorrect,
      ),
      'points_ledger': [
        {
          'entryId': '$userId-points1',
          'userId': userId,
          'sourceType': 'mission_attempt',
          'sourceId': '$userId-mission1',
          'points': 20,
          'createdAt': 1000,
        },
      ],
      'badges_earned': [],
    };
  }

  test('importing 3 bundles produces correct roster and dashboard aggregates', () async {
    // Student A: engage+explore+elaborate complete; pretest 0.3, posttest
    // 0.8 (incorrect q6, q10) -> delta 0.5.
    final bundleA = bundleFor(
      userId: 'student-a',
      displayName: 'Ana Cruz',
      sectionName: 'STEM 11-A',
      engageComplete: true,
      exploreComplete: true,
      elaborateComplete: true,
      pretestRatio: 3.0,
      posttestRatio: 8.0,
      posttestIncorrect: {6, 10},
    );
    // Student B: engage complete only; pretest 0.5, posttest 0.7 (incorrect
    // q3, q7, q10) -> delta 0.2.
    final bundleB = bundleFor(
      userId: 'student-b',
      displayName: 'Ben Reyes',
      sectionName: 'STEM 11-A',
      engageComplete: true,
      exploreComplete: false,
      elaborateComplete: false,
      pretestRatio: 5.0,
      posttestRatio: 7.0,
      posttestIncorrect: {3, 7, 10},
    );
    // Student C: explore+elaborate complete, engage not; no pretest
    // (excluded from pre/post delta); posttest 0.6 (incorrect q2,q5,q8,q10).
    final bundleC = bundleFor(
      userId: 'student-c',
      displayName: 'Cara Santos',
      sectionName: 'STEM 11-B',
      engageComplete: false,
      exploreComplete: true,
      elaborateComplete: true,
      pretestRatio: null,
      posttestRatio: 6.0,
      posttestIncorrect: {2, 5, 8, 10},
    );

    final importer = TeacherImportService(db);
    final resultA = await importer.importBundle(jsonEncode(bundleA), importedByTeacherId: teacherId);
    final resultB = await importer.importBundle(jsonEncode(bundleB), importedByTeacherId: teacherId);
    final resultC = await importer.importBundle(jsonEncode(bundleC), importedByTeacherId: teacherId);

    expect(resultA.studentDisplayName, 'Ana Cruz');
    expect(resultA.quizResponsesImported, 10);
    expect(resultB.missionAttemptsImported, 1);
    expect(resultC.predictionsImported, 0);

    // Roster: 3 students imported.
    final students = await (db.select(db.users)..where((t) => t.role.equals('student'))).get();
    expect(students, hasLength(3));
    final rosterNames = students.map((s) => s.displayName).toSet();
    expect(rosterNames, {'Ana Cruz', 'Ben Reyes', 'Cara Santos'});

    // Sections: STEM 11-A (Ana, Ben) and STEM 11-B (Cara) both created.
    final sections = await (db.select(db.classSections)
          ..where((t) => t.teacherId.equals(teacherId)))
        .get();
    expect(sections.map((s) => s.sectionName).toSet(), {'STEM 11-A', 'STEM 11-B'});

    final metrics = await DashboardRepository(db).computeMetrics();

    expect(metrics.studentCount, 3);

    // Avg pre/post delta: only A (0.5) and B (0.2) qualify (both have a
    // pretest and posttest); C is excluded. (0.5 + 0.2) / 2 = 0.35.
    expect(metrics.avgPrePostDelta, closeTo(0.35, 1e-9));

    // Stage completion: engage 2/3 (A,B), explore 2/3 (A,C), explain 0/3
    // (no module-interaction data in an imported bundle), elaborate 2/3
    // (A,C), evaluate 3/3 (all three have a completed posttest).
    expect(metrics.stageCompletionRates['engage'], closeTo(2 / 3, 1e-9));
    expect(metrics.stageCompletionRates['explore'], closeTo(2 / 3, 1e-9));
    expect(metrics.stageCompletionRates['explain'], closeTo(0, 1e-9));
    expect(metrics.stageCompletionRates['elaborate'], closeTo(2 / 3, 1e-9));
    expect(metrics.stageCompletionRates['evaluate'], closeTo(1.0, 1e-9));

    // Most-missed item: q10 is incorrect for all 3 students (3/3 = 100%),
    // every other item has at most 1 incorrect response — a clean, unique
    // worst item.
    expect(metrics.mostMissedItem?.itemId, 'kinematics_v1_q10');
    expect(metrics.mostMissedItem?.missCount, 3);
    expect(metrics.mostMissedItem?.totalResponses, 3);

    // Re-importing the same bundle is idempotent: no duplicate roster
    // entries or activity rows.
    await importer.importBundle(jsonEncode(bundleA), importedByTeacherId: teacherId);
    final studentsAfterReimport =
        await (db.select(db.users)..where((t) => t.role.equals('student'))).get();
    expect(studentsAfterReimport, hasLength(3));
    final aResponses = await (db.select(db.quizItemResponses)
          ..where((t) => t.attemptId.equals('student-a-posttest')))
        .get();
    expect(aResponses, hasLength(10));
  });
}
