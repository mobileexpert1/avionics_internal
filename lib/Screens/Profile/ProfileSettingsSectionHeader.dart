import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/AppColors.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const SettingsSectionHeader({Key? key, required this.title, this.textStyle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, title == "" ? 0.0 : 30.0, 10.0, 10.0),
      child: Text(
        title,
        style:
            textStyle ??
            AppTextStyles.bold(
              20,
            ).copyWith(height: 1.0, color: AppColors.primaryValueColour),
      ),
    );
  }
}

class SettingsListItem extends StatelessWidget {
  final String? leadingSvgAsset;
  final String title;
  final VoidCallback? onTap;
  final Color? leadingIconColor;

  const SettingsListItem({
    Key? key,
    this.leadingSvgAsset,
    required this.title,
    this.onTap,
    this.leadingIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
        child: Row(
          children: [
            SvgPicture.asset(leadingSvgAsset!, width: 30, height: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.regular(
                  16,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.black),
          ],
        ),
      ),
    );
  }
}

class SettingsListGroup extends StatelessWidget {
  final String headerTitle;
  final TextStyle? headerTextStyle;
  final List<SettingsListItem> items;

  const SettingsListGroup({
    Key? key,
    required this.headerTitle,
    this.headerTextStyle,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: headerTitle, textStyle: headerTextStyle),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.dividerLineColourForComparison,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          child: Column(
            children: [
              ...List.generate(items.length, (index) {
                return Column(
                  children: [
                    items[index],
                    if (index != items.length - 1)
                      const Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: AppColors.dividerLineColourForComparison,
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
