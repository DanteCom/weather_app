import 'package:flutter/material.dart';
import 'package:weather_app/app/ui/themes/app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(scaffoldBackgroundColor: AppColors.white);

  static final outlineBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(20));
}
