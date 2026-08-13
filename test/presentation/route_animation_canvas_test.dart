import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/presentation/student/trip_tracker/route_animation_canvas.dart';

void main() {
  testWidgets(
    'RouteAnimationCanvas runs a live, ticking AnimationController (not a static drawing)',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RouteAnimationCanvas())),
      );
      await tester.pump();

      final habal = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.two_wheeler && widget.size == 28,
      );
      expect(habal, findsOneWidget);
      final firstPosition = tester.getTopLeft(habal);

      await tester.pump(const Duration(milliseconds: 500));
      final secondPosition = tester.getTopLeft(habal);

      expect(secondPosition, isNot(equals(firstPosition)));

      // Replay resets the animation back to its start.
      await tester.tap(find.text('Replay'));
      await tester.pump();
      final afterReplay = tester.getTopLeft(habal);
      expect(afterReplay.dx, lessThan(secondPosition.dx));
    },
  );
}
