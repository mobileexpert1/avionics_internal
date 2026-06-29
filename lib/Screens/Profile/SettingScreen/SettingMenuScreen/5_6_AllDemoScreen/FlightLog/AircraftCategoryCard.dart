import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';

import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
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
                style: AppTextStyles.medium(
                  19,
                ).copyWith(height: 1.4, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Text(
                category.title,
                style: AppTextStyles.bold(
                  15,
                ).copyWith(height: 1.4, color: AppColors.primaryDark),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${category.unlockedCount}",

                        style: AppTextStyles.medium(
                          15,
                        ).copyWith(color: AppColors.primaryBlue),
                      ),

                      TextSpan(
                        text: "/${category.totalCount}",
                        style: AppTextStyles.medium(
                          15,
                        ).copyWith(color: AppColors.primaryDark),
                      ),
                    ],
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
                      right: 8,
                      top: -8,
                      child: Image.asset(
                        category.image,
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
