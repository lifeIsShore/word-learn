import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/auth_provider.dart';

/// Auth screen — Sign Up / Sign In.
/// WL-001, WL-004, WL-005.
///
/// When [AppConfig.devModeSkipAuth] is true this screen is never shown
/// (SplashScreen bypasses it). The UI is fully built and ready for production.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safety net — if somehow auth screen is shown in dev mode, still bypass.
    if (AppConfig.devModeSkipAuth) {
      return _DevBypassScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.xxl),
            // ── Logo ──────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'WordLearn',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primaryTeal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                'Vocabulary mastery without fluff.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
            // ── Tab bar ───────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryTeal,
                unselectedLabelColor: AppColors.mediumGray,
                indicatorColor: AppColors.primaryTeal,
                tabs: const [
                  Tab(text: 'SIGN IN'),
                  Tab(text: 'SIGN UP'),
                ],
              ),
            ),
            // ── Tab views ─────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _SignInForm(),
                  _SignUpForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dev bypass widget ─────────────────────────────────────────────────────────

class _DevBypassScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.developer_mode,
                  color: AppColors.primaryTeal, size: 48),
              SizedBox(height: AppSpacing.md),
              Text(
                'Auth Disabled (Dev Mode)',
                style: AppTypography.labelLarge
                    .copyWith(color: AppColors.primaryTeal),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Set AppConfig.devModeSkipAuth = false to enable real auth.',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.mediumGray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Continue to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sign In form ──────────────────────────────────────────────────────────────

class _SignInForm extends ConsumerStatefulWidget {
  const _SignInForm();

  @override
  ConsumerState<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<_SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).signIn(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
    if (success && mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.lg),
            _EmailField(controller: _emailCtrl),
            SizedBox(height: AppSpacing.md),
            _PasswordField(
              controller: _passwordCtrl,
              obscure: _obscurePassword,
              onToggle: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              label: 'Password',
            ),
            SizedBox(height: AppSpacing.sm),
            // ── Error ──────────────────────────────────────────────────
            if (authState.error != null)
              _ErrorBanner(message: authState.error!),
            SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: authState.isLoading ? null : _submit,
              child: authState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('SIGN IN'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sign Up form ──────────────────────────────────────────────────────────────

class _SignUpForm extends ConsumerStatefulWidget {
  const _SignUpForm();

  @override
  ConsumerState<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).signUp(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          displayName: _nameCtrl.text.trim(),
        );
    if (success && mounted) {
      // New user → onboarding
      context.go(AppRoutes.onboardingWelcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.lg),
            // Display name
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                hintText: 'Scholar',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Enter a display name.';
                }
                return null;
              },
            ),
            SizedBox(height: AppSpacing.md),
            _EmailField(controller: _emailCtrl),
            SizedBox(height: AppSpacing.md),
            _PasswordField(
              controller: _passwordCtrl,
              obscure: _obscurePassword,
              onToggle: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              label: 'Password',
              validator: _validatePassword,
            ),
            SizedBox(height: AppSpacing.md),
            _PasswordField(
              controller: _confirmCtrl,
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              label: 'Confirm Password',
              validator: (v) => v != _passwordCtrl.text
                  ? 'Passwords do not match.'
                  : null,
            ),
            SizedBox(height: AppSpacing.sm),
            if (authState.error != null)
              _ErrorBanner(message: authState.error!),
            SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: authState.isLoading ? null : _submit,
              child: authState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('CREATE ACCOUNT'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? v) {
    if (v == null || v.length < 8) return 'Min 8 characters.';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Include an uppercase letter.';
    if (!v.contains(RegExp(r'\d'))) return 'Include a number.';
    if (!v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Include a special character.';
    }
    return null;
  }
}

// ── Shared field widgets ──────────────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Enter your email.';
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailRegex.hasMatch(v.trim())) return 'Invalid email format.';
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    required this.label,
    this.validator,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;
  final String label;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
      ),
      validator: validator ??
          (v) => (v == null || v.isEmpty) ? 'Enter your password.' : null,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: AppTypography.bodySmall.copyWith(color: Colors.red.shade800),
      ),
    );
  }
}
