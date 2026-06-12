import 'package:flutter/material.dart';

import '../../../../../../Constants/constantImages.dart';
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    // image: DecorationImage(
                    //   image: AssetImage("assets/images/confetti_bg.png"),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  child: const Text(
                    "New Sticker\nUnlocked",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff25235D),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Category Letter
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category.letter,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    stickerName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff25235D),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    category.title.replaceAll("\n", " "),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff8E8E93),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onTap?.call();

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff25235D),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
    );
  }
}
