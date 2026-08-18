import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class AviationChroniclePopup extends StatefulWidget {
  final VoidCallback onButtonTap;
  final VoidCallback onCancelButtonTap;

  const AviationChroniclePopup({
    super.key,
    required this.onButtonTap,
    required this.onCancelButtonTap,
  });

  @override
  State<AviationChroniclePopup> createState() => _AviationChroniclePopupState();
}

class _AviationChroniclePopupState extends State<AviationChroniclePopup> {
  bool isExpanded = false;

  static const Color navy = Color(0xFF14205C);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        CommonUi.setPngImage(AssetsPath.backgroundImagForPopup),
                      ),
                      fit: BoxFit.contain,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "AVIATION\n CHRONICLE",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold(32).copyWith(
                          height: 1.3,
                          letterSpacing: 2,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Stories That Shaped The Skies",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.medium(16).copyWith(
                          height: 1.3,
                          letterSpacing: 2,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const _DoubleLine(color: AppColors.black, isDouble: false),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.extraDarkYellow.withValues(alpha: 0.2),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.highlightStar),
                          height: 20,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "TODAY'S AVIATION FUN FACT",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.medium(14).copyWith(
                            height: 1.9,
                            letterSpacing: 0.2,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.highlightStar),
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const _DoubleLine(color: AppColors.black, isDouble: false),
                const SizedBox(height: 16),
                Text(
                  "THE FIRST NON-STOP\nTRANSATLANTIC FLIGHT",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semiBold(
                    16,
                  ).copyWith(height: 2.5, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 10),
                Text(
                  "In a feat that has captured the world's attention, "
                  "Charles A. Lindbergh has completed the first non-stop "
                  "solo flight across the Atlantic Ocean. His 33½-hour "
                  "journey from New York to Paris marks a new chapter in "
                  "aviation history—and a testament to courage, skill, "
                  "and the spirit of exploration.",
                  textAlign: TextAlign.center,
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: AppTextStyles.regular(
                    14,
                  ).copyWith(height: 1.7, color: AppColors.black),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 185,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isExpanded) {
                        setState(() {
                          isExpanded = true;
                        });
                      } else {
                        widget.onButtonTap();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isExpanded ? "Continue" : "Read More",
                          style: AppTextStyles.regular(
                            18,
                          ).copyWith(height: 1.0, color: AppColors.white),
                        ),
                        const SizedBox(width: 10),
                        if (!isExpanded)
                          SvgPicture.asset(
                            CommonUi.setSvgImage(AssetsPath.rightArrow),
                            height: 20,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),

          Positioned(
            top: 20,
            left: 30,
            right: 30,
            child: Row(
              children: [
                Expanded(
                  child: _DoubleLine(color: Colors.black, isDouble: true),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: const Icon(Icons.flight, color: navy, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DoubleLine(color: Colors.black, isDouble: true),
                ),
              ],
            ),
          ),

          Positioned(
            top: 8,
            right: 13,
            child: GestureDetector(
              onTap: () {
                widget.onCancelButtonTap();
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const Icon(Icons.close, size: 16, color: navy),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoubleLine extends StatelessWidget {
  final Color color;
  final bool isDouble;

  const _DoubleLine({
    this.color = const Color(0xFFF5C542),
    required this.isDouble,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 1.2, color: color),
        const SizedBox(height: 1),
        if (isDouble) Container(height: 1.2, color: color),
      ],
    );
  }
}
