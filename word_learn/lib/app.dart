import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/state/settings_provider.dart';

/// WordLearn app root — reactive theme + router.
///
/// BUG FIX (Session 20): The router must be created once and cached.
/// Previously, createAppRouter(ref) was called directly inside build(),
/// which created a new GoRouter instance on every rebuild (e.g. when
/// themeMode changed). Each new router reset navigation state back to
/// the splash route, causing the infinite loading loop seen on device.
///
/// Fix: Use ConsumerStatefulWidget + cache the router in initState().
class WordLearnApp extends ConsumerStatefulWidget {
  const WordLearnApp({super.key});

  @override
  ConsumerState<WordLearnApp> createState() => _WordLearnAppState();
}

class _WordLearnAppState extends ConsumerState<WordLearnApp> {
  late final _router = createAppRouter(ref);

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(settingsProvider).themeMode;

    return MaterialApp.router(
      title: 'WordLearn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
