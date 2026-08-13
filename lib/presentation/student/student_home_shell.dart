import 'package:flutter/material.dart';

import 'evaluation/evaluation_terminal_screen.dart';
import 'graph_visualizer/graph_visualizer_screen.dart';
import 'mission_mode/mission_mode_screen.dart';
import 'motion_lab/motion_lab_screen.dart';
import 'profile/profile_screen.dart';
import 'trip_tracker/trip_tracker_screen.dart';

/// Student Portal bottom nav — 5 tabs mirroring the 5E flow left-to-right
/// (blueprint §3.2). Graph Visualizer isn't a tab; Motion Lab pushes it.
class StudentHomeShell extends StatefulWidget {
  const StudentHomeShell({super.key});

  @override
  State<StudentHomeShell> createState() => _StudentHomeShellState();
}

class _StudentHomeShellState extends State<StudentHomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      TripTrackerScreen(onContinue: () => setState(() => _index = 1)),
      MotionLabScreen(
        onSendToGraphVisualizer: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GraphVisualizerScreen()),
        ),
      ),
      const MissionModeScreen(),
      const EvaluationTerminalScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'Motion Lab',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            selectedIcon: Icon(Icons.flag),
            label: 'Mission',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Evaluation',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
