import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AppTheme — Centralized theme configuration for SmartMart.
///
/// HOW TO PLUG IN (main.dart):
///
///   MaterialApp(
///     theme:      AppTheme.light,
///     darkTheme:  AppTheme.dark,
///     themeMode:  ThemeMode.system, // or control with ThemeBloc
///   )
///
/// THAT'S IT. Everything — buttons, cards, inputs, chips, dialogs, bottom
/// sheets, app bars, nav bars — is pre-configured here. You never need to
/// pass style props to standard widgets unless you want an exception.
///
/// NO hardcoded colors or styles anywhere else.
/// NO passing theme props into individual widgets.
/// ─────────────────────────────────────────────────────────────────────────────

/// Alias for backward compatibility with main.dart
abstract class AppThemes {
  static ThemeData get lightTheme => AppTheme.lightTheme;
  static ThemeData get darkTheme => AppTheme.darkTheme;
}

abstract class AppTheme {
  // ─────────────────────────────────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    extensions: const [AppColors.light],

    // ── Color Scheme ──────────────────────────────────────────────────────
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primarySurface,
      onPrimaryContainer: AppColors.primaryDark,

      secondary: AppColors.successColor,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.successLight,
      onSecondaryContainer: AppColors.successDark,

      tertiary: AppColors.reward,
      onTertiary: AppColors.white,
      tertiaryContainer: AppColors.rewardSurface,
      onTertiaryContainer: AppColors.warningDark,

      error: AppColors.errorColor,
      onError: AppColors.white,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.errorDark,

      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.lightTextSecondary,

      outline: AppColors.lightBorder,
      outlineVariant: AppColors.grey200,
      shadow: AppColors.lightCardShadow,
      scrim: AppColors.lightOverlay,

