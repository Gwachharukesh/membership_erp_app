import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Theme Extensions — Custom theme data attached to MaterialApp.
/// These let you access custom design tokens through context,
/// just like context.colorScheme or context.textTheme.
///
/// SETUP (in AppTheme.light and AppTheme.dark):
///   extensions: [AppColorExtension.light, AppTypographyExtension.instance]
///
/// HOW TO USE IN WIDGETS:
///   context.appColors.primary        ← theme-aware brand color
///   context.appColors.cardSurface    ← adaptive card background
///   context.appTypo.h1               ← typography token
///   context.appColors.isLight        ← current brightness check
/// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// AppColorExtension
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.cardSurface,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.shadow,
    required this.overlay,
    required this.inputFill,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.isLight,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color cardSurface;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color shadow;
  final Color overlay;
  final Color inputFill;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final bool isLight;

  // ── Light preset ──────────────────────────────────────────────────────────
  static const AppColorExtension light = AppColorExtension(
    background:       AppColors.lightBackground,
    surface:          AppColors.lightSurface,
    surfaceVariant:   AppColors.lightSurfaceVariant,
    cardSurface:      AppColors.lightSurface,
    border:           AppColors.lightBorder,
    divider:          AppColors.lightDivider,
    textPrimary:      AppColors.lightTextPrimary,
    textSecondary:    AppColors.lightTextSecondary,
    textDisabled:     AppColors.lightTextDisabled,
    shadow:           AppColors.lightCardShadow,
    overlay:          AppColors.lightOverlay,
    inputFill:        AppColors.lightSurfaceVariant,
    shimmerBase:      AppColors.grey200,
    shimmerHighlight: AppColors.grey100,
    isLight:          true,
  );

  // ── Dark preset ───────────────────────────────────────────────────────────
  static const AppColorExtension dark = AppColorExtension(
    background:       AppColors.darkBackground,
    surface:          AppColors.darkSurface,
    surfaceVariant:   AppColors.darkSurfaceVariant,
    cardSurface:      AppColors.darkSurface,
    border:           AppColors.darkBorder,
    divider:          AppColors.darkDivider,
    textPrimary:      AppColors.darkTextPrimary,
    textSecondary:    AppColors.darkTextSecondary,
    textDisabled:     AppColors.darkTextDisabled,
    shadow:           AppColors.darkCardShadow,
    overlay:          AppColors.darkOverlay,
    inputFill:        AppColors.darkSurfaceVariant,
    shimmerBase:      AppColors.grey800,
    shimmerHighlight: AppColors.grey700,
    isLight:          false,
  );

  @override
  AppColorExtension copyWith({
    Color? background, Color? surface, Color? surfaceVariant,
    Color? cardSurface, Color? border, Color? divider,
    Color? textPrimary, Color? textSecondary, Color? textDisabled,
    Color? shadow, Color? overlay, Color? inputFill,
    Color? shimmerBase, Color? shimmerHighlight, bool? isLight,
  }) => AppColorExtension(
    background:       background       ?? this.background,
    surface:          surface          ?? this.surface,
    surfaceVariant:   surfaceVariant   ?? this.surfaceVariant,
    cardSurface:      cardSurface      ?? this.cardSurface,
    border:           border           ?? this.border,
    divider:          divider          ?? this.divider,
    textPrimary:      textPrimary      ?? this.textPrimary,
    textSecondary:    textSecondary    ?? this.textSecondary,
    textDisabled:     textDisabled     ?? this.textDisabled,
    shadow:           shadow           ?? this.shadow,
    overlay:          overlay          ?? this.overlay,
    inputFill:        inputFill        ?? this.inputFill,
    shimmerBase:      shimmerBase      ?? this.shimmerBase,
    shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    isLight:          isLight          ?? this.isLight,
  );

  @override
  AppColorExtension lerp(AppColorExtension? other, double t) {
    if (other == null) return this;
    return AppColorExtension(
      background:       Color.lerp(background, other.background, t)!,
      surface:          Color.lerp(surface, other.surface, t)!,
      surfaceVariant:   Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      cardSurface:      Color.lerp(cardSurface, other.cardSurface, t)!,
      border:           Color.lerp(border, other.border, t)!,
      divider:          Color.lerp(divider, other.divider, t)!,
      textPrimary:      Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary:    Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled:     Color.lerp(textDisabled, other.textDisabled, t)!,
      shadow:           Color.lerp(shadow, other.shadow, t)!,
      overlay:          Color.lerp(overlay, other.overlay, t)!,
      inputFill:        Color.lerp(inputFill, other.inputFill, t)!,
      shimmerBase:      Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      isLight: t < 0.5 ? this.isLight : (other.isLight),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppTypographyExtension
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  const AppTypographyExtension();

  static const AppTypographyExtension instance = AppTypographyExtension();

  TextStyle get displayXl     => AppTypography.displayXl;
  TextStyle get displayLg     => AppTypography.displayLg;
  TextStyle get displayMd     => AppTypography.displayMd;
  TextStyle get h1            => AppTypography.h1;
  TextStyle get h2            => AppTypography.h2;
  TextStyle get h3            => AppTypography.h3;
  TextStyle get h4            => AppTypography.h4;
  TextStyle get bodyLg        => AppTypography.bodyLg;
  TextStyle get bodyLgMedium  => AppTypography.bodyLgMedium;
  TextStyle get bodyMd        => AppTypography.bodyMd;
  TextStyle get bodyMdMedium  => AppTypography.bodyMdMedium;
  TextStyle get bodySm        => AppTypography.bodySm;
  TextStyle get labelLg       => AppTypography.labelLg;
  TextStyle get labelMd       => AppTypography.labelMd;
  TextStyle get labelSm       => AppTypography.labelSm;
  TextStyle get labelXs       => AppTypography.labelXs;
  TextStyle get priceLg       => AppTypography.priceLg;
  TextStyle get priceMd       => AppTypography.priceMd;
  TextStyle get priceOriginal => AppTypography.priceOriginal;

  @override
  AppTypographyExtension copyWith() => const AppTypographyExtension();

  @override
  AppTypographyExtension lerp(AppTypographyExtension? other, double t) => this;
}

// ─────────────────────────────────────────────────────────────────────────────
// BuildContext Extensions — The developer-facing API.
//
// USAGE:
//   context.appColors.surface       ← adaptive color token
//   context.appTypo.h2              ← typography token
//   context.colorScheme.primary     ← standard M3 color
//   context.textTheme.headlineLarge ← standard M3 typography
//   context.isDark                  ← brightness check
//   context.screenWidth             ← media query shorthand
// ─────────────────────────────────────────────────────────────────────────────
extension BuildContextThemeX on BuildContext {
  // ── Custom extensions ─────────────────────────────────────────────────────
  AppColorExtension get appColors =>
      Theme.of(this).extension<AppColorExtension>() ?? AppColorExtension.light;

  AppTypographyExtension get appTypo =>
      Theme.of(this).extension<AppTypographyExtension>() ??
      AppTypographyExtension.instance;

  // ── Standard M3 shortcuts ─────────────────────────────────────────────────
  ColorScheme get colorScheme  => Theme.of(this).colorScheme;
  TextTheme   get textTheme    => Theme.of(this).textTheme;
  ThemeData   get theme        => Theme.of(this);

  // ── Brightness ────────────────────────────────────────────────────────────
  bool get isDark  => Theme.of(this).brightness == Brightness.dark;
  bool get isLight => Theme.of(this).brightness == Brightness.light;

  // ── Media Query shortcuts ─────────────────────────────────────────────────
  MediaQueryData get mq          => MediaQuery.of(this);
  double get screenWidth         => mq.size.width;
  double get screenHeight        => mq.size.height;
  double get statusBarHeight     => mq.padding.top;
  double get bottomInset         => mq.viewInsets.bottom;
  double get bottomPadding       => mq.padding.bottom;
  bool   get isKeyboardVisible   => mq.viewInsets.bottom > 0;
  bool   get isSmallScreen       => screenWidth < 360;
  bool   get isTablet            => screenWidth >= 600;

  // ── Navigation shortcuts ──────────────────────────────────────────────────
  NavigatorState get navigator => Navigator.of(this);
  void pop<T>([T? result]) => navigator.pop(result);
}
