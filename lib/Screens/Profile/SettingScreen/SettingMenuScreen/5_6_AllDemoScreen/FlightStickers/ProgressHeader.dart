import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                      ).copyWith(color: AppColors.primaryBlue),
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

          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              const planeSize = 30.0;
              const barHeight = 9.0;

              final planePosition = (constraints.maxWidth) * progress;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: barHeight,
                      width: planePosition + (planeSize / 2),
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),

                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    left: planePosition + (progress == 1.0 ? -15 : 15),
                    top: (planeSize - 51) / 2,

                    child: Transform.rotate(
                      angle: math.pi / 2,
                      child: Icon(
                        Icons.airplanemode_active,
                        size: planeSize,
                        color: progressColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (isCompleted)
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 8,
                right: 8,
              ),
              child: Column(
                children: [
                  Text(
                    "You have collected all $total parts of the Airplane",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular(
                      isDesktopWeb ? 14 : 15,
                    ).copyWith(
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: isDesktopWeb ? 280 : 190,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: onView3DAircraft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4797DB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "View 3D Aircraft",
                        style: AppTextStyles.regular(18).copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (bottomTitle != null && bottomTitle!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 8,
                right: 8,
              ),
              child: Text(
                bottomTitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(
                  isDesktopWeb ? 14 : 15,
                ).copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
