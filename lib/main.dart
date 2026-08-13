import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'data/content/content_import_provider.dart';
import 'data/settings/app_settings_provider.dart';
import 'presentation/role_select/role_select_screen.dart';

void main() {
  runApp(const ProviderScope(child: PhysixInMotionApp()));
}

class PhysixInMotionApp extends ConsumerWidget {
  const PhysixInMotionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentImport = ref.watch(contentImportProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp(
      title: 'PhysiX in Motion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Settings' Appearance choice (Light/Dark/Match device), applied
      // instantly — blueprint §3.1 principle 6 / §3.2.
      themeMode: themeMode,
      home: contentImport.when(
        data: (_) => const RoleSelectScreen(),
        loading: () => const _ContentLoadingScreen(),
        error: (error, stackTrace) => _ContentImportErrorScreen(error: error),
      ),
    );
  }
}

/// Shown briefly on first launch while [contentImportProvider] seeds the
/// bundled content pack into the local database.
class _ContentLoadingScreen extends StatelessWidget {
  const _ContentLoadingScreen();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: colors.primaryAccent),
      ),
    );
  }
}

/// Step 2.3: if the bundled content pack fails validation, surface the
/// specific error instead of crashing or silently showing an empty app.
class _ContentImportErrorScreen extends StatelessWidget {
  const _ContentImportErrorScreen({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: colors.secondaryAccent, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Could not load the content pack',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
