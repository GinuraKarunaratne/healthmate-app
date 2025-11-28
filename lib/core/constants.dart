import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2F80ED);
  static const Color primaryLight = Color(0xFF56CCF2);
  static const Color secondary = Color(0xFF27AE60);
  static const Color secondaryLight = Color(0xFF6FCF97);

  static const Color background = Color(0xFFF4F6FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E0E0);

  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);

  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFED8936);
  static const Color success = Color(0xFF38A169);

  static const Color stepsColor = Color(0xFF9B51E0);
  static const Color caloriesColor = Color(0xFFF2994A);
  static const Color waterColor = Color(0xFF56CCF2);
  static const Color sleepColor = Color(0xFF6FCF97);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}

class AppSizes {
  static const double borderRadius = 16.0;
  static const double cardElevation = 2.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
}
