import 'package:flutter/material.dart';

import '../Helpers/AppTextStyles/AppTextStyles.dart';

class CustomBottomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isEnabled;

  const CustomBottomButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor = isEnabled
        ? textColor
        : Colors.grey.shade600;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          title,
          style: AppTextStyles.regular(21.46).copyWith(
            height: 1.0,
            color: effectiveTextColor,
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
