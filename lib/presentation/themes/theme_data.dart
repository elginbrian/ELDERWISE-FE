import 'package:elderwise/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryMain,
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, color: AppColors.neutral90), // Regular
    displayMedium: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: AppColors.neutral90), // Medium
    displaySmall: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: AppColors.neutral90), // Semibold
    headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.neutral90), // h1 Regular
    headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: AppColors.neutral90), // h2 Regular
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.neutral90), // h3 Regular
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: AppColors.neutral90), // h4 Regular
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: AppColors.neutral90), // h5 Regular
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.neutral90), // p16 Regular
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutral90), // p14 Regular
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.neutral90), // p12 Regular
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.neutral90), // l16 Regular
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.neutral90), // l14 Regular
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.neutral90), // l12 Regular
  ),
);
