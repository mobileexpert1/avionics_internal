import 'package:flutter/cupertino.dart';

class StepIndicator extends StatelessWidget {
  final int total;
  final int current;

  const StepIndicator({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 20,
          height: 4,
          decoration: BoxDecoration(
            color: index == current
                ? const Color(0xFF3D8EFF)
                : const Color(0xFFD0D0DA),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
