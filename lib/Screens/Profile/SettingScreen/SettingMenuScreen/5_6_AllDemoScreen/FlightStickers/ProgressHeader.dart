import 'dart:math' as math;

import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class ProgressHeader extends StatelessWidget {
  final int unlocked;
  final int total;
  final String title;
  final String? bottomTitle;
  final bool isCompletedGreen;
  final VoidCallback? onView3DAircraft;

  const ProgressHeader({
    super.key,
    required this.unlocked,
    required this.total,
    required this.title,
    this.bottomTitle,
    this.isCompletedGreen = false,
    this.onView3DAircraft,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;

    final double horizontalPadding = isDesktopWeb
        ? 30
        : isMobileWeb
        ? 14
        : 16;

    final double titleSize = isDesktopWeb ? 20 : 16;
    final double countSize = isDesktopWeb ? 24 : 20;

    final double progress = total <= 0
        ? 0.0
        : (unlocked / total).clamp(0.0, 1.0);

    final bool isCompleted = total > 0 && unlocked >= total;

    final Color progressColor = isCompleted && isCompletedGreen
        ? const Color(0xFF9CD450)
        : const Color(0xFF4A90D9);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bold(
                    titleSize,
                  ).copyWith(color: AppColors.black),
                ),
              ),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$unlocked",
                      style: AppTextStyles.bold(
                        countSize,
                      ).copyWith(color: AppColors.primaryDark),
                    ),
                    TextSpan(
                      text: "/$total",
                      style: AppTextStyles.bold(
                        countSize,
                      ).copyWith(color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
            ],
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              const double planeSize = 30.0;
              const double barHeight = 9.0;
              const double horizontalPadding = 1.0;
              const double planeSpacing = 4.0;

              final double totalWidth =
                  constraints.maxWidth - (horizontalPadding * 2);

              final double barWidth = totalWidth - planeSize - planeSpacing;

              final bool isComplete = progress >= 1.0;

              final double progressWidth = isComplete
                  ? barWidth
                  : (barWidth * progress).clamp(0.0, barWidth);
              final double planeLeft = (progressWidth + planeSpacing).clamp(
                0.0,
                totalWidth - planeSize,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: SizedBox(
                  height: planeSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: isComplete ? planeSize + planeSpacing : 0,
                        top: (planeSize - barHeight) / 2,
                        child: Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        left: 0,
                        top: (planeSize - barHeight) / 2,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          width: progressWidth,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        left: planeLeft,
                        top: 0.5,
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.progressbarplaneIcon),
                          width: planeSize,
                          height: planeSize,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            progressColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          if (isCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
              child: Column(
                children: [
                  Text(
                    "You have collected all $total parts of the Airplane",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular(
                      isDesktopWeb ? 14 : 15,
                    ).copyWith(color: AppColors.black),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: isDesktopWeb ? 280 : 170,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onView3DAircraft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4797DB),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "View 3D Aircraft",
                          maxLines: 1,
                          style: AppTextStyles.regular(
                            18,
                          ).copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (bottomTitle != null && bottomTitle!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
              child: Text(
                bottomTitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(
                  isDesktopWeb ? 14 : 15,
                ).copyWith(color: AppColors.black),
              ),
            ),
        ],
      ),
    );
  }
}
