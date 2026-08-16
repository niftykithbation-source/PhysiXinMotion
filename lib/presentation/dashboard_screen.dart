import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 0 = Engage, 1 = Explore, 2 = Explain, 3 = Elaborate, 4 = Evaluate
  int currentUnlockedStage = 0; 

  final List<String> stages = [
    "1. Engage Stage",
    "2. Explore Stage (3D Simulation Workspace)",
    "3. Explain Stage (Concept Breakdown)",
    "4. Elaborate Stage (Real-World Physics)",
    "5. Evaluate Stage (Interactive Quiz)"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PhysiX in Motion"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- APPLICATION INTRODUCTION ---
            Card(
              color: Colors.blue.shade50,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to PhysiX in Motion!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "This interactive student portal guides you through physics principles using the 5E Lesson Plan. Complete each stage sequentially to unlock advanced 3D simulations and evaluations.",
                      style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- PROGRESS TRACKER ---
            Text(
              "Your Lesson Plan Progress: ${(currentUnlockedStage / 4 * 100).toInt()}%",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: currentUnlockedStage / 4,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
              minHeight: 12,
            ),
            const SizedBox(height: 24),

            const Text(
              "5E Lesson Plan Modules",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // --- SEQUENTIAL 5E LESSON PLAN LIST ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stages.length,
              itemBuilder: (context, index) {
                bool isUnlocked = index <= currentUnlockedStage;

                return Card(
                  color: isUnlocked ? Colors.white : Colors.grey.shade100,
                  elevation: isUnlocked ? 2 : 0,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      isUnlocked ? Icons.check_circle : Icons.lock,
                      color: isUnlocked ? Colors.green : Colors.grey.shade400,
                    ),
                    title: Text(
                      stages[index],
                      style: TextStyle(
                        fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                        color: isUnlocked ? Colors.black87 : Colors.grey.shade500,
                      ),
                    ),
                    subtitle: Text(
                      isUnlocked ? "Tap to view instructions" : "Locked - Finish previous stages",
                      style: TextStyle(color: isUnlocked ? Colors.blueGrey : Colors.grey.shade400),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isUnlocked ? Colors.black54 : Colors.grey.shade300),
                    enabled: isUnlocked,
                    onTap: () {
                      if (isUnlocked) {
                        _showStageInstructions(context, index);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- STAGE INSTRUCTIONS MODAL ---
  void _showStageInstructions(BuildContext context, int stageIndex) {
    List<String> instructions = [
      "ENGAGE INSTRUCTIONS:\nWatch the introductory real-world motion video clip. Complete the introductory activity to unlock the next level.",
      "EXPLORE INSTRUCTIONS:\nWelcome to the 3D physics sandbox laboratory! Manipulate parameters like velocity, mass, and friction to study behavior parameters.",
      "EXPLAIN INSTRUCTIONS:\nRead through the conceptual textbook definitions and equations modeling the actions you observed in the 3D space.",
      "ELABORATE INSTRUCTIONS:\nApply what you have mastered to practical real-world scenarios, solving complex vector calculations.",
      "EVALUATE INSTRUCTIONS:\nComplete the formal terminal multiple-choice module quiz to receive your final score designation."
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Stage ${stageIndex + 1} Instructions", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(instructions[stageIndex], style: const TextStyle(height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          if (stageIndex == currentUnlockedStage && currentUnlockedStage < 4)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                setState(() {
                  currentUnlockedStage++; 
                });
                Navigator.pop(context);
              },
              child: const Text("Complete Stage & Unlock Next", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}
