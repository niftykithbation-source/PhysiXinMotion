import 'package:flutter_test/flutter_test.dart';

import 'package:physix_in_motion/data/db/database.dart';
import 'package:physix_in_motion/data/settings/app_settings_provider.dart';

MotionTrialRow _trial(int trialNumber) => MotionTrialRow(
      trialId: 'trial-$trialNumber',
      trialNumber: trialNumber,
      distanceM: 8,
      displacementM: 8,
      timeS: 4,
      recordedAt: trialNumber,
    );

/// Blueprint §7 Step 8: an unbounded number of accumulated Motion Lab
/// trials must not be fed unbounded into a chart/list every rebuild —
/// [capTrialHistory] is the shared guard for both Motion Lab and Graph
/// Visualizer.
void main() {
  group('capTrialHistory', () {
    test('returns all trials unchanged when under the default cap', () {
      final trials = List.generate(SimpleGraphicsController.defaultTrialHistoryCap, (i) => _trial(i + 1));
      expect(capTrialHistory(trials, simpleGraphics: false), trials);
    });

    test('keeps only the most recent defaultTrialHistoryCap trials when over the cap', () {
      final trials =
          List.generate(SimpleGraphicsController.defaultTrialHistoryCap + 15, (i) => _trial(i + 1));
      final result = capTrialHistory(trials, simpleGraphics: false);
      expect(result.length, SimpleGraphicsController.defaultTrialHistoryCap);
      expect(result.first.trialNumber, 16);
      expect(result.last.trialNumber, trials.length);
    });

    test('keeps only the tighter capWhenEnabled trials when Simple graphics is on', () {
      final trials = List.generate(SimpleGraphicsController.defaultTrialHistoryCap, (i) => _trial(i + 1));
      final result = capTrialHistory(trials, simpleGraphics: true);
      expect(result.length, SimpleGraphicsController.capWhenEnabled);
      expect(result.last.trialNumber, trials.length);
    });
  });
}
