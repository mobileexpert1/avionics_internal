import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EAF2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF3E3C55),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: const Color(0xFF4A90E2),
            inactiveTrackColor: const Color(0xFFE0E0E0),
            thumbColor: const Color(0xFF4A90E2),
            overlayColor: Colors.transparent,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8, // small dot
              elevation: 0,
              pressedElevation: 0,
            ),
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              min.toInt().toString(),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              ((min + max) ~/ 2).toString(),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              max.toInt().toString(),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
