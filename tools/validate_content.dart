// Standalone CI check for Step 2.3 (blueprint §7 Step 2.3 / §6 Risk #12).
//
// Runs the same ContentValidator the app uses at first launch against a
// content pack JSON file on disk, so a bad edit to e.g. kinematics_v1.json
// is caught in CI before it's ever bundled into a build.
//
// Usage:
//   dart run tools/validate_content.dart [path/to/pack.json ...]
// Defaults to assets/content/kinematics_v1.json if no path is given.
// Exits 0 if every pack is valid, 1 otherwise.

import 'dart:io';

import 'package:physix_in_motion/data/content/content_validation_exception.dart';
import 'package:physix_in_motion/data/content/content_validator.dart';

Future<void> main(List<String> args) async {
  final paths = args.isNotEmpty ? args : ['assets/content/kinematics_v1.json'];

  var allValid = true;

  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('FAIL $path: file not found.');
      allValid = false;
      continue;
    }

    final rawJson = await file.readAsString();
    try {
      final pack = ContentValidator.validate(rawJson);
      stdout.writeln(
        'OK   $path: pack "${pack.packId}" — '
        '${pack.lessonStages.length} stages, '
        '${pack.quizItems.length} quiz items, '
        '${pack.missionLevels.length} mission levels, '
        '${pack.badges.length} badges.',
      );
    } on ContentValidationException catch (e) {
      stderr.writeln('FAIL $path: $e');
      allValid = false;
    }
  }

  if (!allValid) {
    exit(1);
  }
}
