import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../student/student_home_shell.dart';
import '../teacher/teacher_home_shell.dart';

/// Shared entry screen: role toggle (Student / Teacher), per blueprint §3.2.
///
/// Neither path has the local PIN/passcode gate from blueprint §3.2 yet;
/// this build uses a single implicit local student/teacher per device
/// instead (see current_student_provider.dart / current_teacher_provider.dart).
class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/icon_mark_transparent.png',
                  height: 96,
                ),
                const SizedBox(height: 24),
                Text(
                  'PhysiX in Motion',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Who\'s using the app?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.textPrimary.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const StudentHomeShell()),
                    ),
                    child: const Text('Student'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TeacherHomeShell()),
                    ),
                    child: const Text('Teacher'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
