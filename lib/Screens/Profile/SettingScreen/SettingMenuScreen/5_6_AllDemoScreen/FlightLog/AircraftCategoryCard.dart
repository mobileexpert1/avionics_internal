import 'package:flutter/material.dart';

import '../../../../../../Constants/constantImages.dart';
import 'AircraftCategoryModel.dart';

class AircraftCategoryCard extends StatelessWidget {
  final AircraftCategoryModel category;
  final VoidCallback? onTap;

  const AircraftCategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xff25235D),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                category.letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Text(
                category.title,
                style: const TextStyle(
                  color: Color(0xff25235D),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${category.unlockedCount}/${category.totalCount}",
                  style: const TextStyle(
                    color: Color(0xff4C9BE8),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),

                const Spacer(),

                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                      ),
                    ),

                    Positioned(
                      right: 10,
                      top: -20,
                      child: Image.asset(
                        CommonUi.setPngImage(AssetsPath.carFollowImage),
                        width: 90,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
