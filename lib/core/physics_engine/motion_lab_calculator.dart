/// Blueprint §7 Step 3.3: Motion Lab (Explore) auto-calculation.
///
/// [distanceM] is total path length (always >= 0); [displacementM] is the
/// signed straight-line change in position; [timeS] is elapsed time (> 0).
/// Speed is always non-negative; velocity carries [displacementM]'s sign.
({double speed, double velocity}) computeSpeedVelocity({
  required double distanceM,
  required double displacementM,
  required double timeS,
}) {
  if (timeS <= 0) {
    throw ArgumentError.value(timeS, 'timeS', 'must be greater than zero');
  }
  if (distanceM < 0) {
    throw ArgumentError.value(distanceM, 'distanceM', 'must not be negative');
  }
  return (speed: distanceM / timeS, velocity: displacementM / timeS);
}
