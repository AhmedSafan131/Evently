import 'package:evently/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.whiteBgColor,
    brightness: Brightness.light,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.primaryLight,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.primaryDark,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      onBackground: Colors.white,
      secondary: AppColors.primaryLight,
      onSecondary: Colors.white,
      error: AppColors.redColor,
      onError: Colors.white,
      surface: AppColors.primaryDark,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryLight),
      bodyMedium: TextStyle(color: AppColors.primaryLight),
      bodySmall: TextStyle(color: AppColors.primaryLight),
      titleLarge: TextStyle(color: AppColors.primaryLight),
      titleMedium: TextStyle(color: AppColors.primaryLight),
      titleSmall: TextStyle(color: AppColors.primaryLight),
      labelLarge: TextStyle(color: AppColors.primaryLight),
      labelMedium: TextStyle(color: AppColors.primaryLight),
      labelSmall: TextStyle(color: AppColors.primaryLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight),
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.primaryDark,
    ),
  );
}
