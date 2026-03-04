import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/models/batch_entry.dart';
import '../../shared/state/active_batch_provider.dart';

/// WL-140: Active Batch — list of words, sort options, X/200, tap detail, long-press actions.
enum BatchSort { dueFirst, hardFirst, oldestFirst }

class BatchScreen extends ConsumerStatefulWidget {
  const BatchScreen({super.key});

  @override
  ConsumerState<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends ConsumerState<BatchScreen> {
  BatchSort _sort = BatchSort.dueFirst;

  List<BatchEntry> _sorted(List<BatchEntry> list) {
    final copy = List<BatchEntry>.from(list);
    switch (_sort) {
      case BatchSort.dueFirst:
        copy.sort((a, b) {
          final ad = a.nextReviewDate ?? DateTime(2000);
          final bd = b.nextReviewDate ?? DateTime(2000);
          return ad.compareTo(bd);
        });
        break;
      case BatchSort.hardFirst:
        copy.sort((a, b) => a.easeFactor.compareTo(b.easeFactor));
        break;
      case BatchSort.oldestFirst:
        copy.sort((a, b) => a.addedAt.compareTo(b.addedAt));
        break;
    }
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    final batch = ref.watch(activeBatchProvider);
    final capacity = ref.read(activeBatchProvider.notifier).capacity;
    final sorted = _sorted(batch);

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text('Active Batch', style: AppTypography.labelLarge),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${batch.length} / $capacity words',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primaryTeal),
                ),
                DropdownButton<BatchSort>(
                  value: _sort,
                  items: const [
                    DropdownMenuItem(value: BatchSort.dueFirst, child: Text('Due first')),
                    DropdownMenuItem(value: BatchSort.hardFirst, child: Text('Hard first')),
                    DropdownMenuItem(value: BatchSort.oldestFirst, child: Text('Oldest first')),
                  ],
                  onChanged: (v) => setState(() => _sort = v ?? BatchSort.dueFirst),
                ),
              ],
            ),
          ),
          Expanded(
            child: batch.isEmpty
                ? Center(
                    child: Text(
                      'No words in batch. Start a session to add words.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final entry = sorted[index];
                      return _BatchWordTile(
                        entry: entry,
                        onTap: () => _showWordDetail(context, entry),
                        onLongPress: () => _showWordActions(context, ref, entry),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showWordDetail(BuildContext context, BatchEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paperWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.word, style: AppTypography.displayMedium.copyWith(color: AppColors.darkGray)),
            SizedBox(height: AppSpacing.sm),
            Text(entry.meaning, style: AppTypography.bodyLarge.copyWith(color: AppColors.primaryTeal)),
            SizedBox(height: AppSpacing.md),
            Text(entry.exampleSentence, style: AppTypography.bodyMedium.copyWith(fontStyle: FontStyle.italic)),
            SizedBox(height: AppSpacing.xs),
            Text(entry.exampleTranslation, style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray)),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Next review: ${_formatDate(entry.nextReviewDate)}',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
            ),
          ],
        ),
      ),
    );
  }

  void _showWordActions(BuildContext context, WidgetRef ref, BatchEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paperWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(entry.word, style: AppTypography.labelLarge),
              SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: const Icon(Icons.check_circle, color: AppColors.success),
                title: const Text('Mark as Easy (move to Vault)'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(activeBatchProvider.notifier).moveToVault(entry.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                title: const Text('Remove from Batch'),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmRemove(context, ref, entry);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context, WidgetRef ref, BatchEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from Batch'),
        content: Text('Remove "${entry.word}" from your active batch?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(activeBatchProvider.notifier).remove(entry.id);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '—';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class _BatchWordTile extends StatelessWidget {
  const _BatchWordTile({
    required this.entry,
    required this.onTap,
    required this.onLongPress,
  });

  final BatchEntry entry;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final color = entry.difficultyLevel == 'easy'
        ? AppColors.success
        : entry.difficultyLevel == 'medium'
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        title: Text(entry.word, style: AppTypography.bodyLarge.copyWith(color: AppColors.darkGray)),
        subtitle: Text(
          entry.meaning,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              entry.nextReviewDate != null
                  ? _shortDate(entry.nextReviewDate!)
                  : '—',
              style: AppTypography.labelLarge.copyWith(color: AppColors.mediumGray, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  String _shortDate(DateTime d) =>
      '${d.month}/${d.day}';
}
