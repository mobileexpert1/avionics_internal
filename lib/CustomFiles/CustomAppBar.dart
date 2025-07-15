import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leftButton;
  final Widget? rightButton;
  final bool? centerTitle;
  final double? titleSpacing;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leftButton,
    this.rightButton,
    this.centerTitle,
    this.titleSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // subtle shadow color
            offset: Offset(0, 2), // move down
            blurRadius: 4, // soften the shadow
          ),
        ],
        border: const Border(
          bottom: BorderSide(
            color: AppColors.sepratorColourAppBar,
            width: 1.0,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent, // make AppBar background transparent
        elevation: 0, // remove AppBar's default shadow
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Color(0xFF151A6A)),
        ),
        centerTitle: centerTitle ?? true,
        titleSpacing: centerTitle == true ? titleSpacing : 0,
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
