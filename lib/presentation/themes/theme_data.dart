import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryMain,
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    displayMedium: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: AppColors.neutral90),
    displaySmall: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: AppColors.neutral90),
    headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.neutral90),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutral90),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.neutral90),
  ),
);
