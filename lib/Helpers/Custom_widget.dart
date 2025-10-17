import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget customField({
  required String label,
  required String text,
  double? width,
  double? fontSize,
  bool showInfoIcon = false,
  bool isDarkDivider = false,
  Color labelColor = Colors.white70,
  Color textColor = Colors.white,
}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: fontSize != null ? fontSize - 2 : 11,
          ),
        ),
        const SizedBox(height: 5),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize ?? 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showInfoIcon)
              SvgPicture.asset(CommonUi.setSvgImage(AssetsPath.infoIcon2))
          ],
        ),

        Divider(
          height: 10,
          color: isDarkDivider == false ? AppColors.sepratorColourAppBar : AppColors.darkSepratorColourAppBar,
          thickness: 2,
        ),
      ],
    ),
  );
}
