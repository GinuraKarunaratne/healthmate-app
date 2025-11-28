import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}

class OutlinedCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;

  const OutlinedCustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? AppColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: borderColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
