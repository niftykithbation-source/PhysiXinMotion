import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard/dashboard_screen.dart';
import 'lesson_plan/lesson_plan_viewer.dart';
import 'onboarding/teacher_guided_tour.dart';
import 'reports/reports_export_screen.dart';
import 'roster/roster_screen.dart';

/// Teacher Portal bottom nav — 4 tabs (blueprint §3.2): Dashboard · Class
/// Roster · Lesson Plan · Reports/Export.
class TeacherHomeShell extends ConsumerStatefulWidget {
  const TeacherHomeShell({super.key});

  @override
  ConsumerState<TeacherHomeShell> createState() => _TeacherHomeShellState();
}

class _TeacherHomeShellState extends ConsumerState<TeacherHomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      maybeShowTeacherGuidedTour(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    const screens = [
      DashboardScreen(),
      RosterScreen(),
      LessonPlanViewer(),
      ReportsExportScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Roster',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Lesson Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.ios_share_outlined),
            selectedIcon: Icon(Icons.ios_share),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}
