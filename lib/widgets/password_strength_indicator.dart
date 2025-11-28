import 'package:flutter/material.dart';
import '../core/constants.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int strength; // 0-4
  final String label;

  const PasswordStrengthIndicator({
    Key? key,
    required this.strength,
    required this.label,
  }) : super(key: key);

  Color _getStrengthColor() {
    switch (strength) {
      case 0:
        return AppColors.error;
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.secondary;
      case 4:
        return AppColors.success;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < 3 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: index < strength
                      ? _getStrengthColor()
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: _getStrengthColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasMinLength = password.length >= 8;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must contain:',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirement('At least 8 characters', hasMinLength),
          _buildRequirement('One uppercase letter', hasUpperCase),
          _buildRequirement('One lowercase letter', hasLowerCase),
          _buildRequirement('One number', hasNumber),
          _buildRequirement('One special character', hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: met ? AppColors.success : AppColors.textLight,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: met ? AppColors.textPrimary : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
