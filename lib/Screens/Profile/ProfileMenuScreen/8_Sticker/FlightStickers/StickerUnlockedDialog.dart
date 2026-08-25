import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../Helpers/CacheManger/CachedImageFile.dart';

class StickerUnlockedDialog extends StatelessWidget {
  final String stickerName;
  final String letterCode;
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const StickerUnlockedDialog({
    super.key,
    required this.stickerName,
    required this.imagePath,
    this.onTap,
    required this.letterCode,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: isDesktopWeb
            ? 550
            : isMobileWeb
            ? screenWidth * 0.9
            : double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Image.asset(
                    CommonUi.setGifAndVideoImage(AssetsPath.badgeGif, false),
                    height: isDesktopWeb ? 140 : 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 24, bottom: 18),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      "New Sticker\nUnlocked",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold(
                        26,
                      ).copyWith(height: 1.4, color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(isDesktopWeb ? 20 : 10),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedAnyImage(
                        imagePath: imagePath,
                        width: double.infinity,
                        height: isDesktopWeb ? 230 : 170,
                        contentImage: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      width: isDesktopWeb ? 65 : 50,
                      height: isDesktopWeb ? 65 : 50,
                      decoration: BoxDecoration(
                        color: AppColors.extraDarkYellow,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letterCode,
                        style: AppTextStyles.medium(
                          20,
                        ).copyWith(color: AppColors.primaryDark),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      stickerName,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold(
                        20,
                      ).copyWith(color: AppColors.primaryDark),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      title.replaceAll("\n", " "),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular(
                        14,
                      ).copyWith(color: AppColors.grayMedium),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: SizedBox(
                        width: isDesktopWeb ? 320 : double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onTap?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Continue",
                            style: AppTextStyles.regular(
                              18,
                            ).copyWith(color: AppColors.white, height: 1.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
