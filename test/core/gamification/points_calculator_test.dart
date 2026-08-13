import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/gamification/points_calculator.dart';

void main() {
  group('pointsForQuizAttempt', () {
    test('scales linearly with correct answers', () {
      expect(pointsForQuizAttempt(correctCount: 0), 0);
      expect(pointsForQuizAttempt(correctCount: 8), 8 * kPointsPerCorrectQuizItem);
      expect(pointsForQuizAttempt(correctCount: 10), 10 * kPointsPerCorrectQuizItem);
    });
  });

  group('pointsForMissionAttempt', () {
    test('awards 0 for an incorrect attempt regardless of attempt number', () {
      expect(pointsForMissionAttempt(isCorrect: false, attemptNumber: 1), 0);
      expect(pointsForMissionAttempt(isCorrect: false, attemptNumber: 3), 0);
    });

    test('awards the first-try bonus on attempt 1', () {
      expect(
        pointsForMissionAttempt(isCorrect: true, attemptNumber: 1),
        kPointsForFirstTryMissionCorrect,
      );
    });

    test('awards the lower retry amount on attempt 2+', () {
      expect(
        pointsForMissionAttempt(isCorrect: true, attemptNumber: 2),
        kPointsForRetryMissionCorrect,
      );
      expect(
        pointsForMissionAttempt(isCorrect: true, attemptNumber: 5),
        kPointsForRetryMissionCorrect,
      );
    });
  });
}
