import 'package:flutter/material.dart';

/// Color tokens for PhysiX in Motion, per blueprint §3.1a.
///
/// Never hardcode a hex value directly in a widget — resolve every color
/// through [AppColors.of] (or the theme's [ColorScheme]) so switching
/// between light and dark mode never requires touching screen code.
class AppColors {
  const AppColors({
    required this.primaryAccent,
    required this.surface,
    required this.surfaceCard,
    required this.textPrimary,
    required this.secondaryAccent,
    required this.reasoningChipBackground,
    required this.reasoningChipText,
  });

  final Color primaryAccent;
  final Color surface;
  final Color surfaceCard;
  final Color textPrimary;
  final Color secondaryAccent;
  final Color reasoningChipBackground;
  final Color reasoningChipText;

  /// Text/icon color for content placed directly on [primaryAccent] or
  /// [secondaryAccent] fills (buttons, filled badges, the "current"/
  /// "complete" 5E progress pips). Deliberately the same near-black navy
  /// in both themes — both accents are bright/saturated in light *and*
  /// dark mode, so a light foreground fails WCAG AA against them in light
  /// mode specifically (blueprint §7 Step 7.3 flags exactly this: a pair
  /// passing in one theme isn't evidence it passes in the other). Verified
  /// >=5.3:1 against both accents in both themes — see
  /// test/core/accessibility/contrast_ratio_test.dart.
  Color get onAccentText => const Color(0xFF12162D);

  static const light = AppColors(
    primaryAccent: Color(0xFF0E9AAE),
    surface: Color(0xFFFFFFFF),
    surfaceCard: Color(0xFFEAF7FA),
    textPrimary: Color(0xFF12162D),
    secondaryAccent: Color(0xFFE8862E),
    reasoningChipBackground: Color(0xFFE8F6F8),
    reasoningChipText: Color(0xFF0E4C57),
  );

  // Dark-mode base is the icon's navy (#12162D), never pure black.
  static const dark = AppColors(
    primaryAccent: Color(0xFF22D3EE),
    surface: Color(0xFF12162D),
    surfaceCard: Color(0xFF1E204A),
    textPrimary: Color(0xFFF5F7FA),
    secondaryAccent: Color(0xFFFF9F43),
    reasoningChipBackground: Color(0xFF1E204A),
    reasoningChipText: Color(0xFF7DE3EF),
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}
