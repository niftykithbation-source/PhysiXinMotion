import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/session/stage_progress_repository.dart';

/// Blueprint §3.3: "5E stage tracker: E-E-E-E-E pips, current stage
/// highlighted". [completedStages] lights up completed stages; [current]
/// is drawn with the primary accent regardless of completion.
class FiveEProgressPips extends StatelessWidget {
  const FiveEProgressPips({
    super.key,
    required this.current,
    required this.completedStages,
  });

  final String current;
  final Set<String> completedStages;

  static const _labels = {
    'engage': 'E',
    'explore': 'E',
    'explain': 'E',
    'elaborate': 'E',
    'evaluate': 'E',
  };

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final stage in kFiveEStages) ...[
          _Pip(
            label: _labels[stage]!,
            isCurrent: stage == current,
            isComplete: completedStages.contains(stage),
            colors: colors,
          ),
          if (stage != kFiveEStages.last) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _Pip extends StatelessWidget {
  const _Pip({
    required this.label,
    required this.isCurrent,
    required this.isComplete,
    required this.colors,
  });

  final String label;
  final bool isCurrent;
  final bool isComplete;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    if (isCurrent) {
      background = colors.primaryAccent;
      foreground = colors.onAccentText;
    } else if (isComplete) {
      background = colors.secondaryAccent;
      foreground = colors.onAccentText;
    } else {
      background = colors.surfaceCard;
      foreground = colors.textPrimary.withValues(alpha: 0.5);
    }

    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        label,
        style: TextStyle(color: foreground, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
