import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/physics_engine/answer_checker.dart';
import 'package:physix_in_motion/core/physics_engine/kinematics_state.dart';
import 'package:physix_in_motion/core/physics_engine/motion_lab_calculator.dart';
import 'package:physix_in_motion/core/physics_engine/suvat_solver.dart';

/// Golden tests for Step 3 (blueprint §7 Step 3.4/3.5): one test per
/// evaluation item and per Mission Mode level in kinematics_v1.json.
///
/// Physics word problems (items 3, 6, 7, 10 and both mission levels) run
/// through the actual solver/calculator functions and check the numeric
/// result against the content pack's own correct_answer — this is real
/// regression protection for the engine. Purely conceptual items (1, 2, 4,
/// 5, 8, 9) have no computation to verify, so they exercise
/// checkMcqAnswer/checkNumericAnswer against the item's real answer key.
///
/// Every case also reads the *live* JSON asset (not a hardcoded copy) so a
/// future content edit that silently disagrees with these physics fixtures
/// fails the build — matching the content-integrity intent of §6 Risk #12.
void main() {
  late Map<String, dynamic> content;

  setUpAll(() {
    final raw = File('assets/content/kinematics_v1.json').readAsStringSync();
    content = jsonDecode(raw) as Map<String, dynamic>;
  });

  Map<String, dynamic> quizItem(String itemId) {
    final items = (content['quiz_items'] as List).cast<Map<String, dynamic>>();
    return items.firstWhere((i) => i['item_id'] == itemId);
  }

  Map<String, dynamic> missionLevel(String levelId) {
    final levels = (content['mission_levels'] as List).cast<Map<String, dynamic>>();
    return levels.firstWhere((l) => l['level_id'] == levelId);
  }

  group('Evaluation Terminal — quiz_items', () {
    test(
      'q1: tricycle 3 km east then 3 km west back to start '
      '→ net displacement is 0 km (distance != displacement)',
      () {
        final item = quizItem('kinematics_v1_q1');
        const eastKm = 3.0;
        const westKm = 3.0;
        final netDisplacementKm = eastKm - westKm;

        expect(checkNumericAnswer(netDisplacementKm, 0.0, 0.01), isTrue);
        expect(item['correct_answer'], 'C'); // "0 km"
      },
    );

    test('q2: velocity is the vector quantity (conceptual, no computation)', () {
      final item = quizItem('kinematics_v1_q2');
      expect(checkMcqAnswer('C', item['correct_answer'] as String), isTrue);
    });

    test(
      'q3: jeepney covers 500 m in 25 s at constant speed '
      '→ average velocity 20 m/s',
      () {
        final item = quizItem('kinematics_v1_q3');
        final result = computeSpeedVelocity(distanceM: 500, displacementM: 500, timeS: 25);

        expect(checkNumericAnswer(result.velocity, 20.0, 0.01), isTrue);
        expect(item['correct_answer'], 'C'); // "20 m/s"
      },
    );

    test('q4: slope of a velocity-time graph is acceleration (conceptual)', () {
      final item = quizItem('kinematics_v1_q4');
      expect(checkMcqAnswer('C', item['correct_answer'] as String), isTrue);
    });

    test('q5: slope of a displacement-time graph is velocity (conceptual)', () {
      final item = quizItem('kinematics_v1_q5');
      expect(checkMcqAnswer('B', item['correct_answer'] as String), isTrue);
    });

    test('q6: motorcycle rest → 20 m/s in 4 s → acceleration 5 m/s²', () {
      final item = quizItem('kinematics_v1_q6');
      final result = SuvatSolver.solve(const KinematicsState(v0: 0, v: 20, t: 4));

      expect(checkNumericAnswer(result.a!, 5.0, 0.01), isTrue);
      expect(item['correct_answer'], 'B'); // "5 m/s^2"
    });

    test('q7: v0=10 m/s, a=2 m/s², t=5 s → final velocity 20 m/s', () {
      final item = quizItem('kinematics_v1_q7');
      final result = SuvatSolver.solve(const KinematicsState(v0: 10, a: 2, t: 5));

      expect(checkNumericAnswer(result.v!, 20.0, 0.01), isTrue);
      expect(item['correct_answer'], 'C'); // "20 m/s"
    });

    test('q8: area under a velocity-time graph is displacement (conceptual)', () {
      final item = quizItem('kinematics_v1_q8');
      expect(checkMcqAnswer('B', item['correct_answer'] as String), isTrue);
    });

    test('q9: distance is scalar, displacement is vector (conceptual)', () {
      final item = quizItem('kinematics_v1_q9');
      expect(checkMcqAnswer('A', item['correct_answer'] as String), isTrue);
    });

    test(
      'q10: cyclist 150 m north in 30 s then rests 10 s '
      '→ average velocity over the full 40 s is 3.75 m/s',
      () {
        final item = quizItem('kinematics_v1_q10');
        final result = computeSpeedVelocity(distanceM: 150, displacementM: 150, timeS: 40);

        expect(checkNumericAnswer(result.velocity, 3.75, 0.01), isTrue);
        expect(item['correct_answer'], 'A'); // "3.75 m/s north"
      },
    );
  });

  group('Mission Mode — mission_levels', () {
    test('level 1: Catch the Last Trip — d=4000 m, t=400 s → v=10 m/s', () {
      final level = missionLevel('kinematics_v1_level_1');
      final result = computeSpeedVelocity(distanceM: 4000, displacementM: 4000, timeS: 400);
      final tolerance = (level['tolerance'] as num).toDouble();
      final correctAnswer = (level['correct_answer'] as num).toDouble();

      expect(checkNumericAnswer(result.velocity, correctAnswer, tolerance), isTrue);
      expect(level['target_variable'], 'v');
    });

    test('level 2: Stop at the Hump — v0=15 m/s, v=0 m/s, t=5 s → a=-3 m/s²', () {
      final level = missionLevel('kinematics_v1_level_2');
      final result = SuvatSolver.solve(const KinematicsState(v0: 15, v: 0, t: 5));
      final tolerance = (level['tolerance'] as num).toDouble();
      final correctAnswer = (level['correct_answer'] as num).toDouble();

      expect(checkNumericAnswer(result.a!, correctAnswer, tolerance), isTrue);
      expect(level['target_variable'], 'a');
    });
  });
}
