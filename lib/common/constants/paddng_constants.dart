import 'package:flutter/material.dart';

class PaddingConstants {
  // all padding
  static const a0 = EdgeInsets.zero;
  static const a4 = EdgeInsets.all(4);
  static const a8 = EdgeInsets.all(8);
  static const a16 = EdgeInsets.all(16);

  // Horizontal padding
  static const h4 = EdgeInsets.symmetric(horizontal: 4);
  static const h8 = EdgeInsets.symmetric(horizontal: 8);
  static const h16 = EdgeInsets.symmetric(horizontal: 16);

  //Vertical padding
  static const v4 = EdgeInsets.symmetric(vertical: 4);
  static const v8 = EdgeInsets.symmetric(vertical: 8);
  static const v16 = EdgeInsets.symmetric(vertical: 16);

  static const l8 = EdgeInsets.only(left: 8);
  static const r8 = EdgeInsets.only(right: 8);
  static const t8 = EdgeInsets.only(top: 8);
  static const b8 = EdgeInsets.only(bottom: 8);

  static const l4 = EdgeInsets.only(left: 4);
  static const r4 = EdgeInsets.only(right: 4);
  static const t4 = EdgeInsets.only(top: 4);
  static const b4 = EdgeInsets.only(bottom: 4);

  // Other paddings
  static const onboardingPadding = EdgeInsets.fromLTRB(20, 0, 20, 50);
}
