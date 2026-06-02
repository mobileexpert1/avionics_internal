import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon(
    this.icon, {
    Key? key,
    required this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  final String icon;
  final VoidCallback onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(icon),
        padding: const EdgeInsets.all(5),
      ),
    );
  }
}
