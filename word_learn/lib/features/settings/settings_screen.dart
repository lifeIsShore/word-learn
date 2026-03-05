import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/constants/app_languages.dart';
import '../../shared/models/language_config.dart';
import '../../shared/state/active_language_provider.dart';
import '../../shared/state/backup_provider.dart';
import '../../shared/state/onboarding_provider.dart';
import '../../shared/state/settings_provider.dart';
import '../../shared/state/streak_provider.dart';

/// WL-400: User Profile & Settings Screen.
/// Sections: Profile · Learning · Appearance · Stats · Privacy · Account.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final onboarding = ref.watch(onboardingProvider);
    final streak = ref.watch(streakProvider);
    final backup = ref.watch(backupProvider);
    final activeLang = ref.watch(activeLanguageProvider);
    final langNotifier = ref.read(activeLanguageProvider.notifier);
    final availableLangs = langNotifier.availableForUser();

    final baseLang = kAppLanguages
        .firstWhere(
          (l) => l.code == onboarding.baseLanguageCode,
          orElse: () => kAppLanguages.first,
        )
        .name;

    final targetLangs = onboarding.targetLanguageCodes
        .map(
          (code) => kAppLanguages
              .firstWhere(
                (l) => l.code == code,
                orElse: () => kAppLanguages.first,
              )
              .name,
        )
        .join(', ');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text('Settings', style: AppTypography.labelLarge),
      ),
      body: ListView(
        children: [
          // ── PROFILE ──────────────────────────────────────────────────
          _SectionHeader(label: 'PROFILE'),
          _EditableRow(
            label: 'Display Name',
            value: settings.displayName,
            onTap: () => _editDisplayName(context, ref, settings.displayName),
          ),
          _ReadOnlyRow(label: 'Base Language', value: baseLang),
          _ReadOnlyRow(
            label: 'Target Languages',
            value: targetLangs.isEmpty ? 'None selected' : targetLangs,
          ),
          // WL-600: Active study language picker
          if (availableLangs.length > 1)
            _LanguagePickerRow(
              label: 'Active Study Language',
              available: availableLangs,
              active: activeLang,
              onSelected: langNotifier.switchTo,
            )
          else if (activeLang != null)
            _ReadOnlyRow(
              label: 'Active Study Language',
              value: '${activeLang.languageName} ${activeLang.cefrLevel}',
            ),
          _Divider(),

          // ── LEARNING ─────────────────────────────────────────────────
          _SectionHeader(label: 'LEARNING'),
          _EditableRow(
            label: 'Daily Curfew',
            value: _fmtTime(onboarding.curfew),
            onTap: () => _editCurfew(context, ref, onboarding.curfew),
          ),
          _SliderRow(
            label: 'Daily Drip',
            value: onboarding.dailyDripCount.toDouble(),
            min: 5,
            max: 40,
            divisions: 7,
            displayValue: '${onboarding.dailyDripCount} words/day',
            onChanged: (v) =>
                ref.read(onboardingProvider.notifier).setDailyDrip(v.round()),
          ),
          _Divider(),

          // ── APPEARANCE ───────────────────────────────────────────────
          _SectionHeader(label: 'APPEARANCE'),
          _ThemeRow(
            current: settings.themeMode,
            onChanged: (mode) =>
                ref.read(settingsProvider.notifier).setThemeMode(mode),
          ),
          _Divider(),

          // ── STATS ────────────────────────────────────────────────────
          _SectionHeader(label: 'STATS'),
          _ReadOnlyRow(
            label: 'Current Streak',
            value: '${streak.currentStreak} days',
          ),
          _ReadOnlyRow(
            label: 'Longest Streak',
            value: '${streak.longestStreak} days',
          ),
          _ReadOnlyRow(
            label: 'CEFR Levels',
            value: onboarding.cefrPerTarget.isEmpty
                ? 'Not configured'
                : onboarding.cefrPerTarget.entries
                      .map((e) => '${e.key.toUpperCase()}: ${e.value}')
                      .join('  ·  '),
          ),
          _Divider(),

          // ── PRIVACY ──────────────────────────────────────────────────
          _SectionHeader(label: 'PRIVACY'),
          _ToggleRow(
            label: 'Share Learning Data',
            subtitle: 'Contribute anonymised data for community mnemonics',
            value: settings.shareLearningData,
            onChanged: (v) =>
                ref.read(settingsProvider.notifier).setShareLearningData(v),
          ),
          _ToggleRow(
            label: 'Allow Crash Reports',
            subtitle: 'Send anonymous error reports to improve stability',
            value: settings.allowCrashReports,
            onChanged: (v) =>
                ref.read(settingsProvider.notifier).setAllowCrashReports(v),
          ),
          _Divider(),

          // ── BACKUP ────────────────────────────────────────────
          _SectionHeader(label: 'BACKUP'),
          _BackupStatusRow(backup: backup),
          _ActionRow(
            label: backup.isSyncing ? 'Syncing…' : 'Sync Now',
            sublabel: 'Upload local progress to cloud',
            color: backup.isSyncing
                ? AppColors.mediumGray
                : AppColors.primaryTeal,
            onTap: backup.isSyncing
                ? () {}
                : () => _syncNow(context, ref),
          ),
          _Divider(),

          // ── ACCOUNT ────────────────────────────────────────────
          _SectionHeader(label: 'ACCOUNT'),
          _ReadOnlyRow(label: 'Subscription', value: 'Free tier'),
          _ActionRow(
            label: 'Reset Progress',
            sublabel: 'Clears streak and session history',
            color: AppColors.warning,
            onTap: () => _confirmResetProgress(context, ref),
          ),
          _ActionRow(
            label: 'Delete Account',
            sublabel: 'Permanently removes all data',
            color: AppColors.error,
            onTap: () => _confirmDeleteAccount(context),
          ),

          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  // ── Editors ───────────────────────────────────────────────────────────────

  void _editDisplayName(BuildContext context, WidgetRef ref, String current) {
    final ctrl = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Display Name'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLength: 30,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).setDisplayName(ctrl.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editCurfew(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay current,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      helpText: 'SET CURFEW TIME',
    );
    if (picked != null) {
      ref.read(onboardingProvider.notifier).setCurfew(picked);
    }
  }

  void _confirmResetProgress(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'This will clear your streak and session history. Batch and Vault words are kept. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(streakProvider.notifier).acknowledgeAsh();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Progress reset.')));
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This is irreversible. All data will be permanently deleted. Auth is currently disabled — this action clears local state only.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              // In production: POST /api/v1/user/delete + clear SQLite + tokens.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Account deletion deferred — auth not yet enabled.',
                  ),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _syncNow(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(backupProvider.notifier).sync();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Backup synced successfully.' : 'Sync failed. Check your connection.',
        ),
      ),
    );
  }

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

