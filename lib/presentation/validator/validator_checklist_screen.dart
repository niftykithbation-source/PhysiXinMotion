import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/db/database.dart';
import '../../data/evaluation/evaluation_providers.dart';

/// Blueprint §7 Step 9 item 6: "Prepare an in-app 'Validator Mode' that
/// surfaces the Table-of-Specifications tag (quiz_items.tos_competency)
/// alongside each item, so validators can check curriculum alignment
/// directly against Appendix G without a separate spreadsheet." Read-only —
/// validators cross-check this list against the printed checklist, they
/// don't act on it in-app.
class ValidatorChecklistScreen extends ConsumerWidget {
  const ValidatorChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(activeQuizItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Validator Checklist')),
      body: SafeArea(
        child: itemsAsync.when(
          data: (items) => items.isEmpty
              ? const Center(child: Text('No evaluation items found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _ChecklistCard(item: items[index], index: index),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('$error'))),
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.item, required this.index});

  final QuizItemRow item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item ${index + 1} — ${item.itemId}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 6),
            Text(item.prompt, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: item.tosCompetency == null
                    ? colors.surfaceCard
                    : colors.primaryAccent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.checklist_rtl, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.tosCompetency ?? 'No ToS tag',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            if (item.difficulty != null) ...[
              const SizedBox(height: 8),
              Chip(
                avatar: const Icon(Icons.speed, size: 16),
                label: Text(item.difficulty!),
                backgroundColor: colors.secondaryAccent.withValues(alpha: 0.18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
