import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/constantImages.dart';

class ImageBasedResultDialog extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final bool componentEarned;
  final String componentTitle;
  final String componentDescription;
  final VoidCallback? onContinue;

  const ImageBasedResultDialog({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.componentEarned,
    required this.componentTitle,
    required this.componentDescription,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;

    final double dialogWidth = isDesktopWeb ? 380 : 300;

    final double horizontalInset = isDesktopWeb ? 30 : 16;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontalInset,
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
        ),
        padding: EdgeInsets.fromLTRB(
          isDesktopWeb ? 18 : 12,
          isDesktopWeb ? 18 : 16,
          isDesktopWeb ? 18 : 12,
          isDesktopWeb ? 18 : 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  _handleContinue(context);
                },
                child: Container(
                  width: isDesktopWeb ? 24 : 22,
                  height: isDesktopWeb ? 24 : 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black87,
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    size: isDesktopWeb ? 15 : 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Plane icon
            Container(
              width: isDesktopWeb ? 80 : 70,
              height: isDesktopWeb ? 80 : 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff5799D8),
              ),
              child: Center(
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(
                    AssetsPath.planIcon,
                  ),
                  width: isDesktopWeb ? 45 : 40,
                  height: isDesktopWeb ? 45 : 40,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Score
            Text(
              '$correctAnswers/$totalQuestions',
              style: TextStyle(
                fontSize: isDesktopWeb ? 26 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xff201E48),
              ),
            ),

            const SizedBox(height: 8),

            // Result title
            Text(
              isSuccess
                  ? 'Component Earned!'
                  : 'Aircraft\nComponent locked!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDesktopWeb ? 26 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xff201E48),
              ),
            ),

            const SizedBox(height: 12),

            // Information container
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                isDesktopWeb ? 14 : 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF2F7FD),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xffC9E0F8),
                ),
              ),
              child: isSuccess
                  ? Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isDesktopWeb ? 45 : 38,
                        height: 1,
                        color: const Color(0xff5799D8),
                      ),

                      const SizedBox(width: 8),

                      Flexible(
                        child: Text(
                          componentTitle.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:
                            isDesktopWeb ? 21 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        width: isDesktopWeb ? 45 : 38,
                        height: 1,
                        color: const Color(0xff5799D8),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    componentDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktopWeb ? 13 : 12,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
                  : Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                    ),
                    child: SvgPicture.asset(
                      CommonUi.setSvgImage(
                        AssetsPath.badgesLockIcon,
                      ),
                      width: isDesktopWeb ? 15 : 14,
                      height: isDesktopWeb ? 15 : 14,
                      color: AppColors.primaryDark,
                    ),
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      'Score 60% or higher to unlock more '
                          'aircraft components and continue '
                          'building your aircraft.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                        isDesktopWeb ? 15 : 15,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Continue
            SizedBox(
              width: isDesktopWeb ? 155 : 140,
              height: isDesktopWeb ? 44 : 40,
              child: ElevatedButton(
                onPressed: () {
                  _handleContinue(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: isDesktopWeb ? 19 : 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isSuccess => componentEarned;


  void _handleContinue(BuildContext context) {
    Navigator.pop(context);

    if (onContinue != null) {
      onContinue!();
    }
  }
}
