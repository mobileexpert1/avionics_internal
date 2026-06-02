import 'package:flutter/material.dart';

class CustomAnimatedSwitcher extends StatelessWidget {
  const CustomAnimatedSwitcher({Key? key, required this.grid})
    : super(key: key);

  final Widget grid;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(scale: animation, child: child),
      child: grid,
    );
  }
}
