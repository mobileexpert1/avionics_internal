import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/material.dart';

Widget customField({
  required String label,
  required String text,
  double? width,
  double? fontSize,
  bool showInfoIcon = false, // Toggle icon visibility
}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: fontSize != null ? fontSize - 2 : 13,
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
                  color: Colors.black,
                  fontSize: fontSize ?? 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showInfoIcon)
              Image.asset(CommonUi.setPngImage(AssetsPath.infoIcon))
          ],
        ),

        const Divider(
          height: 10,
          color: AppColors.sepratorColourAppBar,
          thickness: 2,
        ),
      ],
    ),
  );
}
