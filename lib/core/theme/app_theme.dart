import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light/dark [ThemeData] built from [AppColors], per blueprint §3.1a.
///
/// Appearance defaults to "match device setting" (see Settings, blueprint
/// §3.2) — callers should set [ThemeMode.system] unless the user has
/// explicitly chosen Light or Dark.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colors.primaryAccent,
      brightness: brightness,
      primary: colors.primaryAccent,
      secondary: colors.secondaryAccent,
      surface: colors.surface,
      onSurface: colors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.surface,
      cardColor: colors.surfaceCard,
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
            bodyColor: colors.textPrimary,
            displayColor: colors.textPrimary,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryAccent,
          foregroundColor: colors.onAccentText,
          minimumSize: const Size.fromHeight(48), // min touch target, §3.1
        ),
      ),
    );
  }
}
