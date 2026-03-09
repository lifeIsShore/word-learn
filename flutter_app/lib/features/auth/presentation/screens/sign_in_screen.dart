import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/wl_buttons.dart';
import '../../../../shared/widgets/wl_text_field.dart';
import '../../data/auth_repository.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _serverError;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    bool valid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
      _serverError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      valid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => _emailError = 'Invalid email format');
      valid = false;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      valid = false;
    }

    return valid;
  }

  Future<void> _signIn() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) context.go(AppRoutes.home);
    } on AuthException catch (e) {
      setState(() => _serverError = _mapAuthError(e.message));
    } catch (_) {
      setState(
          () => _serverError = 'No internet connection. Check your network.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } catch (_) {
      setState(() => _serverError = 'Google sign-in failed. Try again.');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  String _mapAuthError(String message) {
    if (message.contains('Invalid login')) {
      return 'Incorrect email or password.';
    }
    if (message.contains('Email not confirmed')) {
      return 'Please verify your email first.';
    }
    return 'Service temporarily unavailable. Try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxxl),

              // Header
              const Text('Scholar,\nwelcome back.',
                  style: AppTextStyles.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sign in to continue your progress.',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.mediumGray),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Error banner
              if (_serverError != null) ...[
                WlErrorBanner(message: _serverError!),
                const SizedBox(height: AppSpacing.md),
              ],

              // Email field
              WlTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'scholar@example.com',
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() => _emailError = null),
              ),
              const SizedBox(height: AppSpacing.md),

              // Password field
              WlTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                errorText: _passwordError,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signIn(),
                onChanged: (_) => setState(() => _passwordError = null),
              ),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: implement forgot password (Phase 1.1)
                  },
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Sign in button
              WlPrimaryButton(
                label: 'Sign In',
                onPressed: _signIn,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSpacing.md),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'or',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.mediumGray),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Google SSO
              WlSocialButton(
                label: 'Continue with Google',
                iconAsset: const _GoogleIcon(),
                onPressed: _isGoogleLoading ? null : _signInWithGoogle,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.mediumGray),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.signUp),
                    child: Text(
                      'Create one',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal Google 'G' icon (no external SVG needed)
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
