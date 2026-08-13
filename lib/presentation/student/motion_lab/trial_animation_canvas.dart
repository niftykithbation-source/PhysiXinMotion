import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/db/database.dart';

/// Renders live motion for [trial] using a real [AnimationController] /
/// [Ticker] (via [SingleTickerProviderStateMixin]) — not a static drawing.
/// Position at each frame is interpolated directly from the trial's own
/// recorded displacement/time (the physics engine's computeSpeedVelocity
/// output for this trial is a constant-velocity motion, so position(t) =
/// velocity * t is exact, not an approximation).
///
/// Give this widget a new [Key] (trial changes, or a replay counter) to
/// force a fresh play-through — see motion_lab_screen.dart.
class TrialAnimationCanvas extends StatefulWidget {
  const TrialAnimationCanvas({super.key, required this.trial});

  final MotionTrialRow trial;

  @override
  State<TrialAnimationCanvas> createState() => _TrialAnimationCanvasState();
}

class _TrialAnimationCanvasState extends State<TrialAnimationCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// Real playback duration is clamped for a watchable demo — the true
  /// recorded time_s is still shown as a live readout during playback.
  static const _minPlaybackSeconds = 1.2;
  static const _maxPlaybackSeconds = 6.0;

  @override
  void initState() {
    super.initState();
    final playbackSeconds = widget.trial.timeS.clamp(_minPlaybackSeconds, _maxPlaybackSeconds);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (playbackSeconds * 1000).round()),
    )..forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final trial = widget.trial;
    final direction = trial.displacementM < 0 ? -1 : 1;

    // Excluded from semantics: this readout updates every animation frame,
    // which would spam a screen reader with rapid re-announcements. The
    // same values are already available as static text in the trial list
    // below, so nothing is lost.
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final fraction = _controller.value;
          final elapsedS = fraction * trial.timeS;
          final positionM = fraction * trial.displacementM;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  const markerDiameter = 28.0;
                  final trackWidth = constraints.maxWidth - markerDiameter;
                  final x = trackWidth * fraction;
                  return SizedBox(
                    height: 48,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 22,
                          child: Container(height: 3, color: colors.surfaceCard),
                        ),
                        Positioned(
                          left: x,
                          top: 4,
                          child: Transform.flip(
                            flipX: direction < 0,
                            child: Icon(
                              Icons.directions_walk,
                              color: colors.primaryAccent,
                              size: markerDiameter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              Text(
                't = ${elapsedS.toStringAsFixed(1)} s   d = ${positionM.toStringAsFixed(1)} m'
                '   v = ${(trial.computedVelocity ?? 0).toStringAsFixed(2)} m/s',
                style: TextStyle(
                  color: colors.textPrimary.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
