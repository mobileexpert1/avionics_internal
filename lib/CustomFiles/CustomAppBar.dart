import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';

import '../Helpers/AppTextStyles/AppTextStyles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leftButton;
  final Widget? rightButton;
  final bool? centerTitle;
  final double? titleSpacing;
  final bool? isHideTopGradient;
  final bool? isForHomeScreen;
  final bool? isForComparison;
  final bool? isClearBackgroundColour;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leftButton,
    this.rightButton,
    this.centerTitle,
    this.titleSpacing,
    this.isHideTopGradient,
    this.isForHomeScreen,
    this.isForComparison,
    this.isClearBackgroundColour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isClearBackgroundColour == true
            ? Colors.white
            : AppColors.primaryDark,
        // boxShadow: [
        //   BoxShadow(
        //     color: isHideTopGradient == true ? Colors.white : Colors.black12,
        //     offset: const Offset(0, 2),
        //     blurRadius: 4,
        //   ),
        // ],
        border: isForComparison == true
            ? null
            : Border(
                bottom: BorderSide(
                  color: isHideTopGradient == true
                      ? Colors.white
                      : AppColors.separatorColourAppBar,
                  width: 1.0,
                ),
              ),
      ),
      child: AppBar(
        backgroundColor: isClearBackgroundColour == true
            ? Colors.white
            : Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.semiRegular(17.16).copyWith(
            height: 1.0,
            color: isClearBackgroundColour == true
                ? AppColors.blackForNavTitle
                : Colors.white,
          ),
        ),
        centerTitle: centerTitle ?? true,
        titleSpacing: centerTitle == true ? titleSpacing : 0,
        leading: leftButton != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: leftButton!,
                ),
              )
            : null,
        leadingWidth: isForHomeScreen == true ? 200 : 50,
        actions: rightButton != null
            ? [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: rightButton!,
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
