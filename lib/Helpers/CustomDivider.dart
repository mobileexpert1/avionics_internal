import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;
  final List<Color> colors;

  const CustomDivider({
    this.height = 2.0,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.colors = const [
      Color(0xFFE0E0E0), // Light top
      Color(0xFFBDBDBD), // Darker middle
      Color(0xFFE0E0E0), // Light bottom
    ],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }
}
