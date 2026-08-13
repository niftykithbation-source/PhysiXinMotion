import 'dart:math' as math;

import 'kinematics_solve_exception.dart';
import 'kinematics_state.dart';

/// Blueprint §7 Step 3.1: given any 3 of `{v0, v, a, t, d}`, solves for the
/// missing 1-2 using the four kinematic equations named in the lesson plan
/// (kinematics_v1.json's `explain` stage):
///
///   eq1: v = v0 + a*t
///   eq2: d = v0*t + 0.5*a*t^2
///   eq3: v^2 = v0^2 + 2*a*d       (algebraic consequence of eq1 + eq2)
///   eq4: d = 0.5*(v0 + v)*t       (algebraic consequence of eq1 + eq2)
///
/// Only eq1 and eq2 are independent, so every case below is solved from
/// those two. Some inputs are physically degenerate (e.g. constant zero
/// acceleration leaves time undetermined, or a quadratic has no real root)
/// — those throw [KinematicsSolveException] rather than guessing.
class SuvatSolver {
  const SuvatSolver._();

  static KinematicsState solve(KinematicsState state) {
    final known = {
      'v0': state.v0,
      'v': state.v,
      'a': state.a,
      't': state.t,
      'd': state.d,
    };
    final missing = known.entries.where((e) => e.value == null).map((e) => e.key).toSet();

    if (missing.length > 2) {
      throw KinematicsSolveException(
        'Need at least 3 known values among {v0, v, a, t, d}; only '
        '${5 - missing.length} given.',
      );
    }

    if (missing.isEmpty) {
      return state;
    }

    if (missing.length == 1) {
      return _solveMissingOne(state, missing.first);
    }

    return _solveMissingTwo(state, missing);
  }

  static KinematicsState _solveMissingOne(KinematicsState s, String missing) {
    switch (missing) {
      case 'v0':
        return KinematicsState(v0: s.v! - s.a! * s.t!, v: s.v, a: s.a, t: s.t, d: s.d);
      case 'v':
        return KinematicsState(v0: s.v0, v: s.v0! + s.a! * s.t!, a: s.a, t: s.t, d: s.d);
      case 'a':
        _requireNonZero(s.t!, 't');
        return KinematicsState(v0: s.v0, v: s.v, a: (s.v! - s.v0!) / s.t!, t: s.t, d: s.d);
      case 't':
        return KinematicsState(v0: s.v0, v: s.v, a: s.a, t: _solveTimeGivenVVAndD(s), d: s.d);
      case 'd':
        return KinematicsState(
          v0: s.v0,
          v: s.v,
          a: s.a,
          t: s.t,
          d: s.v0! * s.t! + 0.5 * s.a! * s.t! * s.t!,
        );
      default:
        throw KinematicsSolveException('Unknown variable: $missing');
    }
  }

  /// Missing t only — v0, v, a, d are all known. Prefers eq1 (linear);
  /// falls back to eq2 when a == 0 (eq1 becomes v == v0, uninformative).
  static double _solveTimeGivenVVAndD(KinematicsState s) {
    if (s.a != 0) {
      return (s.v! - s.v0!) / s.a!;
    }
    if (s.v0 == 0) {
      throw const KinematicsSolveException(
        'Cannot solve for t: acceleration and initial velocity are both '
        'zero, so t is not uniquely determined.',
      );
    }
    return s.d! / s.v0!;
  }

