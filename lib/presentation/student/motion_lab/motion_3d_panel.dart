import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

import '../../../core/theme/app_colors.dart';

/// Motion Lab — interactive 3D kinematic trajectory simulator.
///
/// This is a "pseudo-3D" renderer: world-space points are pushed through a
/// hand-rolled pinhole [_OrbitCamera] and drawn with [CustomPainter] onto a
/// normal 2D canvas — there's no WebGL/GPU 3D engine involved (three_js is
/// JavaScript-only and cannot run in native Flutter; no such Flutter engine
/// is in CLAUDE.md's locked tech stack). `vector_math` supplies the Vector3
/// math only — it was already resolved transitively via fl_chart and is
/// now a direct pubspec dependency for that reason. This keeps the low-spec
/// performance target (blueprint §7 Step 8, 2GB RAM / Android 8) realistic:
/// each frame draws a couple dozen line segments and one small path, which
/// is far cheaper than a real 3D rasterizer.
///
/// Purely a supplementary visualization driven by the sliders below — it
/// does not read or write `motion_trials`. The "Walk the Line" recorded
/// trials above stay the source of truth for Explore-stage completion and
/// for the Graph Visualizer.
class Motion3DPanel extends StatefulWidget {
  const Motion3DPanel({super.key});

  @override
  State<Motion3DPanel> createState() => _Motion3DPanelState();
}

class _Motion3DPanelState extends State<Motion3DPanel> with SingleTickerProviderStateMixin {
  // Orbit camera state (radians for yaw/pitch, world units for distance).
  double _yaw = -0.6;
  double _pitch = 0.35;
  double _distance = 16;
  double _distanceAtGestureStart = 16;
  Offset _panOffset = Offset.zero;

  // Kinematic inputs, one slider per axis.
  double _v0x = 4, _v0y = 3, _v0z = 2;
  double _ax = 0, _ay = -1.2, _az = 0;

