import 'package:flutter/material.dart';

class CustomBottomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final Widget icon;
  final VoidCallback onPressed;

  const CustomBottomButton({
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
          style: TextStyle(color: textColor, fontSize: 16),
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
