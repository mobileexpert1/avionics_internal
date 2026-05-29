import 'package:flutter/material.dart';

import '../../../Constants/AppColors.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';

class SegmentedControl extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final Function(String) onChanged;

  const SegmentedControl({
    Key? key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.greyForAirportDetailCard,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selectedValue;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.regular(14).copyWith(
                    height: 1.0,
                    color: isSelected ? AppColors.black : AppColors.grayMedium,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
