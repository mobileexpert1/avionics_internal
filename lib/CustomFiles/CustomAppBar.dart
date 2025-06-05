import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leftButton;
  final Widget? rightButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leftButton,
    this.rightButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // Remove default back button
      backgroundColor: Colors.white,
      elevation: 1,
      surfaceTintColor: Colors.white,
      shape: const Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
      centerTitle: true,
      leading: leftButton != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: leftButton!,
            )
          : null,
      actions: rightButton != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: rightButton!,
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
