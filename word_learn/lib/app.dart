import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/state/settings_provider.dart';

/// WordLearn app root — reactive theme + router.
class WordLearnApp extends ConsumerWidget {
  const WordLearnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider).themeMode;

    return MaterialApp.router(
      title: 'WordLearn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: createAppRouter(),
    );
  }
}