      inverseSurface: AppColors.grey900,
      onInverseSurface: AppColors.grey50,
      inversePrimary: AppColors.primaryLight,
    ),

    // ── Scaffold ──────────────────────────────────────────────────────────
    scaffoldBackgroundColor: AppColors.lightBackground,

    // ── Typography ────────────────────────────────────────────────────────
    textTheme: AppTypography.textTheme,
    fontFamily: 'DM Sans', // fallback
    // ── AppBar ────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.lightCardShadow,
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      titleTextStyle: AppTypography.h4.copyWith(
        color: AppColors.lightTextPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
        size: 24,
      ),
    ),

    // ── Bottom Navigation Bar ─────────────────────────────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey400,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTypography.labelXs.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      unselectedLabelStyle: AppTypography.labelXs.copyWith(
        color: AppColors.grey400,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    // ── Navigation Bar (Material 3) ───────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.primarySurface,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: 24);
        }
        return const IconThemeData(color: AppColors.grey400, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelXs.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          );
        }
        return AppTypography.labelXs.copyWith(color: AppColors.grey400);
      }),
      height: AppSpacing.bottomNavHeight,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    // ── Elevated Button ───────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: AppColors.grey200,
            disabledForegroundColor: AppColors.grey400,
            elevation: 0,
            shadowColor: Colors.transparent,
            minimumSize: const Size(double.infinity, 52),
            maximumSize: const Size(double.infinity, 52),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: AppRadius.buttonShape,
            textStyle: AppTypography.labelLg,
            splashFactory: InkRipple.splashFactory,
            animationDuration: AppDurations.fast,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.white.withValues(alpha: 0.12);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.white.withValues(alpha: 0.06);
              }
              return null;
            }),
          ),
    ),

    // ── Outlined Button ───────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.grey400,
        minimumSize: const Size(double.infinity, 52),
        maximumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: AppRadius.buttonShape,
        side: const BorderSide(color: AppColors.lightBorder, width: 1.5),
        textStyle: AppTypography.labelLg.copyWith(color: AppColors.primary),
        animationDuration: AppDurations.fast,
      ),
    ),

    // ── Text Button ───────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: AppRadius.buttonShape,
        textStyle: AppTypography.labelMd.copyWith(color: AppColors.primary),
        animationDuration: AppDurations.fast,
      ),
    ),

    // ── Floating Action Button ────────────────────────────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.pill),
      extendedTextStyle: AppTypography.labelLg.copyWith(color: AppColors.white),
    ),

    // ── Card ──────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      shadowColor: AppColors.lightCardShadow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: AppRadius.cardShape,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),

    // ── Input / TextField ─────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.grey400),
      labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.grey500),
      floatingLabelStyle: AppTypography.labelSm.copyWith(
        color: AppColors.primary,
      ),
      errorStyle: AppTypography.labelSm.copyWith(color: AppColors.errorColor),
      helperStyle: AppTypography.labelSm.copyWith(color: AppColors.grey500),
      prefixIconColor: AppColors.grey400,
      suffixIconColor: AppColors.grey400,
      border: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.errorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.grey200, width: 1.5),
      ),
    ),

    // ── Chip ─────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurfaceVariant,
      selectedColor: AppColors.primarySurface,
      disabledColor: AppColors.grey100,
      deleteIconColor: AppColors.grey500,
      labelStyle: AppTypography.labelMd.copyWith(
        color: AppColors.lightTextPrimary,
      ),
      secondaryLabelStyle: AppTypography.labelMd.copyWith(
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: const StadiumBorder(),
      side: const BorderSide(color: AppColors.lightBorder, width: 1),
      showCheckmark: false,
      elevation: 0,
      pressElevation: 0,
    ),

    // ── Dialog ────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: AppRadius.dialogShape,
      titleTextStyle: AppTypography.h3.copyWith(
        color: AppColors.lightTextPrimary,
      ),
      contentTextStyle: AppTypography.bodyMd.copyWith(
        color: AppColors.lightTextSecondary,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    ),

    // ── Bottom Sheet ──────────────────────────────────────────────────────
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r24),
        ),
      ),
      dragHandleColor: AppColors.grey300,
      dragHandleSize: Size(40, 4),
      showDragHandle: true,
      clipBehavior: Clip.antiAlias,
    ),

    // ── Snack Bar ─────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.grey900,
      contentTextStyle: AppTypography.bodyMd.copyWith(color: AppColors.white),
      actionTextColor: AppColors.primaryLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      insetPadding: const EdgeInsets.all(16),
      elevation: 0,
    ),

    // ── Switch ────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.white;
        return AppColors.grey400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.grey200;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),

    // ── Checkbox ──────────────────────────────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      side: const BorderSide(color: AppColors.grey300, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xs),
    ),

    // ── Radio ─────────────────────────────────────────────────────────────
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.grey300;
      }),
    ),

    // ── Tab Bar ───────────────────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.grey400,
      labelStyle: AppTypography.labelMd.copyWith(color: AppColors.primary),
      unselectedLabelStyle: AppTypography.labelMd.copyWith(
        color: AppColors.grey400,
      ),
      dividerColor: AppColors.lightBorder,
      splashFactory: InkRipple.splashFactory,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.primarySurface;
        }
        return null;
      }),
    ),

    // ── List Tile ─────────────────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      minLeadingWidth: 24,
      minVerticalPadding: 12,
      titleTextStyle: AppTypography.bodyLgMedium.copyWith(
        color: AppColors.lightTextPrimary,
      ),
      subtitleTextStyle: AppTypography.bodyMd.copyWith(
        color: AppColors.lightTextSecondary,
      ),
      leadingAndTrailingTextStyle: AppTypography.labelMd.copyWith(
        color: AppColors.grey500,
      ),
      iconColor: AppColors.grey500,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
    ),

    // ── Divider ───────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
      space: 1,
      indent: 0,
      endIndent: 0,
    ),

    // ── Icon ──────────────────────────────────────────────────────────────
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary, size: 24),

    // ── Progress Indicator ────────────────────────────────────────────────
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.lightBorder,
      circularTrackColor: AppColors.lightBorder,
      linearMinHeight: 4,
    ),

    // ── Slider ────────────────────────────────────────────────────────────
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.lightBorder,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primarySurface,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      trackHeight: 4,
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTypography.labelSm.copyWith(
        color: AppColors.white,
      ),
    ),

    // ── Badge ─────────────────────────────────────────────────────────────
    badgeTheme: BadgeThemeData(
      backgroundColor: AppColors.errorColor,
      textColor: AppColors.white,
      smallSize: 8,
      largeSize: 18,
      textStyle: AppTypography.labelXs.copyWith(color: AppColors.white),
      padding: const EdgeInsets.symmetric(horizontal: 6),
    ),

    // ── Tooltip ───────────────────────────────────────────────────────────
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.grey900,
        borderRadius: AppRadius.sm,
      ),
      textStyle: AppTypography.labelSm.copyWith(color: AppColors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    // ── Page Transitions ──────────────────────────────────────────────────
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),

    // ── Splash / Highlight ────────────────────────────────────────────────
    splashFactory: InkRipple.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: AppColors.primarySurface,
  );

  /// Alias for main.dart compatibility: AppThemes.lightTheme
  static ThemeData get lightTheme => light;

  /// Alias for main.dart compatibility: AppThemes.darkTheme
  static ThemeData get darkTheme => dark;

  // ─────────────────────────────────────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────────────────────────────────────
  static ThemeData get dark => light.copyWith(
    brightness: Brightness.dark,
    extensions: const [AppColors.dark],
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: AppTypography.darkTextTheme,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.white,
      primaryContainer: Color(0xFF1E3A6E),
      onPrimaryContainer: AppColors.primaryLight,

      secondary: AppColors.successColor,
      onSecondary: AppColors.white,
      secondaryContainer: Color(0xFF064E3B),
      onSecondaryContainer: AppColors.successLight,

      tertiary: AppColors.reward,
      onTertiary: AppColors.white,
      tertiaryContainer: Color(0xFF451A03),
      onTertiaryContainer: AppColors.rewardLight,

      error: AppColors.flash,
      onError: AppColors.white,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: AppColors.flashLight,

      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkTextSecondary,

      outline: AppColors.darkBorder,
      outlineVariant: AppColors.grey700,
      shadow: AppColors.darkCardShadow,
      scrim: AppColors.darkOverlay,

      inverseSurface: AppColors.grey100,
      onInverseSurface: AppColors.grey900,
      inversePrimary: AppColors.primary,
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      centerTitle: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: AppTypography.h4.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),
    ),

    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      shadowColor: AppColors.darkCardShadow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: AppRadius.cardShape,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.grey600),
      labelStyle: AppTypography.bodyMd.copyWith(color: AppColors.grey500),
      floatingLabelStyle: AppTypography.labelSm.copyWith(
        color: AppColors.primaryLight,
      ),
      errorStyle: AppTypography.labelSm.copyWith(color: AppColors.flash),
      prefixIconColor: AppColors.grey500,
      suffixIconColor: AppColors.grey500,
      border: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.flash, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.flash, width: 2),
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r24),
        ),
      ),
      dragHandleColor: AppColors.grey600,
      dragHandleSize: Size(40, 4),
      showDragHandle: true,
      clipBehavior: Clip.antiAlias,
    ),

    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.darkSurface,
      indicatorColor: const Color(0xFF1E3A6E),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primaryLight, size: 24);
        }
        return const IconThemeData(color: AppColors.grey500, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelXs.copyWith(
            color: AppColors.primaryLight,
            fontWeight: FontWeight.w700,
          );
        }
        return AppTypography.labelXs.copyWith(color: AppColors.grey500);
      }),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
      space: 1,
    ),

    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary, size: 24),
  );
}
