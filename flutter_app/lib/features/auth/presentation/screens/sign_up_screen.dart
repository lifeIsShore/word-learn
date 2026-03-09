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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _serverError;
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    bool valid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
      _serverError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    // Email
    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      valid = false;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => _emailError = 'Invalid email format');
      valid = false;
    }

    // Password
    if (password.length < 8) {
      setState(() => _passwordError = 'Password min 8 characters');
      valid = false;
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      setState(() => _passwordError = 'Include an uppercase letter');
      valid = false;
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      setState(() => _passwordError = 'Include a number');
      valid = false;
    } else if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      setState(() => _passwordError = 'Include a special character (!@#\$%)');
      valid = false;
    }

    // Confirm
    if (confirm != password) {
      setState(() => _confirmError = 'Passwords do not match');
      valid = false;
    }

    return valid;
  }

  Future<void> _signUp() async {
    if (!_validateInputs()) return;
    if (!_acceptedTerms) {
      setState(() =>
          _serverError = 'Please accept the Terms of Service to continue.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authRepositoryProvider).signUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : null,
          );
      if (mounted) context.go(AppRoutes.welcome);
    } on AuthException catch (e) {
      setState(() => _serverError = _mapAuthError(e.message));
    } catch (_) {
      setState(
          () => _serverError = 'No internet connection. Check your network.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapAuthError(String message) {
    if (message.contains('already registered') ||
        message.contains('User already')) {
      return 'Email already registered. Sign in instead?';
    }
    if (message.contains('Password should be')) {
      return 'Password does not meet requirements.';
    }
    return 'Service temporarily unavailable. Try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGray),
          onPressed: () => context.go(AppRoutes.signIn),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Header
              const Text('Create your\naccount.',
                  style: AppTextStyles.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'By signing up, you confirm you are 13 or older.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.mediumGray),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Error banner
              if (_serverError != null) ...[
                WlErrorBanner(message: _serverError!),
                const SizedBox(height: AppSpacing.md),
              ],

              // Display name (optional)
              WlTextField(
                controller: _nameController,
                label: 'Display name (optional)',
                hint: 'Dr. Scholar',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),

              // Email
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

              // Password
              WlTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                errorText: _passwordError,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() => _passwordError = null),
              ),
              // Password strength indicator
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: WlPasswordStrengthIndicator(
                  password: _passwordController.text,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Confirm password
              WlTextField(
                controller: _confirmController,
                label: 'Confirm password',
                isPassword: true,
                errorText: _confirmError,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signUp(),
                onChanged: (_) => setState(() => _confirmError = null),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Terms of Service
              GestureDetector(
                onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _acceptedTerms,
                        onChanged: (val) =>
                            setState(() => _acceptedTerms = val ?? false),
                        activeColor: AppColors.primaryTeal,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall,
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sign up button
              WlPrimaryButton(
                label: 'Create Account',
                onPressed: _signUp,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.mediumGray),
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.signIn),
                    child: Text(
                      'Sign in',
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
