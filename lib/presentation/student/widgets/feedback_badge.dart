import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Blueprint §7 Step 7.3: a bare accent-colored icon directly on
/// [AppColors.surfaceCard] fails WCAG AA's 3:1 UI-component minimum in
/// light mode (secondaryAccent measures ~2.4:1, the old Colors.redAccent
/// ~2.9:1). Filling a small badge with the accent and drawing the glyph in
/// [AppColors.onAccentText] fixes the glyph, but the correct-state fill
/// (secondaryAccent) still can't clear 3:1 against surfaceCard on its own
/// — secondaryAccent is a locked color token, so a [textPrimary] border
/// gives the badge boundary its own independently-passing contrast instead
/// (see test/core/accessibility/contrast_ratio_test.dart).
class FeedbackBadge extends StatelessWidget {
  const FeedbackBadge({super.key, required this.isCorrect, this.size = 28});

  final bool isCorrect;
  final double size;

  // Material red 500 — darker/more saturated than Colors.redAccent, so the
  // badge fill itself also clears the 3:1 boundary-contrast bar against
  // surfaceCard, not just the glyph inside it.
  static const _incorrectFill = Color(0xFFF44336);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCorrect ? colors.secondaryAccent : _incorrectFill,
        border: Border.all(color: colors.textPrimary, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Icon(
        isCorrect ? Icons.check : Icons.close,
        size: size * 0.55,
        color: colors.onAccentText,
      ),
    );
  }
}
