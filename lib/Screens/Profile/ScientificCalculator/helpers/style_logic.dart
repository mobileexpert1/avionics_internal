import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Constants/constantImages.dart';
import '../core/index.dart';

Color getButtonBgColor(String text, BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  switch (text) {
    case '%':
    case '( )':
    case 'C':
    case 'Rad':
    case 'Deg':
    case '√':
    case '∛':
    case 'switch':
      return Colors.white;
    case '=':
    case '+':
    case '-':
    case '×':
    case '÷':
      return Colors.white;
    default:
      return Colors.white;
  }
}

Color getTextColor(String text, BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  switch (text) {
    case '=':
    case '+':
    case '-':
    case '×':
    case '÷':
    case 'switch':
      return colorScheme.buttonText;
    case 'C':
      return AppColors.progressColour;
    default:
      return colorScheme.buttonText;
  }
}

double getTextSize(String text) {
  switch (text) {
    case '.':
      return 35;
    case '-':
    case '+':
    case '×':
    case '÷':
      return 27;
    default:
      return 21;
  }
}

Widget getOnButtonWidget(String text, BuildContext context) {
  final textStyle = TextStyle(
    fontSize: getTextSize(text),
    fontWeight: FontWeight.bold,
  );
  switch (text) {
    case 'switch':
      return Padding(
        padding: const EdgeInsets.all(3),
        child: ShaderMask(
          shaderCallback: (bounds) =>
              Theme.of(context).colorScheme.gradient.createShader(bounds),
          child: SvgPicture.asset(
            AssetsPath.switchLGridForCal,
            color: getTextColor(text, context),
          ),
        ),
      );
    default:
      return Text(text, style: textStyle);
  }
}
