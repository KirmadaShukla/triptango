import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppConstants.backgroundColor,
          foregroundColor: AppConstants.textColor,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: AppConstants.fontSizeXXL,
            fontWeight: AppConstants.fontWeightBold,
            color: AppConstants.textColor,
          ),
          displayMedium: TextStyle(
            fontSize: AppConstants.fontSizeXL,
            fontWeight: AppConstants.fontWeightBold,
            color: AppConstants.textColor,
          ),
          displaySmall: TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          headlineLarge: TextStyle(
            fontSize: AppConstants.fontSizeXL,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          headlineMedium: TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          headlineSmall: TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          titleLarge: TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: AppConstants.fontWeightBold,
            color: AppConstants.textColor,
          ),
          titleMedium: TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          titleSmall: TextStyle(
            fontSize: AppConstants.fontSizeS,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          bodyLarge: TextStyle(
            fontSize: AppConstants.fontSizeL,
            fontWeight: AppConstants.fontWeightRegular,
            color: AppConstants.textColor,
          ),
          bodyMedium: TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: AppConstants.fontWeightRegular,
            color: AppConstants.textColor,
          ),
          bodySmall: TextStyle(
            fontSize: AppConstants.fontSizeS,
            fontWeight: AppConstants.fontWeightRegular,
            color: AppConstants.textColor,
          ),
          labelLarge: TextStyle(
            fontSize: AppConstants.fontSizeM,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          labelMedium: TextStyle(
            fontSize: AppConstants.fontSizeS,
            fontWeight: AppConstants.fontWeightMedium,
            color: AppConstants.textColor,
          ),
          labelSmall: TextStyle(
            fontSize: AppConstants.fontSizeXS,
            fontWeight: AppConstants.fontWeightLight,
            color: AppConstants.textColor,
          ),
        ),
      );
} 