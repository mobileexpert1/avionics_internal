import 'package:flutter/material.dart';

import '../Constants/AppColors.dart';
import 'AppTextStyles/AppTextStyles.dart';

class CustomSliderSection extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String label;
  final ValueChanged<double> onChanged;

  const CustomSliderSection({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.colorForFilterScreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: AppTextStyles.bold(
                12,
              ).copyWith(height: 1.0, color: AppColors.darkValueTextColour),
            ),
          ),
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5,
            activeTrackColor: AppColors.colorForFilterScreen,
            inactiveTrackColor: AppColors.colorForFilterScreen,
            thumbColor: AppColors.primaryBlue,
            overlayColor: Colors.transparent,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 0,
              pressedElevation: 0,
            ),
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),

        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                min.toInt().toString(),
                style: AppTextStyles.regular(
                  12,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),
              Text(
                ((min + max) ~/ 2).toString(),
                style: AppTextStyles.regular(
                  12,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),
              Text(
                max.toInt().toString(),
                style: AppTextStyles.regular(
                  12,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