  static KinematicsState _solveMissingTwo(KinematicsState s, Set<String> missing) {
    final key = (missing.toList()..sort()).join(',');
    switch (key) {
      case 'v,v0': // known: a, t, d
        _requireNonZero(s.t!, 't');
        final v0 = (s.d! - 0.5 * s.a! * s.t! * s.t!) / s.t!;
        final v = v0 + s.a! * s.t!;
        return KinematicsState(v0: v0, v: v, a: s.a, t: s.t, d: s.d);

      case 'a,v0': // known: v, t, d
        _requireNonZero(s.t!, 't');
        final v0 = 2 * s.d! / s.t! - s.v!;
        final a = (s.v! - v0) / s.t!;
        return KinematicsState(v0: v0, v: s.v, a: a, t: s.t, d: s.d);

      case 't,v0': // known: v, a, d
        final t = _solveTimeFromVAD(v: s.v!, a: s.a!, d: s.d!);
        final v0 = s.v! - s.a! * t;
        return KinematicsState(v0: v0, v: s.v, a: s.a, t: t, d: s.d);

      case 'd,v0': // known: v, a, t
        final v0 = s.v! - s.a! * s.t!;
        final d = v0 * s.t! + 0.5 * s.a! * s.t! * s.t!;
        return KinematicsState(v0: v0, v: s.v, a: s.a, t: s.t, d: d);

      case 'a,v': // known: v0, t, d
        _requireNonZero(s.t!, 't');
        final a = 2 * (s.d! - s.v0! * s.t!) / (s.t! * s.t!);
        final v = s.v0! + a * s.t!;
        return KinematicsState(v0: s.v0, v: v, a: a, t: s.t, d: s.d);

      case 't,v': // known: v0, a, d
        final vSquared = s.v0! * s.v0! + 2 * s.a! * s.d!;
        if (vSquared < 0) {
          throw const KinematicsSolveException(
            'Cannot solve for v: v0^2 + 2*a*d is negative (no real solution).',
          );
        }
        final magnitude = math.sqrt(vSquared);
        // Convention: assumes motion doesn't reverse direction within the
        // interval, so v takes the sign of v0 (or of a, when v0 is zero).
        final sign = s.v0! != 0 ? s.v0!.sign : (s.a! >= 0 ? 1.0 : -1.0);
        final v = sign * magnitude;
        final t = _solveTimeGivenVVAndD(KinematicsState(v0: s.v0, v: v, a: s.a, d: s.d));
        return KinematicsState(v0: s.v0, v: v, a: s.a, t: t, d: s.d);

      case 'd,v': // known: v0, a, t
        final v = s.v0! + s.a! * s.t!;
        final d = s.v0! * s.t! + 0.5 * s.a! * s.t! * s.t!;
        return KinematicsState(v0: s.v0, v: v, a: s.a, t: s.t, d: d);

      case 'a,t': // known: v0, v, d
        final sum = s.v0! + s.v!;
        if (sum == 0) {
          if (s.d != 0) {
            throw const KinematicsSolveException(
              'Cannot solve for a and t: v0 + v is zero but d is non-zero '
              '(inconsistent inputs).',
            );
          }
          throw const KinematicsSolveException(
            'Cannot solve for a and t: v0 + v is zero, so t is not uniquely '
            'determined.',
          );
        }
        final t = 2 * s.d! / sum;
        final a = (s.v! - s.v0!) / t;
        return KinematicsState(v0: s.v0, v: s.v, a: a, t: t, d: s.d);

      case 'd,t': // known: v0, v, a
        if (s.a == 0) {
          if (s.v != s.v0) {
            throw const KinematicsSolveException(
              'Cannot solve for t and d: acceleration is zero but v != v0 '
              '(inconsistent inputs).',
            );
          }
          throw const KinematicsSolveException(
            'Cannot solve for t and d: acceleration is zero, so t is not '
            'uniquely determined.',
          );
        }
        final t = (s.v! - s.v0!) / s.a!;
        final d = 0.5 * (s.v0! + s.v!) * t;
        return KinematicsState(v0: s.v0, v: s.v, a: s.a, t: t, d: d);

      case 'a,d': // known: v0, v, t
        _requireNonZero(s.t!, 't');
        final a = (s.v! - s.v0!) / s.t!;
        final d = 0.5 * (s.v0! + s.v!) * s.t!;
        return KinematicsState(v0: s.v0, v: s.v, a: a, t: s.t, d: d);

      default:
        throw KinematicsSolveException('Unsupported missing-variable combination: $key');
    }
  }

  /// Solves 0.5*a*t^2 - v*t + d = 0 for t (used when v0 and t are both
  /// missing, so v, a, d are the knowns). Picks the smaller non-negative
  /// root as the physically meaningful "first time" solution.
  static double _solveTimeFromVAD({required double v, required double a, required double d}) {
    if (a == 0) {
      if (v == 0) {
        if (d != 0) {
          throw const KinematicsSolveException(
            'Cannot solve for t: acceleration and velocity are both zero '
            'but d is non-zero (inconsistent inputs).',
          );
        }
        throw const KinematicsSolveException(
          'Cannot solve for t: acceleration and velocity are both zero, so '
          't is not uniquely determined.',
        );
      }
      return d / v;
    }

    final discriminant = v * v - 2 * a * d;
    if (discriminant < 0) {
      throw const KinematicsSolveException(
        'Cannot solve for t: no real solution (discriminant is negative).',
      );
    }
    final sqrtDisc = math.sqrt(discriminant);
    final candidates = [(v + sqrtDisc) / a, (v - sqrtDisc) / a].where((t) => t >= 0).toList()
      ..sort();
    if (candidates.isEmpty) {
      throw const KinematicsSolveException(
        'Cannot solve for t: no non-negative time solution exists.',
      );
    }
    return candidates.first;
  }

  static void _requireNonZero(double value, String name) {
    if (value == 0) {
      throw KinematicsSolveException(
        'Cannot solve: $name is zero, which makes this system unsolvable '
        'with the given knowns.',
      );
    }
  }
}
