import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AppTypography — Complete text style system for SmartMart.
///
/// Font pairing:
///   Display / Headings : Plus Jakarta Sans  (modern, premium, geometric)
///   Body / UI labels   : DM Sans           (clean, readable, versatile)
///
/// HOW TO USE:
///   Text('Hello', style: AppTypography.h1)
///   Text('Price', style: context.textTheme.displayLarge)   ← theme-aware
///   Text('Label', style: AppTypography.labelMd.copyWith(color: AppColors.primary))
///
/// Scale follows 8-point baseline with these sizes (sp):
///   10 | 12 | 13 | 14 | 16 | 18 | 20 | 24 | 28 | 32 | 40 | 48
/// ─────────────────────────────────────────────────────────────────────────────

abstract class AppTypography {
  // ── Font Families ───────────────────────────────────────────────────────────
  static TextStyle get _display => GoogleFonts.plusJakartaSans();
  static TextStyle get _body    => GoogleFonts.dmSans();

  // ── Display Scale ───────────────────────────────────────────────────────────
  /// 48sp · ExtraBold — Hero numbers, reward points counter
  static TextStyle get displayXl => _display.copyWith(
    fontSize: 48, fontWeight: FontWeight.w800,
    letterSpacing: -1.5, height: 1.1,
  );

  /// 40sp · ExtraBold — Page hero titles
  static TextStyle get displayLg => _display.copyWith(
    fontSize: 40, fontWeight: FontWeight.w800,
    letterSpacing: -1.2, height: 1.15,
  );

  /// 32sp · Bold — Section title, modal header
  static TextStyle get displayMd => _display.copyWith(
    fontSize: 32, fontWeight: FontWeight.w700,
    letterSpacing: -0.8, height: 1.2,
  );

  // ── Heading Scale ────────────────────────────────────────────────────────────
  /// 28sp · Bold — Screen titles
  static TextStyle get h1 => _display.copyWith(
    fontSize: 28, fontWeight: FontWeight.w700,
    letterSpacing: -0.5, height: 1.25,
  );

  /// 24sp · SemiBold — Section headers
  static TextStyle get h2 => _display.copyWith(
    fontSize: 24, fontWeight: FontWeight.w600,
    letterSpacing: -0.3, height: 1.3,
  );

  /// 20sp · SemiBold — Card titles, sub-section headers
  static TextStyle get h3 => _display.copyWith(
    fontSize: 20, fontWeight: FontWeight.w600,
    letterSpacing: -0.2, height: 1.35,
  );

  /// 18sp · SemiBold — List item titles, tab labels
  static TextStyle get h4 => _display.copyWith(
    fontSize: 18, fontWeight: FontWeight.w600,
    letterSpacing: -0.1, height: 1.4,
  );

  // ── Body Scale ───────────────────────────────────────────────────────────────
  /// 16sp · Regular — Primary body text
  static TextStyle get bodyLg => _body.copyWith(
    fontSize: 16, fontWeight: FontWeight.w400,
    letterSpacing: 0.1, height: 1.6,
  );

  /// 16sp · Medium — Emphasized body text
  static TextStyle get bodyLgMedium => _body.copyWith(
    fontSize: 16, fontWeight: FontWeight.w500,
    letterSpacing: 0.1, height: 1.6,
  );

  /// 14sp · Regular — Secondary body text, descriptions
  static TextStyle get bodyMd => _body.copyWith(
    fontSize: 14, fontWeight: FontWeight.w400,
    letterSpacing: 0.1, height: 1.6,
  );

  /// 14sp · Medium — Emphasized secondary text
  static TextStyle get bodyMdMedium => _body.copyWith(
    fontSize: 14, fontWeight: FontWeight.w500,
    letterSpacing: 0.1, height: 1.6,
  );

  /// 13sp · Regular — Dense list descriptions
  static TextStyle get bodySm => _body.copyWith(
    fontSize: 13, fontWeight: FontWeight.w400,
    letterSpacing: 0.1, height: 1.55,
  );

  // ── Label Scale (UI components) ──────────────────────────────────────────────
  /// 16sp · SemiBold — Button text (large)
  static TextStyle get labelLg => _body.copyWith(
    fontSize: 16, fontWeight: FontWeight.w600,
    letterSpacing: 0.2, height: 1.0,
  );

