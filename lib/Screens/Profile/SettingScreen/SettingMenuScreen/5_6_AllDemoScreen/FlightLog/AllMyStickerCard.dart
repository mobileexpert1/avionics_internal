import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../../../bloc/Games/SubGameSection/AllSticker/AllMySticker_model.dart';

class AircraftCategoryCard extends StatelessWidget {
  final StickerModel category;
  final VoidCallback? onTap;

  const AircraftCategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isDesktopWeb ? 18 : 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE8E8E8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isDesktopWeb ? 40 : 30,
              height: isDesktopWeb ? 40 : 30,
              decoration: const BoxDecoration(
                color: Color(0xff25235D),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                category.orderChar,
                style: AppTextStyles.medium(
                  isDesktopWeb ? 22 : 19,
                ).copyWith(color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bold(
                  isDesktopWeb ? 18 : 15,
                ).copyWith(color: AppColors.primaryDark),
              ),
            ),

            const SizedBox(height: 8),
            Flexible(
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${category.aircraftSummary.unlocked}",
                          style: AppTextStyles.medium(
                            isDesktopWeb ? 17 : 15,
                          ).copyWith(color: AppColors.primaryBlue),
                        ),
                        TextSpan(
                          text: "/${category.aircraftSummary.total}",
                          style: AppTextStyles.medium(
                            isDesktopWeb ? 17 : 15,
                          ).copyWith(color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Stack(
                  //   clipBehavior: Clip.none,
                  //   alignment: Alignment.center,
                  //   children: [
                  // Container(
                  //   width: isDesktopWeb ? 55 : 40,
                  //   height: isDesktopWeb ? 55 : 40,
                  //   decoration: BoxDecoration(
                  //     color: category.color,
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: isDesktopWeb ? 90 : 70,
                        height: isDesktopWeb ? 65 : 50,
                      ),

                      Positioned(
                        right: isDesktopWeb ? 6 : 4,
                        top: isDesktopWeb ? -10 : -6,
                        child: CachedAnyImage(
                          imagePath: category.icon,
                          width: isDesktopWeb ? 90 : 70,
                          height: isDesktopWeb ? 65 : 50,
                          contentImage: BoxFit.contain,
                        ),
                      ),
                    ],
                  )
                  // ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
