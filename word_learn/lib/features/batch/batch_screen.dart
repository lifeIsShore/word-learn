import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/models/batch_entry.dart';
import '../../shared/state/active_batch_provider.dart';

/// WL-140: Active Batch — list of words, sort options, X/200, NEW badge,
/// SRS metadata, tap detail, long-press actions.
enum BatchSort { dueFirst, hardFirst, oldestFirst, newFirst }

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
      case BatchSort.newFirst:
        copy.sort((a, b) => b.addedAt.compareTo(a.addedAt));
        break;
    }
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    final batch = ref.watch(activeBatchProvider);
    final notifier = ref.read(activeBatchProvider.notifier);
    final capacity = notifier.capacity;
    final sorted = _sorted(batch);
    final newCount = batch.where((e) => e.isNewToday).length;

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
          // ── Header bar ────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${batch.length} / $capacity',
                      style: AppTypography.labelLarge
                          .copyWith(color: AppColors.primaryTeal),
                    ),
                    if (newCount > 0)
                      Text(
                        '$newCount new today',
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.success, fontSize: 11),
                      ),
                  ],
                ),
                const Spacer(),
                DropdownButton<BatchSort>(
                  value: _sort,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                        value: BatchSort.dueFirst, child: Text('Due first')),
                    DropdownMenuItem(
                        value: BatchSort.hardFirst, child: Text('Hard first')),
                    DropdownMenuItem(
                        value: BatchSort.oldestFirst,
                        child: Text('Oldest first')),
                    DropdownMenuItem(
                        value: BatchSort.newFirst, child: Text('Newest first')),
                  ],
                  onChanged: (v) =>
                      setState(() => _sort = v ?? BatchSort.dueFirst),
                ),
              ],
            ),
          ),
          // ── Capacity progress bar ─────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: batch.length / capacity,
                backgroundColor: AppColors.lightGray,
                color: notifier.isNearCapacity
                    ? AppColors.warning
                    : AppColors.primaryTeal,
                minHeight: 4,
              ),
            ),
          ),
          // ── Word list ─────────────────────────────────────────────────
          Expanded(
            child: batch.isEmpty
                ? Center(
                    child: Text(
                      'No words in batch.\nTap Daily Drip on Home to add words.',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.mediumGray),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final entry = sorted[index];
                      return _BatchWordTile(
                        entry: entry,
                        onTap: () => _showWordDetail(context, entry),
                        onLongPress: () =>
                            _showWordActions(context, ref, entry),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showWordDetail(BuildContext context, BatchEntry entry) {
    final diffColor = entry.difficultyLevel == 'easy'
        ? AppColors.success
        : entry.difficultyLevel == 'medium'
            ? AppColors.warning
            : AppColors.error;

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
            Row(
              children: [
                Expanded(
                  child: Text(entry.word,
                      style: AppTypography.displayMedium
                          .copyWith(color: AppColors.darkGray)),
                ),
                if (entry.isNewToday)
                  _Badge(label: 'NEW', color: AppColors.success),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(entry.meaning,
                style: AppTypography.bodyLarge
                    .copyWith(color: AppColors.primaryTeal)),
            SizedBox(height: AppSpacing.md),
            Text(entry.exampleSentence,
                style: AppTypography.bodyMedium
                    .copyWith(fontStyle: FontStyle.italic)),
            SizedBox(height: AppSpacing.xs),
            Text(entry.exampleTranslation,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.mediumGray)),
            SizedBox(height: AppSpacing.md),
            // SRS metadata
            Row(
              children: [
                _SrsStat(
                    label: 'Ease',
                    value: entry.easeFactor.toStringAsFixed(2),
                    color: diffColor),
                SizedBox(width: AppSpacing.lg),
                _SrsStat(
                    label: 'Interval',
                    value: '${entry.intervalDays}d'),
                SizedBox(width: AppSpacing.lg),
                _SrsStat(
                    label: 'Reps',
                    value: '${entry.repetitions}'),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Next review: ${_formatDate(entry.nextReviewDate)}',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.mediumGray),
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
                leading:
                    const Icon(Icons.check_circle, color: AppColors.success),
                title: const Text('Graduate to Vault'),
                subtitle: const Text('Mark as mastered — moves to long-term storage'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(activeBatchProvider.notifier).moveToVault(entry.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${entry.word}" moved to Vault.'),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline,
                    color: AppColors.error),
                title: const Text('Remove from Batch'),
                subtitle: const Text('Permanently removes from active learning'),
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

  void _confirmRemove(
      BuildContext context, WidgetRef ref, BatchEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from Batch'),
        content:
            Text('Remove "${entry.word}" from your active batch? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: AppColors.error),
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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

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
    final now = DateTime.now();
    final isDue = entry.nextReviewDate == null ||
        !entry.nextReviewDate!.isAfter(now);

    final dotColor = entry.difficultyLevel == 'easy'
        ? AppColors.success
        : entry.difficultyLevel == 'medium'
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        title: Row(
          children: [
            Expanded(
              child: Text(entry.word,
                  style: AppTypography.bodyLarge
                      .copyWith(color: AppColors.darkGray)),
            ),
            if (entry.isNewToday) ...[
              SizedBox(width: AppSpacing.xs),
              _Badge(label: 'NEW', color: AppColors.success),
            ],
            if (isDue && !entry.isNewToday) ...[
              SizedBox(width: AppSpacing.xs),
              _Badge(label: 'DUE', color: AppColors.primaryTeal),
            ],
          ],
        ),
        subtitle: Text(
          entry.meaning,
          style: AppTypography.bodyMedium
              .copyWith(color: AppColors.mediumGray),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: dotColor),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              entry.nextReviewDate != null
                  ? _shortDate(entry.nextReviewDate!)
                  : '—',
              style: AppTypography.labelLarge.copyWith(
                  color: AppColors.mediumGray, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  String _shortDate(DateTime d) => '${d.month}/${d.day}';
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 9, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SrsStat extends StatelessWidget {
  const _SrsStat({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.mediumGray, fontSize: 11)),
        Text(value,
            style: AppTypography.labelLarge.copyWith(
                color: color ?? AppColors.darkGray, fontSize: 13)),
      ],
    );
  }
}
