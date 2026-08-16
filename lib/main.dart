import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'data/content/content_import_provider.dart';
import 'data/settings/app_settings_provider.dart';
import 'presentation/role_select/role_select_screen.dart';

void main() {
  runApp(const ProviderScope(child: PhysiXInMotionApp()));
}

class PhysiXInMotionApp extends ConsumerWidget {
  const PhysiXInMotionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp(
      title: 'PhysiX in Motion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Settings' Appearance choice (Light/Dark/Match device), applied
      // instantly — blueprint §3.1 principle 6 / §3.2.
      themeMode: themeMode,
      home: const _AppStartup(),
    );
  }
}

/// Blueprint Steps 1-2: seeds the bundled kinematics_v1 content pack before
/// anything else touches the DB. Shows a loading spinner while the import
/// runs, then hands off to [RoleSelectScreen] — which in turn routes to
/// the Student or Teacher portal shell depending on which role is tapped.
/// A failed import (Step 2.3 validation) surfaces as a readable error
/// instead of a blank or crashed app.
class _AppStartup extends ConsumerWidget {
  const _AppStartup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importAsync = ref.watch(contentImportProvider);

    return importAsync.when(
      data: (_) => const RoleSelectScreen(),
      loading: () => const _StartupScaffold(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _StartupScaffold(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Could not load PhysiX in Motion.\n\n$error',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _StartupScaffold extends StatelessWidget {
  const _StartupScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: child));
  }
}
