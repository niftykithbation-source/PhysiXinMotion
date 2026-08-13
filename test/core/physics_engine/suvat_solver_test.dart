import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/physics_engine/kinematics_solve_exception.dart';
import 'package:physix_in_motion/core/physics_engine/kinematics_state.dart';
import 'package:physix_in_motion/core/physics_engine/suvat_solver.dart';

/// Single consistent reference motion used across every "missing 1 or 2"
/// case below, so expected values are easy to verify by hand:
///   v0 = 10, v = 20, a = 2, t = 5, d = 75
/// (v = v0 + a*t = 10 + 10 = 20; d = v0*t + 0.5*a*t^2 = 50 + 25 = 75.)
void main() {
  group('SuvatSolver — missing exactly 1 of 5', () {
    test('solves v0 given v, a, t, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v: 20, a: 2, t: 5, d: 75));
      expect(r.v0, closeTo(10, 1e-9));
    });

    test('solves v given v0, a, t, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, a: 2, t: 5, d: 75));
      expect(r.v, closeTo(20, 1e-9));
    });

    test('solves a given v0, v, t, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, v: 20, t: 5, d: 75));
      expect(r.a, closeTo(2, 1e-9));
    });

    test('solves t given v0, v, a, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, v: 20, a: 2, d: 75));
      expect(r.t, closeTo(5, 1e-9));
    });

    test('solves d given v0, v, a, t', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, v: 20, a: 2, t: 5));
      expect(r.d, closeTo(75, 1e-9));
    });
  });

  group('SuvatSolver — missing exactly 2 of 5', () {
    test('solves {v0, v} given a, t, d', () {
      final r = SuvatSolver.solve(const KinematicsState(a: 2, t: 5, d: 75));
      expect(r.v0, closeTo(10, 1e-9));
      expect(r.v, closeTo(20, 1e-9));
    });

    test('solves {v0, a} given v, t, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v: 20, t: 5, d: 75));
      expect(r.v0, closeTo(10, 1e-9));
      expect(r.a, closeTo(2, 1e-9));
    });

    test('solves {v0, t} given v, a, d (picks the smaller positive root)', () {
      final r = SuvatSolver.solve(const KinematicsState(v: 20, a: 2, d: 75));
      expect(r.t, closeTo(5, 1e-9));
      expect(r.v0, closeTo(10, 1e-9));
    });

    test('solves {v0, d} given v, a, t', () {
      final r = SuvatSolver.solve(const KinematicsState(v: 20, a: 2, t: 5));
      expect(r.v0, closeTo(10, 1e-9));
      expect(r.d, closeTo(75, 1e-9));
    });

    test('solves {v, a} given v0, t, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, t: 5, d: 75));
      expect(r.v, closeTo(20, 1e-9));
      expect(r.a, closeTo(2, 1e-9));
    });

    test('solves {v, t} given v0, a, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, a: 2, d: 75));
      expect(r.v, closeTo(20, 1e-9));
      expect(r.t, closeTo(5, 1e-9));
    });

    test('solves {v, t} sign convention from a when v0 == 0', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 0, a: 2, d: 8));
      expect(r.v, closeTo(4 * 1.4142135623730951, 1e-9)); // sqrt(2*a*d) = sqrt(32)
      expect(r.t, closeTo(r.v! / 2, 1e-9)); // v = a*t since v0 == 0
    });

    test('solves {v, d} given v0, a, t', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, a: 2, t: 5));
      expect(r.v, closeTo(20, 1e-9));
      expect(r.d, closeTo(75, 1e-9));
    });

    test('solves {a, t} given v0, v, d', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, v: 20, d: 75));
      expect(r.a, closeTo(2, 1e-9));
      expect(r.t, closeTo(5, 1e-9));
    });

    test('solves {a, d} given v0, v, t', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, v: 20, t: 5));
      expect(r.a, closeTo(2, 1e-9));
      expect(r.d, closeTo(75, 1e-9));
    });

    test('solves {t, d} given v0, v, a', () {
      final r = SuvatSolver.solve(const KinematicsState(v0: 10, v: 20, a: 2));
      expect(r.t, closeTo(5, 1e-9));
      expect(r.d, closeTo(75, 1e-9));
    });
  });

  group('SuvatSolver — edge cases', () {
    test('returns the state unchanged when all 5 are already known', () {
      const full = KinematicsState(v0: 10, v: 20, a: 2, t: 5, d: 75);
      final r = SuvatSolver.solve(full);
      expect(r.v0, 10);
      expect(r.v, 20);
      expect(r.a, 2);
      expect(r.t, 5);
      expect(r.d, 75);
    });

    test('throws when fewer than 3 variables are known', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v0: 10, v: 20)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });

    test('throws solving for a when t is zero', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v0: 10, v: 20, t: 0, d: 0)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });

    test('throws solving {a, t} when v0 + v == 0 but d != 0 (inconsistent)', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v0: 5, v: -5, d: 10)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });

    test('throws solving {a, t} when v0 + v == 0 and d == 0 (indeterminate)', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v0: 5, v: -5, d: 0)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });

    test('throws solving {t, d} when a == 0 and v != v0 (inconsistent)', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v0: 10, v: 12, a: 0)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });

    test('throws solving {t, d} when a == 0 and v == v0 (indeterminate)', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v0: 10, v: 10, a: 0)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });

    test('throws solving {v, t} when v0^2 + 2*a*d is negative (no real solution)', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v0: 0, a: -2, d: 10)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });

    test('throws solving {v0, t} when v == 0 and a == 0 but d != 0 (inconsistent)', () {
      expect(
        () => SuvatSolver.solve(const KinematicsState(v: 0, a: 0, d: 5)),
        throwsA(isA<KinematicsSolveException>()),
      );
    });
  });
}
