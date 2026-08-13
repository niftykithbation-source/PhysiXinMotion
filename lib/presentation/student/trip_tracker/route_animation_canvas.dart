import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Trip Tracker (Engage) intro animation, per blueprint §3.3: "animation...
/// of habal-habal vs. jeepney on a route" — driven by a real
/// [AnimationController] / [Ticker] (via [SingleTickerProviderStateMixin]),
/// not a static drawing. Both vehicles finish together; the animation only
/// illustrates the two routes described in the scenario (habal-habal:
/// short, direct; jeepney: longer, winding) — it doesn't resolve "which
/// arrives first", since that's the open prediction the student makes next.
class RouteAnimationCanvas extends StatefulWidget {
  const RouteAnimationCanvas({super.key});

  @override
  State<RouteAnimationCanvas> createState() => _RouteAnimationCanvasState();
}

class _RouteAnimationCanvasState extends State<RouteAnimationCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..forward();
  }

  void _replay() => _controller.forward(from: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Purely illustrative and constantly moving — excluded from
        // semantics so a screen reader isn't spammed with per-frame
        // position updates. The legend text below conveys the same "which
        // vehicle, which kind of path" information statically.
        ExcludeSemantics(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              return LayoutBuilder(
                builder: (context, constraints) {
                  const markerSize = 28.0;
                  final trackWidth = constraints.maxWidth - markerSize;
                  final habalX = trackWidth * t;
                  final jeepneyX = trackWidth * t;
                  // Winding path: same horizontal span as the direct
                  // route, but weaves laterally — visually "covers more
                  // distance".
                  final jeepneyWobble = math.sin(t * math.pi * 4) * 10;

                  return SizedBox(
                    height: 96,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 20,
                          child: Container(height: 2, color: colors.surfaceCard),
                        ),
                        Positioned(
                          left: habalX,
                          top: 4,
                          child: Icon(
                            Icons.two_wheeler,
                            color: colors.primaryAccent,
                            size: markerSize,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 72,
                          child: Container(height: 2, color: colors.surfaceCard),
                        ),
                        Positioned(
                          left: jeepneyX,
                          top: 56 + jeepneyWobble,
                          child: Icon(
                            Icons.directions_bus,
                            color: colors.secondaryAccent,
                            size: markerSize,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendRow(
                    icon: Icons.two_wheeler,
                    color: colors.primaryAccent,
                    label: 'Habal-habal — short, direct path',
                  ),
                  const SizedBox(height: 4),
                  _LegendRow(
                    icon: Icons.directions_bus,
                    color: colors.secondaryAccent,
                    label: 'Jeepney — longer, winding path',
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: _replay,
              icon: const Icon(Icons.replay),
              label: const Text('Replay'),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.icon, required this.color, required this.label});

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}
