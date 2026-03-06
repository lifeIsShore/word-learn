import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

/// Standard text input field with WordLearn styling
class WlTextField extends StatefulWidget {
  const WlTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autofocus = false,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final Widget? prefixIcon;

  @override
  State<WlTextField> createState() => _WlTextFieldState();
}

class _WlTextFieldState extends State<WlTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          autofocus: widget.autofocus,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.mediumGray,
                      size: AppSpacing.iconSize,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

/// Error banner — shown at top of forms for server/network errors
class WlErrorBanner extends StatelessWidget {
  const WlErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Password strength indicator
class WlPasswordStrengthIndicator extends StatelessWidget {
  const WlPasswordStrengthIndicator({super.key, required this.password});

  final String password;

  PasswordStrength get _strength => PasswordStrength.evaluate(password);

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _strength;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: List.generate(4, (index) {
            final filled = index < strength.score;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                height: 3,
                decoration: BoxDecoration(
                  color: filled ? strength.color : AppColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          strength.label,
          style: AppTextStyles.bodySmall.copyWith(color: strength.color),
        ),
      ],
    );
  }
}

enum PasswordStrength {
  weak(1, 'Weak', AppColors.error),
  fair(2, 'Fair', AppColors.warning),
  good(3, 'Good', AppColors.info),
  strong(4, 'Strong', AppColors.success);

  const PasswordStrength(this.score, this.label, this.color);

  final int score;
  final String label;
  final Color color;

  static PasswordStrength evaluate(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    return switch (score) {
      4 => strong,
      3 => good,
      2 => fair,
      _ => weak,
    };
  }
}
