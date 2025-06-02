import 'package:flutter/material.dart';

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
    final Color effectiveBgColor = isEnabled
        ? backgroundColor
        : Colors.grey.shade200;

    final Color effectiveTextColor = isEnabled
        ? textColor
        : Colors.grey.shade600;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          title,
          style: TextStyle(color: effectiveTextColor, fontSize: 16),
        ),
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor, // FIXED HERE
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
