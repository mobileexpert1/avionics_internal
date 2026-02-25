import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSegmentController extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const CustomSegmentController({
    super.key,
    required this.segments,
    required this.selectedIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFFE9ECF3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(width: 2),
          left: BorderSide(width: 2),
          right: BorderSide(width: 2),
        ),
      ),
      child: Row(
        children: List.generate(segments.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged?.call(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1C1F3A)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Text(
                  segments[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight:
                    isSelected ? FontWeight.w800 : FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}