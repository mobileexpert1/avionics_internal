import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';

// Further Color Cutomization
extension CustomColorScheme on ColorScheme {
  Gradient get gradient => const LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xffFEFEFF), Color(0xffF318AD)],
  );

  Color get grey1 => const Color(0xff171C22);

  Color get grey2 => const Color(0xff212A35);

  Color get grey3 => const Color(0xff2E3A48);

  Color get grey4 => const Color(0xff5A6876);

  Color get grey5 => const Color(0xff828A93);

  Color get grey6 => const Color(0xffEAEBED);

  Color get grey7 => const Color(0xffFEFEFF);

  Color get cursor => Color.fromRGBO(30, 128, 242, 1.0);

  Color get historyBorder => brightness == Brightness.light ? secondary : grey4;

  Color get resultText => Color.fromRGBO(63, 61, 86, 1.0);

  Color get buttonText =>
      brightness == Brightness.light ? AppColors.calculatorTextColour : grey6;

  Color get opText => brightness == Brightness.light ? grey4 : grey5;

  Color get switchText => brightness == Brightness.light ? grey5 : grey4;
}
