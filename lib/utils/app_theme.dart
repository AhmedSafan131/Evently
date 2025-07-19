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
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.primaryDark,
    brightness: Brightness.dark,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.primaryDark,
    ),
  );
}
