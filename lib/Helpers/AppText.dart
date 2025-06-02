import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTexts extends StatelessWidget {
  final String text;
  final String? imageName;
  final String font;
  final String side; // "left" or "right"
  final Color color;
  final FontWeight weight;
  final double fontSize;
  final double imageSize;

  const AppTexts({
    Key? key,
    required this.text,
    this.imageName,
    required this.font,
    this.side = 'left',
    this.color = Colors.black,
    this.weight = FontWeight.normal,
    this.fontSize = 19,
    this.imageSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = imageName != null && imageName!.isNotEmpty;

    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: font,
        fontSize: fontSize,
        color: color,
        fontWeight: weight,
      ),
    );

    if (!hasImage) {
      return textWidget;
    }

    final isSvg = imageName!.toLowerCase().endsWith('.svg');

    final imageWidget = isSvg
        ? SvgPicture.asset(
      imageName!,
      width: imageSize,
      height: imageSize,
      fit: BoxFit.contain,
    )
        : Image.asset(
      imageName!,
      width: imageSize,
      height: imageSize,
      fit: BoxFit.contain,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: side == 'left'
          ? [imageWidget, const SizedBox(width: 8), textWidget]
          : [textWidget, const SizedBox(width: 8), imageWidget],
    );
  }
}
