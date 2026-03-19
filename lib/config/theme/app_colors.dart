import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AppColors — Static color tokens + ThemeExtension for semantic colors.
///
/// Static tokens (used by AppTheme, AppTypography):
///   AppColors.primary, AppColors.lightSurface, AppColors.grey400, etc.
///
/// Theme-aware semantic colors (used by widgets via context):
///   AppColors.of(context).success, .error, .discount, .points
/// ─────────────────────────────────────────────────────────────────────────────

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.successContainer,
    required this.error,
    required this.errorContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.discount,
    required this.discountContainer,
    required this.points,
    required this.pointsContainer,
  });

  final Color success;
  final Color successContainer;
  final Color error;
  final Color errorContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;
  final Color discount;
  final Color discountContainer;
  final Color points;
  final Color pointsContainer;

  // ── Static color tokens (for ThemeData, typography) ────────────────────────
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4D9AFF);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primarySurface = Color(0xFFE8F0FE);

  static const Color white = Colors.white;

  static const Color successStatic = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF064E3B);

  static const Color errorStatic = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFF991B1B);

  static const Color reward = Color(0xFFD97706);
  static const Color rewardLight = Color(0xFFFEF3C7);
  static const Color rewardSurface = Color(0xFFFFFBEB);
  static const Color warningDark = Color(0xFF78350F);

  static const Color flash = Color(0xFFEF4444);
  static const Color flashLight = Color(0xFFFECACA);

  // Semantic aliases for ThemeData (avoid conflict with instance success/error)
  static const Color successColor = successStatic;
  static const Color errorColor = errorStatic;

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextDisabled = Color(0xFF94A3B8);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color lightCardShadow = Color(0x0F000000);
  static const Color lightOverlay = Color(0x80000000);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextDisabled = Color(0xFF64748B);
  static const Color darkBorder = Color(0xFF475569);
  static const Color darkDivider = Color(0xFF334155);
  static const Color darkCardShadow = Color(0x40000000);
  static const Color darkOverlay = Color(0xCC000000);

  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // ── ThemeExtension presets ─────────────────────────────────────────────────
  static const AppColors light = AppColors(
    success: Color(0xFF2E7D32),
    successContainer: Color(0xFFE8F5E9),
    error: Color(0xFFC62828),
    errorContainer: Color(0xFFFFEBEE),
    warning: Color(0xFFF57C00),
    warningContainer: Color(0xFFFFF3E0),
    info: Color(0xFF1565C0),
    infoContainer: Color(0xFFE3F2FD),
    discount: Color(0xFFE65100),
    discountContainer: Color(0xFFFFE0B2),
    points: Color(0xFF2E7D32),
    pointsContainer: Color(0xFFE8F5E9),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFF81C784),
    successContainer: Color(0xFF1B5E20),
    error: Color(0xFFEF5350),
    errorContainer: Color(0xFFB71C1C),
    warning: Color(0xFFFFB74D),
    warningContainer: Color(0xFFE65100),
    info: Color(0xFF64B5F6),
    infoContainer: Color(0xFF0D47A1),
    discount: Color(0xFFFFB74D),
    discountContainer: Color(0xFFE65100),
    points: Color(0xFF81C784),
    pointsContainer: Color(0xFF1B5E20),
  );

  /// Theme-aware semantic colors. Falls back to light if extension not in theme.
  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? light;
  }

  @override
  AppColors copyWith({
    Color? success,
    Color? successContainer,
    Color? error,
    Color? errorContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    Color? discount,
    Color? discountContainer,
    Color? points,
    Color? pointsContainer,
  }) {
    return AppColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      discount: discount ?? this.discount,
      discountContainer: discountContainer ?? this.discountContainer,
      points: points ?? this.points,
      pointsContainer: pointsContainer ?? this.pointsContainer,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      discount: Color.lerp(discount, other.discount, t)!,
      discountContainer: Color.lerp(discountContainer, other.discountContainer, t)!,
      points: Color.lerp(points, other.points, t)!,
      pointsContainer: Color.lerp(pointsContainer, other.pointsContainer, t)!,
    );
  }
}
