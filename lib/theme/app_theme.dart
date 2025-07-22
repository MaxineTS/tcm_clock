import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_radius.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'SourceHanSerif',
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.green600,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.green600,
        onPrimary: AppColors.white,
        secondary: AppColors.brown500,
        onSecondary: AppColors.white,
        error: AppColors.red500,
        onError: AppColors.white,
        background: AppColors.white,
        onBackground: AppColors.black,
        surface: AppColors.gray100,
        onSurface: AppColors.black,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.title1Emphasized,
        displayMedium: AppTextStyles.title2Emphasized,
        displaySmall: AppTextStyles.title3Emphasized,
        headlineLarge: AppTextStyles.title1Regular,
        headlineMedium: AppTextStyles.title2Regular,
        headlineSmall: AppTextStyles.title3Regular,
        bodyLarge: AppTextStyles.bodyEmphasized,
        bodyMedium: AppTextStyles.bodyRegular,
        titleMedium: AppTextStyles.subheadlineEmphasized,
        titleSmall: AppTextStyles.subheadlinerRegular,
        labelLarge: AppTextStyles.footnoteEmphasized,
        labelSmall: AppTextStyles.footnoteRegular,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        titleTextStyle: AppTextStyles.title2Emphasized,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        elevation: 2,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
      ),
      // 你可以继续扩展按钮、分割线等主题
    );
  }
}
