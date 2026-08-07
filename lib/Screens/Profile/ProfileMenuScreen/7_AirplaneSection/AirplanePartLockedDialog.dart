import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../bloc/Profile/AirPlanePartsSection/AirPlanePartsModel.dart';

class AirplanePartLockedDialog extends StatelessWidget {
  final AirPlanePartsModel part;
  final VoidCallback? onContinue;

  const AirplanePartLockedDialog({
    super.key,
    required this.part,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: isDesktopWeb ? 330 : 300,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                left: 2,
                right: 2,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Part Image
                  Container(
                    width: isDesktopWeb ? 145 : 190,
                    height: isDesktopWeb ? 95 : 100,
                    decoration: BoxDecoration(
                      color: const Color(0xffE7E7E7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.45,
                          child: Image.asset(
                            part.image,
                            width: 110,
                            height: 75,
                            fit: BoxFit.contain,
                          ),
                        ),

                        SvgPicture.asset(
                          CommonUi.setSvgImage(
                            AssetsPath.badgesLockIcon,
                          ),
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                          color: AppColors.primaryDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Part Name
                  Text(
                    part.name,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bold(
                      19,
                    ).copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "This Aircraft part is Currently locked.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.medium(
                      14,
                    ).copyWith(
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Requirement Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F8FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffC8DDF7),
                      ),
                    ),
                    child: Text(
                      "Complete 10 more questions with a\n "
                          "score of at least 60% to unlock this\n "
                          "3D part.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.medium(
                        13,
                      ).copyWith(
                        color: AppColors.black,
                        height: 1.35,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Continue Button
                  SizedBox(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onContinue?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: AppTextStyles.regular(
                          13,
                        ).copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Close Button
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.black,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 13,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}