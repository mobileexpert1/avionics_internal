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

  @override
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
  //     child: isWeb
  //         ? Row(
  //             children: List.generate(segments.length, (index) {
  //               final isSelected = selectedIndex == index;
  //
  //               return Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => onChanged?.call(index),
  //                   child: AnimatedContainer(
  //                     duration: const Duration(milliseconds: 250),
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       color: isSelected
  //                           ? AppColors.primaryDark
  //                           : Colors.transparent,
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: index == 0
  //                             ? const Radius.circular(20)
  //                             : Radius.zero,
  //                         topRight: index == segments.length - 1
  //                             ? const Radius.circular(20)
  //                             : Radius.zero,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       segments[index],
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         color: isSelected ? Colors.white : Colors.black54,
  //                         fontWeight: isSelected
  //                             ? FontWeight.w800
  //                             : FontWeight.w700,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }),
  //           )
  //         : Row(
  //             children: List.generate(segments.length, (index) {
  //               final isSelected = selectedIndex == index;
  //
  //               return Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => onChanged?.call(index),
  //                   child: AnimatedContainer(
  //                     duration: const Duration(milliseconds: 250),
  //                     alignment: Alignment.center,
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 4,
  //                       vertical: 12,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: isSelected
  //                           ? AppColors.primaryDark
  //                           : Colors.transparent,
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: index == 0
  //                             ? const Radius.circular(20)
  //                             : Radius.zero,
  //                         topRight: index == segments.length - 1
  //                             ? const Radius.circular(20)
  //                             : Radius.zero,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       segments[index],
  //                       textAlign: TextAlign.center,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                         fontSize: MediaQuery.of(context).size.width <= 375
  //                             ? 12
  //                             : MediaQuery.of(context).size.width <= 600
  //                             ? 13
  //                             : 14,
  //                         color: isSelected ? Colors.white : Colors.black54,
  //                         fontWeight: isSelected
  //                             ? FontWeight.w800
  //                             : FontWeight.w700,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             }),
  //           ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double fontSize;
    if (screenWidth <= 375) {
      fontSize = 12;
    } else if (screenWidth <= 600) {
      fontSize = 13;
    } else if (screenWidth <= 900) {
      fontSize = 14;
    } else {
      fontSize = 15;
    }

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
      child: Row(
        children: List.generate(segments.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged?.call(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 12,
                ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
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
