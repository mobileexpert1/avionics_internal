import 'package:flutter/material.dart';

class CustomBottomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isComeFromCompare;
  final TextStyle fontStyle;

  const CustomBottomButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
    this.isComeFromCompare = false,
    required this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
      return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          title,
          style: fontStyle,
          // AppTextStyles.regular(
          //   21.46,
          // ).copyWith(height: 1.0, color: effectiveTextColor),
        ),
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: isComeFromCompare == false
                ? BorderRadius.circular(5)
                : BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
          ),
        ),
      ),
    );
  }
}
