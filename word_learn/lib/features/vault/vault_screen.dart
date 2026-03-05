import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/models/batch_entry.dart';
import '../../shared/state/vault_provider.dart';

/// WL-180: Vault — mastered words archive. Read-only list with word details.
class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vault = ref.watch(vaultProvider);

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text('Vault', style: AppTypography.labelLarge),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: Center(
              child: Text(
                '${vault.length} words',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: vault.isEmpty
          ? _EmptyVault()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _VaultHeader(count: vault.length),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: vault.length,
                    itemBuilder: (context, index) {
                      final entry = vault[vault.length - 1 - index];
                      return _VaultWordTile(
                        entry: entry,
                        onTap: () => _showWordDetail(context, entry),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.word,
                    style: AppTypography.displayMedium.copyWith(color: AppColors.darkGray),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'MASTERED',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primaryTeal,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              entry.meaning,
              style: AppTypography.bodyLarge.copyWith(color: AppColors.primaryTeal),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              entry.exampleSentence,
              style: AppTypography.bodyMedium.copyWith(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              entry.exampleTranslation,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Added ${_formatDate(entry.addedAt)}',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _VaultHeader extends StatelessWidget {
  const _VaultHeader({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.lightTeal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, color: AppColors.primaryTeal, size: 32),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count words mastered',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primaryTeal),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Words you\'ve demonstrated consistent mastery of.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultWordTile extends StatelessWidget {
  const _VaultWordTile({required this.entry, required this.onTap});
  final BatchEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        title: Text(
          entry.word,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.darkGray),
        ),
        subtitle: Text(
          entry.meaning,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.mediumGray),
      ),
    );
  }
}

class _EmptyVault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_open, size: 64, color: AppColors.lightGray),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Your Vault is empty.',
              style: AppTypography.labelLarge.copyWith(color: AppColors.darkGray),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Words you mark as Easy or master consistently will be archived here.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
