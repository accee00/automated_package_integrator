import 'package:automated_package_integrator/constants/app_colors.dart';
import 'package:automated_package_integrator/constants/app_text_style.dart';
import 'package:automated_package_integrator/core/enums.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required SnackBarType type,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyle.snackBarTextStyle,
        ),
        backgroundColor: type == SnackBarType.success
            ? AppColors.snackBarSuccessColor
            : AppColors.snackBarFailureColor,
        behavior: SnackBarBehavior.floating,
        elevation: 0, // Remove default fallback shadow. Suuiiiiii
      ),
    );
}
