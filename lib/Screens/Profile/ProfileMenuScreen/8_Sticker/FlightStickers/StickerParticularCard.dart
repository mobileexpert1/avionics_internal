import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../../bloc/Games/SubGameSection/StickerData/StickerParticularDetails/StickerParticular_model.dart';
import '../../../../../bloc/Profile/AirmanshipBadges/AirmanshipBadgeModel.dart';
//
// class StickerCard extends StatelessWidget {
//   final StickerAircraft sticker;
//   final VoidCallback? onTap;
//
//   const StickerCard({super.key, required this.sticker, this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
//
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xffE5E7EB)),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.04),
//               blurRadius: 5,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 4,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 child: _buildImage(isDesktopWeb),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child:
//                   // Padding(
//                   //   padding: const EdgeInsets.all(5),
//                   //   child:
//                   Column(
//                     children: [
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             sticker.model,
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: AppTextStyles.bold(16).copyWith(
//                               color: AppColors.primaryDark,
//                               height: 1.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         sticker.icaoCode,
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTextStyles.bold(
//                           20,
//                         ).copyWith(color: AppColors.primaryDark, height: 1.0),
//                       ),
//                       SizedBox(height: 6),
//                     ],
//                   ),
//               //),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImage(bool isDesktopWeb) {
//     if (sticker.unlocked) {
//       return CachedAnyImage(
//         imagePath: sticker.image ?? '',
//         width: double.infinity,
//         height: double.infinity,
//         contentImage: BoxFit.fill,
//         isForStickerScreen: true,
//       );
//     }
//
//     return Container(
//       color: AppColors.grayLight,
//       child: Center(
//         child: SvgPicture.asset(
//           CommonUi.setSvgImage(AssetsPath.dummyAircraftImage),
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }

class StickerCard extends StatelessWidget {
  final StickerAircraft? sticker;
  final AirmanshipBadgeItemModel? airmanshipBadge;
  final VoidCallback? onTap;

  const StickerCard({
    super.key,
    this.sticker,
    this.airmanshipBadge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;

    final String title = sticker?.model ?? airmanshipBadge?.title ?? '';

    final String code = sticker?.icaoCode ?? '';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: _buildImage(),
              ),
            ),

            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bold(
                          16,
                        ).copyWith(color: AppColors.primaryDark, height: 1.0),
                      ),
                    ),
                  ),

                  if (code.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      code,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bold(
                        20,
                      ).copyWith(color: AppColors.primaryDark, height: 1.0),
                    ),
                  ],

                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (airmanshipBadge != null) {
      return Container(
        color: AppColors.grayLight,
        child: Center(
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.dummyAircraftImage),
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // Sticker aircraft
    if (sticker?.unlocked == true) {
      return CachedAnyImage(
        imagePath: sticker?.image ?? '',
        width: double.infinity,
        height: double.infinity,
        contentImage: BoxFit.fill,
        isForStickerScreen: true,
      );
    }

    return Container(
      color: AppColors.grayLight,
      child: Center(
        child: SvgPicture.asset(
          CommonUi.setSvgImage(AssetsPath.dummyAircraftImage),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
