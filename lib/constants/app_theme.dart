import 'package:automated_package_integrator/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static _border([Color color = Colors.transparent]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(17),
      );

  static final ThemeData lightTheme = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      border: _border(AppColors.borderColor),
      contentPadding: EdgeInsets.all(17),
      focusedBorder: _border(AppColors.borderColor),
      enabledBorder: _border(Colors.black54),
      disabledBorder: _border(AppColors.borderColor),
    ),
    scaffoldBackgroundColor: AppColors.backGroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          AppColors.elevatedButtonColor,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );
}
