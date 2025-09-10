import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveWebWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  const ResponsiveWebWrapper({
    Key? key,
    required this.child,
    this.maxWidth = 450,
    this.padding = const EdgeInsets.all(16),
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding!,
            child: child,
          ),
        ),
      );
    } else {
      return Padding(
        padding: padding!,
        child: child,
      );
    }
  }
}
