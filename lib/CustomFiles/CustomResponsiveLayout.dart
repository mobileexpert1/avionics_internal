import 'package:flutter/material.dart';

class WebResponsiveStyle {
  final double titleFontSize;
  final double descFontSize;
  final double imageHeight;
  final double dotSize;
  final double horizontalPadding;

  WebResponsiveStyle._({
    required this.titleFontSize,
    required this.descFontSize,
    required this.imageHeight,
    required this.dotSize,
    required this.horizontalPadding,
  });

  factory WebResponsiveStyle.fromSize(Size size) {
    return WebResponsiveStyle._(
      titleFontSize: size.width * 0.025,
      descFontSize: size.width * 0.015,
      imageHeight: size.height * 0.4,
      dotSize: 10,
      horizontalPadding: size.width * 0.1,
    );
  }
}

