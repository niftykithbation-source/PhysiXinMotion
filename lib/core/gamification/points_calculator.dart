// Blueprint §7 Step 4.2 point values. Not specified numerically anywhere in
// the blueprint/thesis content — chosen as simple, easily-tunable
// defaults. Change these constants if the thesis defines specific values.

const kPointsPerCorrectQuizItem = 10;
const kPointsForFirstTryMissionCorrect = 20;
const kPointsForRetryMissionCorrect = 10;

int pointsForQuizAttempt({required int correctCount}) {
  return correctCount * kPointsPerCorrectQuizItem;
}

int pointsForMissionAttempt({required bool isCorrect, required int attemptNumber}) {
  if (!isCorrect) return 0;
  return attemptNumber <= 1 ? kPointsForFirstTryMissionCorrect : kPointsForRetryMissionCorrect;
}
