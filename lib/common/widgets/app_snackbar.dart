import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Helper for success, error, info snackbars. Uses theme AppColors.
class AppSnackbar {
  AppSnackbar._();

  static void success(BuildContext context, String message) {
    _show(context, message, AppColors.of(context).success);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, AppColors.of(context).error);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, AppColors.of(context).info);
  }

  static void _show(BuildContext context, String message, Color color) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: theme.snackBarTheme.contentTextStyle?.copyWith(color: Colors.white)),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
