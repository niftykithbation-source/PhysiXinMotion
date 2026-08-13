/// Thrown by [SuvatSolver] when a [KinematicsState] can't be solved: too
/// few known variables, or a degenerate/inconsistent combination (e.g.
/// dividing by a zero time, a negative discriminant, or an acceleration of
/// zero that leaves time not uniquely determined).
class KinematicsSolveException implements Exception {
  final String message;

  const KinematicsSolveException(this.message);

  @override
  String toString() => 'KinematicsSolveException: $message';
}
