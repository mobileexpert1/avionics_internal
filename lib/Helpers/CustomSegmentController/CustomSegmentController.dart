import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';

class CustomSegmentController extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final bool isWeb;

  const CustomSegmentController({
    super.key,
    required this.segments,
    required this.selectedIndex,
    this.onChanged,
    this.isWeb = false,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: 50,
  //     decoration: const BoxDecoration(
  //       color: AppColors.greyForAirportDetailCard,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //       border: Border(
  //         top: BorderSide(width: 1),
  //         left: BorderSide(width: 1),
  //         right: BorderSide(width: 1),
  //       ),
  //     ),
  //     child: Row(
  //       children: List.generate(segments.length, (index) {
  //         final isSelected = selectedIndex == index;
  //
  //         Widget tab = GestureDetector(
  //           onTap: () => onChanged?.call(index),
  //           child: AnimatedContainer(
  //             duration: const Duration(milliseconds: 250),
  //             alignment: Alignment.center,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 12,
  //               vertical: 12,
  //             ),
  //             decoration: BoxDecoration(
  //               color: isSelected
  //                   ? AppColors.primaryDark
  //                   : Colors.transparent,
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(20),
  //                 topRight: Radius.circular(20),
  //               ),
  //             ),
  //             child: Text(
  //               segments[index],
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(
  //                 color: isSelected ? Colors.white : Colors.black54,
  //                 fontWeight:
  //                 isSelected ? FontWeight.w800 : FontWeight.w700,
  //               ),
  //             ),
  //           ),
  //         );
  //
  //         return isWeb
  //             ? Expanded(child: tab)
  //             : tab;
  //       }),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.greyForAirportDetailCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(width: 1),
          left: BorderSide(width: 1),
          right: BorderSide(width: 1),
        ),
      ),
      child: isWeb
          ? Row(
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
                            ? AppColors.primaryDark
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: index == 0
                              ? const Radius.circular(20)
                              : Radius.zero,
                          topRight: index == segments.length - 1
                              ? const Radius.circular(20)
                              : Radius.zero,
                        ),
                      ),
                      child: Text(
                        segments[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(segments.length, (index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => onChanged?.call(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width <= 375
                            ? 8
                            : 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryDark
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        segments[index],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
