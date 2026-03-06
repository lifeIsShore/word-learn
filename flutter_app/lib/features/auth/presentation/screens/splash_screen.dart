import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';

/// Entry point — resolves auth state and redirects accordingly
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
    _resolve();
  }

  Future<void> _resolve() async {
    // Give splash a minimum display time (UX polish)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(AppConstants.keyOnboardingComplete) ?? false;

    if (!mounted) return;

    authState.when(
      data: (user) {
        if (user == null) {
          context.go(AppRoutes.signIn);
        } else if (!onboardingDone) {
          context.go(AppRoutes.welcome);
        } else {
          context.go(AppRoutes.home);
        }
      },
      loading: () {
        // Still loading — will re-resolve when state settles
      },
      error: (_, __) => context.go(AppRoutes.signIn),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo mark — W monogram
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    'W',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.primaryTeal,
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'WORDLEARN',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                  fontSize: 14,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
