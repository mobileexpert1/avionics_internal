import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Outfit';

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    double height = 1.2,
    double letterSpacing = 0,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle regular(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w400, color: color);

  static TextStyle medium(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w500, color: color);

  static TextStyle semiBold(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w600, color: color);

  static TextStyle bold(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w700, color: color);

  static TextStyle thin(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w100, color: color);

  static TextStyle extraLight(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w200, color: color);

  static TextStyle light(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w300, color: color);

  static TextStyle extraBold(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w800, color: color);

  static TextStyle black(double size, {Color? color}) =>
      _base(size: size, weight: FontWeight.w900, color: color);

  static TextStyle regular14({Color? color}) => _base(
    size: 14,
    weight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: color,
  );
}



// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text("Thin (100)", style: AppTextStyles.thin(20)),
//
// Text("ExtraLight (200)", style: AppTextStyles.extraLight(20)),
//
// Text("Light (300)", style: AppTextStyles.light(20)),
//
// Text("Regular (400)", style: AppTextStyles.regular(20)),
//
// Text("Medium (500)", style: AppTextStyles.medium(20)),
//
// Text("SemiBold (600)", style: AppTextStyles.semiBold(20)),
//
// Text("Bold (700)", style: AppTextStyles.bold(20)),
//
// Text("ExtraBold (800)", style: AppTextStyles.extraBold(20)),
//
// Text("Black (900)", style: AppTextStyles.black(20)),
// ],
// ),