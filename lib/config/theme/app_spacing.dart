import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppSpacing — All spacing values on an 8pt grid.
//
// HOW TO USE:
//   Padding(padding: EdgeInsets.all(AppSpacing.md))
//   SizedBox(height: AppSpacing.lg)
//   gap16   ← shorthand SizedBox widget for rows/columns
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppSpacing {
  static const double xxs  =  2.0;
  static const double xs   =  4.0;
  static const double sm   =  8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double xxl  = 48.0;
  static const double xxxl = 64.0;

  // ── Semantic aliases ────────────────────────────────────────────────────────
  static const double screenPadding      = 20.0; // left/right screen padding
  static const double cardPadding        = 16.0;
  static const double cardPaddingSmall   = 12.0;
  static const double sectionGap         = 28.0; // between page sections
  static const double itemGap            = 12.0; // between list/grid items
  static const double iconTextGap        =  6.0; // icon + text spacing
  static const double bottomNavHeight    = 72.0;
  static const double appBarHeight       = 56.0;
  static const double floatingCartBottom = 88.0; // above bottom nav

  // ── Shorthand gap widgets ────────────────────────────────────────────────────
  static const Widget gap2  = SizedBox(width: 2,  height: 2);
  static const Widget gap4  = SizedBox(width: 4,  height: 4);
  static const Widget gap8  = SizedBox(width: 8,  height: 8);
  static const Widget gap12 = SizedBox(width: 12, height: 12);
  static const Widget gap16 = SizedBox(width: 16, height: 16);
  static const Widget gap20 = SizedBox(width: 20, height: 20);
  static const Widget gap24 = SizedBox(width: 24, height: 24);
  static const Widget gap32 = SizedBox(width: 32, height: 32);
  static const Widget gap48 = SizedBox(width: 48, height: 48);

  // ── EdgeInsets presets ───────────────────────────────────────────────────────
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenV = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets screen  = EdgeInsets.symmetric(horizontal: screenPadding, vertical: md);
  static const EdgeInsets cardAll = EdgeInsets.all(cardPadding);
  static const EdgeInsets cardSm  = EdgeInsets.all(cardPaddingSmall);
}

// ─────────────────────────────────────────────────────────────────────────────
// AppRadius — Border radius tokens.
//
// HOW TO USE:
//   decoration: BoxDecoration(borderRadius: AppRadius.cardRadius)
//   borderRadius: AppRadius.r8
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppRadius {
  static const double r4  =  4.0;
  static const double r6  =  6.0;
  static const double r8  =  8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;
  static const double full = 999.0; // pill / circle

  // ── BorderRadius presets ────────────────────────────────────────────────────
  static final BorderRadius xs      = BorderRadius.circular(r4);
  static final BorderRadius sm      = BorderRadius.circular(r8);
  static final BorderRadius md      = BorderRadius.circular(r12);
  static final BorderRadius card    = BorderRadius.circular(r16); // default card
  static final BorderRadius lg      = BorderRadius.circular(r20);
  static final BorderRadius xl      = BorderRadius.circular(r24);
  static final BorderRadius pill    = BorderRadius.circular(full);
  static final BorderRadius circle  = BorderRadius.circular(full);

  // Bottom sheet: only top corners rounded
  static final BorderRadius bottomSheet = const BorderRadius.vertical(
    top: Radius.circular(r24),
  );

  // Card with image on top: top corners only
  static final BorderRadius cardTop = const BorderRadius.vertical(
    top: Radius.circular(r16),
  );

  // ── RoundedRectangleBorder presets (for buttons, dialogs) ──────────────────
  static RoundedRectangleBorder shape(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  static const RoundedRectangleBorder buttonShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(r12)));

  static const RoundedRectangleBorder chipShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(full)));

  static const RoundedRectangleBorder cardShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(r16)));

  static const RoundedRectangleBorder dialogShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(r24)));
}

// ─────────────────────────────────────────────────────────────────────────────
// AppShadows — Elevation/shadow system.
//
// HOW TO USE:
//   decoration: BoxDecoration(boxShadow: AppShadows.sm)
//   Material(elevation: 0, child: ...)  ← use custom shadows, not Material elevation
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppShadows {
  // None
  static const List<BoxShadow> none = [];

  // xs — subtle lift for chips, badges
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A000000), // 4%
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  // sm — cards, input fields
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F000000), // 6%
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x05000000), // 2%
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  // md — elevated cards, floating buttons
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000), // 8%
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4%
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  // lg — bottom sheets, dialogs, FAB
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A000000), // 10%
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4%
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  // xl — overlays, full-screen modals
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x29000000), // 16%
      offset: Offset(0, 16),
      blurRadius: 48,
      spreadRadius: -8,
    ),
  ];

  // primary — colored shadow for primary buttons/CTAs
  static const List<BoxShadow> primary = [
    BoxShadow(
      color: Color(0x402563EB), // primary at 25%
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // success — green glow for success states
  static const List<BoxShadow> success = [
    BoxShadow(
      color: Color(0x3310B981), // success at 20%
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // reward — gold glow for reward elements
  static const List<BoxShadow> reward = [
    BoxShadow(
      color: Color(0x33D97706), // reward at 20%
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// AppDurations — Animation durations.
//
// HOW TO USE:
//   AnimatedContainer(duration: AppDurations.fast)
//   context.push('/screen', extra: {'duration': AppDurations.normal})
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppDurations {
  static const Duration instant  = Duration(milliseconds: 0);
  static const Duration fast     = Duration(milliseconds: 150);
  static const Duration normal   = Duration(milliseconds: 250);
  static const Duration medium   = Duration(milliseconds: 350);
  static const Duration slow     = Duration(milliseconds: 500);
  static const Duration slower   = Duration(milliseconds: 800);
  static const Duration slowest  = Duration(milliseconds: 1200);
  static const Duration lottie   = Duration(milliseconds: 2000);

  // Page transitions
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration bottomSheet    = Duration(milliseconds: 280);

  // Specific use cases
  static const Duration bannerAutoScroll = Duration(seconds: 4);
  static const Duration splashMinimum    = Duration(seconds: 2);
  static const Duration pointsCounter    = Duration(milliseconds: 1200);
  static const Duration otpResend        = Duration(seconds: 60);
}

// ─────────────────────────────────────────────────────────────────────────────
// AppCurves — Animation curves.
// ─────────────────────────────────────────────────────────────────────────────
abstract class AppCurves {
  static const Curve standard    = Curves.easeInOut;
  static const Curve enter       = Curves.easeOut;
  static const Curve exit        = Curves.easeIn;
  static const Curve spring      = Curves.elasticOut;
  static const Curve bouncy      = Curves.bounceOut;
  static const Curve decelerate  = Curves.decelerate;
  static const Curve sharp       = Curves.easeInOutCubic;
  static const Curve gentle      = Curves.easeInOutSine;
}
