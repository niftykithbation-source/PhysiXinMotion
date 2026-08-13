/// The five kinematic variables from the SUVAT equations named in the
/// lesson plan (blueprint §7 Step 3): initial velocity [v0], final velocity
/// [v], acceleration [a], time [t], and displacement [d]. Any field may be
/// null to represent an unknown to be solved for.
///
/// Pure Dart, no Flutter imports — this is the physics engine, not UI.
class KinematicsState {
  final double? v0;
  final double? v;
  final double? a;
  final double? t;
  final double? d;

  const KinematicsState({this.v0, this.v, this.a, this.t, this.d});

  @override
  String toString() => 'KinematicsState(v0: $v0, v: $v, a: $a, t: $t, d: $d)';
}
