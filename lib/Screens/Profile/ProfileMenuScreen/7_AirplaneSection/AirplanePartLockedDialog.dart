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
          borderRadius: BorderRadius.circular(20),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Part Image
                  // Part Image
                  Container(
                    width: isDesktopWeb ? 145 : 200,
                    height: isDesktopWeb ? 95 : 120,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDEDED),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.45,
                          child: Image.asset(
                            CommonUi.setPngImage(part.image),
                            width: isDesktopWeb ? 150 : 150,
                            height: isDesktopWeb ? 105 : 125,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.airplanemode_active,
                                size: isDesktopWeb ? 65 : 50,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),

                        SvgPicture.asset(
                          CommonUi.setSvgImage(
                            AssetsPath.badgesLockIcon,
                          ),
                          width: 30,
                          height: 30,
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
                    style: AppTextStyles.semiBold(
                      22,
                    ).copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "This Aircraft part is Currently locked.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.semiBold(
                      15,
                    ).copyWith(
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Requirement Box
                  Container(
                    width: double.infinity,
                    height: isDesktopWeb ? 95 : 90,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F8FF),
                      borderRadius: BorderRadius.circular(12),
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
                        15,
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: AppTextStyles.regular(
                          15,
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