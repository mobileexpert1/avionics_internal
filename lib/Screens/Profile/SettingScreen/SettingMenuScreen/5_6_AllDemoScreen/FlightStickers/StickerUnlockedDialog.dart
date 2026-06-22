import 'package:flutter/material.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../FlightLog/AircraftCategoryModel.dart';

class StickerUnlockedDialog extends StatelessWidget {
  final AircraftCategoryModel category;
  final String stickerName;
  final String imagePath;
  final VoidCallback? onTap;

  const StickerUnlockedDialog({
    super.key,
    required this.category,
    required this.stickerName,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                  CommonUi.setGifImage(AssetsPath.badgeGif),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
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
                      19,
                    ).copyWith(height: 1.4, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category.letter,
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
                    category.title.replaceAll("\n", " "),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular(
                      14,
                    ).copyWith(color: AppColors.grayMedium),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
