import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../../bloc/Games/SubGameSection/StickerData/StickerParticularDetails/StickerParticular_model.dart';

class StickerCard extends StatelessWidget {
  final StickerAircraft sticker;
  final VoidCallback? onTap;

  const StickerCard({super.key, required this.sticker, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;

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
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: _buildImage(isDesktopWeb),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sticker.model,
                      style: AppTextStyles.bold(
                        16,
                      ).copyWith(height: 1.0, color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sticker.icaoCode,
                      style: AppTextStyles.bold(
                        20,
                      ).copyWith(height: 1.0, color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isDesktopWeb) {
    if (!sticker.unlocked) {
      return CachedAnyImage(
        imagePath: sticker.image ?? '',
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
