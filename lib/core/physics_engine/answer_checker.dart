// Blueprint §7 Step 3.2. Pure functions, no Flutter imports.

/// True if [given] is within [tolerance] of [correct] (inclusive).
bool checkNumericAnswer(double given, double correct, double tolerance) {
  return (given - correct).abs() <= tolerance;
}

/// True if [given] (the student's chosen choice key) matches [correctKey].
bool checkMcqAnswer(String given, String correctKey) {
  return given == correctKey;
}
