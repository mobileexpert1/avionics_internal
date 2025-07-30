import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconDisplay extends StatelessWidget {
  final dynamic icon;  // Can be IconData, String (SVG path), or Widget

  IconDisplay({required this.icon});

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      // If it's IconData, display a regular Icon
      return Icon(
        icon as IconData,
        size: 15,
        color: Colors.white,
      );
    } else if (icon is String) {

      return SvgPicture.asset(
        icon as String,
        width: 10.0,
        height: 10.0,
        color: Colors.white,
      );
    } else if (icon is Widget) {


      return icon;
    }
    return Container();
  }
}
