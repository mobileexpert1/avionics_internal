import 'package:flutter/material.dart';

import '../Helpers/AppTextStyles/AppTextStyles.dart';

class CustomSocialLoginButtons extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final Widget icon;
  final VoidCallback onPressed;

  const CustomSocialLoginButtons({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          title,
          style: AppTextStyles.regular(
            20.46,
          ).copyWith(height: 1.0, color: textColor),
        ),

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: backgroundColor == Colors.white
                  ? Colors.grey.shade300
                  : backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