  static const double _durationSeconds = 4;
  static const int _trajectorySamples = 40;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_durationSeconds * 1000).round()),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Vector3 _displacementAt(double t) => Vector3(
        _v0x * t + 0.5 * _ax * t * t,
        _v0y * t + 0.5 * _ay * t * t,
        _v0z * t + 0.5 * _az * t * t,
      );

  Vector3 _velocityAt(double t) => Vector3(
        _v0x + _ax * t,
        _v0y + _ay * t,
        _v0z + _az * t,
      );

  void _togglePlay() {
    setState(() {
      if (_controller.isAnimating) {
        _controller.stop();
      } else {
        if (_controller.isCompleted) _controller.reset();
        _controller.forward();
      }
    });
  }

  void _resetPlayback() {
    setState(() => _controller.reset());
  }

  void _resetCamera() {
    setState(() {
      _yaw = -0.6;
      _pitch = 0.35;
      _distance = 16;
      _panOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final t = _controller.value * _durationSeconds;
    final position = _displacementAt(t);
    final velocity = _velocityAt(t);
    final camera = _OrbitCamera.orbit(yaw: _yaw, pitch: _pitch, distance: _distance);
    final trajectory = [
      for (var i = 0; i <= _trajectorySamples; i++)
        _displacementAt(i * _durationSeconds / _trajectorySamples),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('3D Trajectory Simulation', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Drag with one finger to orbit, two fingers to pan, pinch to zoom.',
          style: TextStyle(color: colors.textPrimary.withValues(alpha: 0.6), fontSize: 12),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 260,
            color: colors.surfaceCard,
            child: GestureDetector(
              onScaleStart: (_) => _distanceAtGestureStart = _distance,
              onScaleUpdate: (details) => setState(() {
                if (details.pointerCount <= 1) {
                  _yaw += details.focalPointDelta.dx * 0.01;
                  _pitch = (_pitch - details.focalPointDelta.dy * 0.01).clamp(-1.4, 1.4);
                } else {
                  _panOffset += details.focalPointDelta;
                  _distance = (_distanceAtGestureStart / details.scale).clamp(6, 40);
                }
              }),
              child: CustomPaint(
                size: Size.infinite,
                painter: _TrajectoryPainter(
                  camera: camera,
                  panOffset: _panOffset,
                  trajectory: trajectory,
                  currentPosition: position,
                  currentVelocity: velocity,
                  colors: colors,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: Icon(_controller.isAnimating ? Icons.pause_circle : Icons.play_circle),
              tooltip: _controller.isAnimating ? 'Pause' : 'Play',
              onPressed: _togglePlay,
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              tooltip: 'Reset playback',
              onPressed: _resetPlayback,
            ),
            IconButton(
              icon: const Icon(Icons.center_focus_strong),
              tooltip: 'Reset camera',
              onPressed: _resetCamera,
            ),
            const Spacer(),
            Text('t = ${t.toStringAsFixed(1)} s', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        Text(
          'Displacement: ${position.length.toStringAsFixed(2)} m'
          '   ·   Velocity: ${velocity.length.toStringAsFixed(2)} m/s',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        Text('Initial velocity (m/s)', style: Theme.of(context).textTheme.labelLarge),
        _AxisSlider(label: 'v0x', value: _v0x, min: -8, max: 8, onChanged: (v) => setState(() => _v0x = v)),
        _AxisSlider(label: 'v0y', value: _v0y, min: -8, max: 8, onChanged: (v) => setState(() => _v0y = v)),
        _AxisSlider(label: 'v0z', value: _v0z, min: -8, max: 8, onChanged: (v) => setState(() => _v0z = v)),
        const SizedBox(height: 8),
        Text('Acceleration (m/s²)', style: Theme.of(context).textTheme.labelLarge),
        _AxisSlider(label: 'ax', value: _ax, min: -4, max: 4, onChanged: (v) => setState(() => _ax = v)),
        _AxisSlider(label: 'ay', value: _ay, min: -4, max: 4, onChanged: (v) => setState(() => _ay = v)),
        _AxisSlider(label: 'az', value: _az, min: -4, max: 4, onChanged: (v) => setState(() => _az = v)),
      ],
    );
  }
}

class _AxisSlider extends StatelessWidget {
  const _AxisSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 32, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(value.toStringAsFixed(1), textAlign: TextAlign.end),
        ),
      ],
    );
  }
}

/// A minimal orbit pinhole camera: [orbit] places the eye on a sphere of
/// radius [distance] around the world origin at the given [yaw]/[pitch],
/// looking back at the origin. [project] transforms a world point into
/// camera space and applies a simple perspective divide by depth.
class _OrbitCamera {
  const _OrbitCamera({
    required this.eye,
    required this.right,
    required this.up,
    required this.forward,
  });

  final Vector3 eye;
  final Vector3 right;
  final Vector3 up;
  final Vector3 forward;

  static const double focalLength = 260;

  factory _OrbitCamera.orbit({
    required double yaw,
    required double pitch,
    required double distance,
  }) {
    final eye = Vector3(
      distance * math.cos(pitch) * math.sin(yaw),
      distance * math.sin(pitch),
      distance * math.cos(pitch) * math.cos(yaw),
    );
    final forward = (-eye).normalized();
    final worldUp = Vector3(0, 1, 0);
    final right = forward.cross(worldUp).normalized();
    final up = right.cross(forward).normalized();
    return _OrbitCamera(eye: eye, right: right, up: up, forward: forward);
  }

  /// Returns null when [world] is behind the camera (nothing sane to draw).
  ({Offset offset, double depthScale})? project(Vector3 world, Size canvasSize) {
    final rel = world - eye;
    final camX = rel.dot(right);
    final camY = rel.dot(up);
    final camZ = rel.dot(forward);
    if (camZ <= 0.5) return null;

    final scale = focalLength / camZ;
    final dx = canvasSize.width / 2 + camX * scale;
    final dy = canvasSize.height / 2 - camY * scale;
    return (offset: Offset(dx, dy), depthScale: scale);
  }
}

class _TrajectoryPainter extends CustomPainter {
  const _TrajectoryPainter({
    required this.camera,
    required this.panOffset,
    required this.trajectory,
    required this.currentPosition,
    required this.currentVelocity,
    required this.colors,
  });

  final _OrbitCamera camera;
  final Offset panOffset;
  final List<Vector3> trajectory;
  final Vector3 currentPosition;
  final Vector3 currentVelocity;
  final AppColors colors;

  static const double _gridExtent = 6;
  static const double _axisLength = 8;

  @override
  void paint(Canvas canvas, Size size) {
    Offset? project(Vector3 world) {
      final result = camera.project(world, size);
      if (result == null) return null;
      return result.offset + panOffset;
    }

    _paintGrid(canvas, project);
    _paintAxes(canvas, project);
    _paintTrajectory(canvas, project);
    _paintCurrentPosition(canvas, size);
    _paintVelocityArrow(canvas, project);
  }

  void _paintGrid(Canvas canvas, Offset? Function(Vector3) project) {
    final gridPaint = Paint()
      ..color = colors.textPrimary.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var i = -_gridExtent; i <= _gridExtent; i += 2) {
      final a = project(Vector3(i, 0, -_gridExtent));
      final b = project(Vector3(i, 0, _gridExtent));
      if (a != null && b != null) canvas.drawLine(a, b, gridPaint);

      final c = project(Vector3(-_gridExtent, 0, i));
      final d = project(Vector3(_gridExtent, 0, i));
      if (c != null && d != null) canvas.drawLine(c, d, gridPaint);
    }
  }

  void _paintAxes(Canvas canvas, Offset? Function(Vector3) project) {
    final origin = project(Vector3.zero());
    if (origin == null) return;

    void axis(Vector3 end, Color color, String label) {
      final endPoint = project(end);
      if (endPoint == null) return;
      canvas.drawLine(origin, endPoint, Paint()..color = color..strokeWidth = 2);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, endPoint - Offset(tp.width / 2, tp.height / 2));
    }

    axis(Vector3(_axisLength, 0, 0), Colors.redAccent, 'X');
    axis(Vector3(0, _axisLength, 0), Colors.greenAccent.shade700, 'Y');
    axis(Vector3(0, 0, _axisLength), Colors.blueAccent, 'Z');
  }

  void _paintTrajectory(Canvas canvas, Offset? Function(Vector3) project) {
    final paint = Paint()
      ..color = colors.primaryAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    Offset? previous;
    for (final point in trajectory) {
      final projected = project(point);
      if (previous != null && projected != null) {
        canvas.drawLine(previous, projected, paint);
      }
      previous = projected;
    }
  }

  void _paintCurrentPosition(Canvas canvas, Size size) {
    final result = camera.project(currentPosition, size);
    if (result == null) return;
    final offset = result.offset + panOffset;
    final radius = (result.depthScale * 0.04).clamp(3.0, 16.0);
    canvas.drawCircle(offset, radius, Paint()..color = colors.secondaryAccent);
  }

  void _paintVelocityArrow(Canvas canvas, Offset? Function(Vector3) project) {
    if (currentVelocity.length < 0.01) return;
    final tip = currentPosition + currentVelocity.normalized() * 2.5;
    final start = project(currentPosition);
    final end = project(tip);
    if (start == null || end == null) return;

    final arrowPaint = Paint()
      ..color = colors.secondaryAccent
      ..strokeWidth = 3;
    canvas.drawLine(start, end, arrowPaint);

    final direction = end - start;
    final length = direction.distance;
    if (length < 1) return;
    final unit = direction / length;
    final normal = Offset(-unit.dy, unit.dx);
    canvas.drawLine(end, end - unit * 8 + normal * 5, arrowPaint);
    canvas.drawLine(end, end - unit * 8 - normal * 5, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant _TrajectoryPainter oldDelegate) => true;
}
