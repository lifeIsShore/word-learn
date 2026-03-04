import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Auth entry — Email sign-up/sign-in, Google, Apple (iOS).
/// WL-001, WL-002, WL-003. Disabled for testing; implement last.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              'Auth is disabled for easier testing. Will be enabled later.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mediumGray,
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => context.go(AppRoutes.onboardingWelcome),
              child: const Text('Continue to onboarding'),
            ),
            SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Skip to Home (dev)'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
