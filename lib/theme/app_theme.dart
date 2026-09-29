import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.cyan,
      secondary: AppColors.green,
      surface: AppColors.panel,
      error: AppColors.red,
    ),
    fontFamily: 'Arial',
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 38, letterSpacing: -1.2),
      headlineSmall: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 23),
      bodyMedium: TextStyle(color: AppColors.muted, height: 1.7),
    ),
    dividerColor: AppColors.border,
    useMaterial3: true,
  );
}