// ── Backup Status Row ───────────────────────────────────────────────────

class _BackupStatusRow extends StatelessWidget {
  const _BackupStatusRow({required this.backup});
  final BackupState backup;

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    IconData icon;

    switch (backup.status) {
      case BackupStatus.idle:
        final synced = backup.lastSyncedAt;
        label = synced == null
            ? 'Not yet backed up'
            : 'Last synced ${_fmtAgo(synced)}';
        color = AppColors.mediumGray;
        icon = Icons.cloud_upload_outlined;
      case BackupStatus.syncing:
        label = 'Syncing…';
        color = AppColors.primaryTeal;
        icon = Icons.sync;
      case BackupStatus.success:
        label = 'Backed up just now';
        color = AppColors.success;
        icon = Icons.cloud_done_outlined;
      case BackupStatus.failed:
        label = backup.error ?? 'Backup failed';
        color = AppColors.error;
        icon = Icons.cloud_off_outlined;
    }

    final counts = backup.batchWordCount != null
        ? '${backup.batchWordCount} batch · ${backup.vaultWordCount} vault'
        : null;

    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: color),
      ),
      subtitle: counts != null
          ? Text(
              counts,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
                fontSize: 11,
              ),
            )
          : null,
    );
  }

  String _fmtAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.primaryTeal,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 16, endIndent: 16);
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGray),
      ),
      trailing: Text(
        value,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
      ),
    );
  }
}

class _EditableRow extends StatelessWidget {
  const _EditableRow({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGray),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right,
            size: 16,
            color: AppColors.mediumGray,
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      dense: true,
      activeThumbColor: AppColors.primaryTeal,
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGray),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.mediumGray,
          fontSize: 11,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _ThemeRow extends StatelessWidget {
  const _ThemeRow({required this.current, required this.onChanged});
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        'Theme',
        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGray),
      ),
      trailing: SegmentedButton<ThemeMode>(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColors.primaryTeal,
          selectedForegroundColor: Colors.white,
          foregroundColor: AppColors.mediumGray,
          textStyle: AppTypography.labelLarge.copyWith(fontSize: 11),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
        segments: const [
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(Icons.light_mode, size: 14),
            label: Text('Light'),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(Icons.dark_mode, size: 14),
            label: Text('Dark'),
          ),
          ButtonSegment(
            value: ThemeMode.system,
            icon: Icon(Icons.phone_android, size: 14),
            label: Text('System'),
          ),
        ],
        selected: {current},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.displayValue,
    required this.onChanged,
  });
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String displayValue;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkGray,
                ),
              ),
              Text(
                displayValue,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppColors.primaryTeal,
          inactiveColor: AppColors.lightGray,
          label: displayValue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Language Picker Row (WL-600) ─────────────────────────────────────────────

class _LanguagePickerRow extends StatelessWidget {
  const _LanguagePickerRow({
    required this.label,
    required this.available,
    required this.active,
    required this.onSelected,
  });
  final String label;
  final List<LanguageConfig> available;
  final LanguageConfig? active;
  final ValueChanged<LanguageConfig> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGray),
      ),
      trailing: DropdownButton<String>(
        value: active?.key,
        underline: const SizedBox.shrink(),
        style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryTeal),
        items: available.map((c) {
          return DropdownMenuItem<String>(
            value: c.key,
            child: Text('${c.languageName} ${c.cefrLevel}'),
          );
        }).toList(),
        onChanged: (key) {
          if (key == null) return;
          final match = available.firstWhere(
            (c) => c.key == key,
            orElse: () => available.first,
          );
          onSelected(match);
        },
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: color),
      ),
      subtitle: Text(
        sublabel,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.mediumGray,
          fontSize: 11,
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 16, color: color),
    );
  }
}
