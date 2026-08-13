import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/presentation/student/motion_lab/trial_animation_canvas.dart';

MotionTrialRow _trial() => MotionTrialRow(
      trialId: 't1',
      userId: 'u1',
      groupId: null,
      trialNumber: 1,
      distanceM: 8.0,
      displacementM: 8.0,
      timeS: 4.0,
      computedSpeed: 2.0,
      computedVelocity: 2.0,
      recordedAt: 0,
    );

void main() {
  testWidgets(
    'TrialAnimationCanvas runs a live, ticking AnimationController (not a static drawing)',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TrialAnimationCanvas(trial: _trial()))),
      );
      await tester.pump();

      final readout = find.textContaining('t = ');
      expect(readout, findsOneWidget);
      final firstReading = (tester.widget(readout) as Text).data;

      // Advance the (fake) animation clock and confirm the
      // AnimationController genuinely ticked — a static drawing would show
      // the same readout every frame.
      await tester.pump(const Duration(milliseconds: 400));
      final secondReading = (tester.widget(readout) as Text).data;

      expect(secondReading, isNot(equals(firstReading)));
    },
  );
}
