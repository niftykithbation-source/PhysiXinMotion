import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/core/accessibility/contrast_ratio.dart';
import 'package:physix_in_motion/core/theme/app_colors.dart';

/// Blueprint §7 Step 7.3: "run this check twice, once per theme" — every
/// color pair actually used together for text or a feedback-state UI
/// component (correct/incorrect badges, progress pips, buttons), checked
/// against WCAG AA independently in light and dark mode. A pair passing in
/// one theme says nothing about the other (inverting text/background
/// doesn't preserve ratio), so both are asserted explicitly below rather
/// than assumed from a single computed pass.
///
/// This exact set of pairs previously caught 4 real light-mode-only
/// failures (buttons, "complete" pips, and both feedback badges all used a
/// near-white foreground directly on the accent colors, which are bright
/// in *both* themes) — fixed via AppColors.onAccentText and
/// FeedbackBadge's darker incorrect-fill. See git history for the before/
/// after ratios if this regresses.
void main() {
  int channel(double c) => (c * 255).round();

  double ratioOf(Color foreground, Color background) {
    return contrastRatio(
      r1: channel(foreground.r),
      g1: channel(foreground.g),
      b1: channel(foreground.b),
      r2: channel(background.r),
      g2: channel(background.g),
      b2: channel(background.b),
    );
  }

  // Mirrors FeedbackBadge's incorrect-state fill (see
  // lib/presentation/student/widgets/feedback_badge.dart).
  const incorrectBadgeFill = Color(0xFFF44336);

  for (final entry in {'light': AppColors.light, 'dark': AppColors.dark}.entries) {
    final themeName = entry.key;
    final colors = entry.value;

    group('$themeName theme', () {
      test('body text (textPrimary on surface) meets AA normal-text minimum', () {
        expect(
          ratioOf(colors.textPrimary, colors.surface),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
      });

      test('card text (textPrimary on surfaceCard) meets AA normal-text minimum', () {
        expect(
          ratioOf(colors.textPrimary, colors.surfaceCard),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
      });

      test('reasoning chip text on its own background meets AA normal-text minimum', () {
        expect(
          ratioOf(colors.reasoningChipText, colors.reasoningChipBackground),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
      });

      test('primary button text (onAccentText on primaryAccent) meets AA normal-text '
          'minimum', () {
        expect(
          ratioOf(colors.onAccentText, colors.primaryAccent),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
      });

      test('"current"/"complete" stage-pip text (onAccentText on primaryAccent/'
          'secondaryAccent) meets AA normal-text minimum', () {
        expect(
          ratioOf(colors.onAccentText, colors.primaryAccent),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
        expect(
          ratioOf(colors.onAccentText, colors.secondaryAccent),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
      });

      test('FeedbackBadge glyph (onAccentText) on its correct/incorrect fill meets AA '
          'normal-text minimum', () {
        expect(
          ratioOf(colors.onAccentText, colors.secondaryAccent),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
        expect(
          ratioOf(colors.onAccentText, incorrectBadgeFill),
          greaterThanOrEqualTo(kWcagAaNormalText),
        );
      });

      test('FeedbackBadge incorrect-state fill alone meets AA UI-component minimum against '
          'surfaceCard', () {
        // The correct-state fill (secondaryAccent) can't clear this bar on
        // its own — it's a locked color token, measuring ~2.4:1 in light
        // mode. FeedbackBadge compensates with a textPrimary border
        // instead (checked below), which is the part that actually needs
        // to pass for both states.
        expect(
          ratioOf(incorrectBadgeFill, colors.surfaceCard),
          greaterThanOrEqualTo(kWcagAaLargeTextOrUiComponent),
        );
      });

      test('FeedbackBadge border (textPrimary) meets AA UI-component minimum against '
          'surfaceCard, for both states', () {
        expect(
          ratioOf(colors.textPrimary, colors.surfaceCard),
          greaterThanOrEqualTo(kWcagAaLargeTextOrUiComponent),
        );
      });
    });
  }
}
