import 'package:flutter/material.dart';

import '../../../Constants/AppColors.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';

class ExpandableSection extends StatelessWidget {
  final bool? isComeFromManufactureScreen;
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const ExpandableSection({
    Key? key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.isComeFromManufactureScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isComeFromManufactureScreen == false) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.regular(
                  18,
                ).copyWith(height: 1.0, color: AppColors.primaryDark),
              ),
              InkWell(
                onTap: onToggle,
                child: Row(
                  children: [
                    Text(
                      expanded ? "Show Less" : "Show More",
                      style: AppTextStyles.regular(
                        14,
                      ).copyWith(height: 1.0, color: AppColors.grayMedium),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: AppColors.grayMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        if (expanded) ...[const SizedBox(height: 10), child],
      ],
    );
  }
}
