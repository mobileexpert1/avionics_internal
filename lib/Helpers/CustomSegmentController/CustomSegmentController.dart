import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSegmentController extends StatefulWidget {
  final List<String> segments;
  final ValueChanged<int>? onChanged;

  const CustomSegmentController({
    super.key,
    required this.segments,
    this.onChanged,
  });

  @override
  State<CustomSegmentController> createState() =>
      _CustomSegmentControllerState();
}

class _CustomSegmentControllerState extends State<CustomSegmentController> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECF3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(20),
        ),
        border: const Border(
          top: BorderSide(width: 2),
          left: BorderSide(width: 2),
          right: BorderSide(width: 2),
        ),
      ),
      child: Row(
        children: List.generate(widget.segments.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onChanged?.call(index);
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
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
                      widget.segments[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w700,
                      ),
                    ),
                  ),

                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: AnimatedContainer(
                  //     duration: const Duration(milliseconds: 250),
                  //     height: 3,
                  //     color: isSelected
                  //         ?  Color(0xFF1C1F3A)
                  //         : Colors.transparent,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
