import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../bloc/Profile/AirPlanePartsSection/AirPlanePartsModel.dart';

class AirplanePartsCard extends StatelessWidget {
  final AirPlanePartsModel part;
  final int index;
  final VoidCallback? onTap;

  const AirplanePartsCard({
    super.key,
    required this.part,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;

    final bool isUnlocked = part.collectedCount >= part.totalCount;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isDesktopWeb ? 12 : 8),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : const Color(0xffD3D3D3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffE5E5E5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${part.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.medium(
                      isDesktopWeb ? 16 : 16,
                    ).copyWith(
                      color: isUnlocked
                          ? AppColors.black
                          : const Color(0xff666666),
                    ),
                  ),
                ),

                if (isUnlocked)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.tickIcon),
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            // Aircraft part image + lock
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: isUnlocked ? 1.0 : 0.45,
                      child: part.image.isNotEmpty
                          ? CachedAnyImage(
                              imagePath: part.image,
                              width: isDesktopWeb ? 150 : 150,
                              height: isDesktopWeb ? 105 : 125,
                              contentImage: BoxFit.contain,
                            )
                          : Icon(
                              Icons.airplanemode_active,
                              size: isDesktopWeb ? 65 : 50,
                              color: Colors.white,
                            ),
                    ),

                    if (!isUnlocked)
                      SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.badgesLockIcon),
                        width: isDesktopWeb ? 38 : 30,
                        height: isDesktopWeb ? 38 : 30,
                        fit: BoxFit.contain,
                        color: AppColors.primaryDark,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 3),

            // Progress
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${part.collectedCount}',
                    style: AppTextStyles.medium(
                      isDesktopWeb ? 15 : 14,
                    ).copyWith(color: const Color(0xff4797DB)),
                  ),
                  TextSpan(
                    text: '/',
                    style: AppTextStyles.medium(
                      isDesktopWeb ? 15 : 14,
                    ).copyWith(color: const Color(0xff201E48)),
                  ),
                  TextSpan(
                    text: '${part.totalCount}',
                    style: AppTextStyles.medium(
                      isDesktopWeb ? 15 : 14,
                    ).copyWith(color: const Color(0xff201E48)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