  /// 14sp · SemiBold — Button text (medium), chip labels
  static TextStyle get labelMd => _body.copyWith(
    fontSize: 14, fontWeight: FontWeight.w600,
    letterSpacing: 0.2, height: 1.0,
  );

  /// 12sp · Medium — Captions, timestamps, badges
  static TextStyle get labelSm => _body.copyWith(
    fontSize: 12, fontWeight: FontWeight.w500,
    letterSpacing: 0.3, height: 1.0,
  );

  /// 10sp · SemiBold — Tiny badges, nav labels
  static TextStyle get labelXs => _body.copyWith(
    fontSize: 10, fontWeight: FontWeight.w600,
    letterSpacing: 0.4, height: 1.0,
  );

  // ── Price Scale ──────────────────────────────────────────────────────────────
  /// Large price display (product detail)
  static TextStyle get priceLg => _display.copyWith(
    fontSize: 28, fontWeight: FontWeight.w800,
    letterSpacing: -0.5, height: 1.0,
    color: AppColors.grey900,
  );

  /// Medium price (product cards)
  static TextStyle get priceMd => _display.copyWith(
    fontSize: 18, fontWeight: FontWeight.w700,
    letterSpacing: -0.3, height: 1.0,
    color: AppColors.grey900,
  );

  /// Original price with strikethrough (call .copyWith on widget level)
  static TextStyle get priceOriginal => _body.copyWith(
    fontSize: 13, fontWeight: FontWeight.w400,
    letterSpacing: 0.0, height: 1.0,
    color: AppColors.grey400,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.grey400,
  );

  // ── TextTheme for MaterialApp ─────────────────────────────────────────────
  static TextTheme get textTheme => TextTheme(
    // Display
    displayLarge:  displayXl.copyWith(color: AppColors.lightTextPrimary),
    displayMedium: displayLg.copyWith(color: AppColors.lightTextPrimary),
    displaySmall:  displayMd.copyWith(color: AppColors.lightTextPrimary),
    // Headline
    headlineLarge:  h1.copyWith(color: AppColors.lightTextPrimary),
    headlineMedium: h2.copyWith(color: AppColors.lightTextPrimary),
    headlineSmall:  h3.copyWith(color: AppColors.lightTextPrimary),
    // Title
    titleLarge:  h4.copyWith(color: AppColors.lightTextPrimary),
    titleMedium: bodyLgMedium.copyWith(color: AppColors.lightTextPrimary),
    titleSmall:  bodyMdMedium.copyWith(color: AppColors.lightTextPrimary),
    // Body
    bodyLarge:  bodyLg.copyWith(color: AppColors.lightTextPrimary),
    bodyMedium: bodyMd.copyWith(color: AppColors.lightTextSecondary),
    bodySmall:  bodySm.copyWith(color: AppColors.lightTextSecondary),
    // Label
    labelLarge:  labelLg.copyWith(color: AppColors.lightTextPrimary),
    labelMedium: labelMd.copyWith(color: AppColors.lightTextSecondary),
    labelSmall:  labelSm.copyWith(color: AppColors.lightTextSecondary),
  );

  static TextTheme get darkTextTheme => TextTheme(
    displayLarge:  displayXl.copyWith(color: AppColors.darkTextPrimary),
    displayMedium: displayLg.copyWith(color: AppColors.darkTextPrimary),
    displaySmall:  displayMd.copyWith(color: AppColors.darkTextPrimary),
    headlineLarge:  h1.copyWith(color: AppColors.darkTextPrimary),
    headlineMedium: h2.copyWith(color: AppColors.darkTextPrimary),
    headlineSmall:  h3.copyWith(color: AppColors.darkTextPrimary),
    titleLarge:  h4.copyWith(color: AppColors.darkTextPrimary),
    titleMedium: bodyLgMedium.copyWith(color: AppColors.darkTextPrimary),
    titleSmall:  bodyMdMedium.copyWith(color: AppColors.darkTextPrimary),
    bodyLarge:  bodyLg.copyWith(color: AppColors.darkTextPrimary),
    bodyMedium: bodyMd.copyWith(color: AppColors.darkTextSecondary),
    bodySmall:  bodySm.copyWith(color: AppColors.darkTextSecondary),
    labelLarge:  labelLg.copyWith(color: AppColors.darkTextPrimary),
    labelMedium: labelMd.copyWith(color: AppColors.darkTextSecondary),
    labelSmall:  labelSm.copyWith(color: AppColors.darkTextSecondary),
  );
}
