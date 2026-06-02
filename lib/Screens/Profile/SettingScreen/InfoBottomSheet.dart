import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';

class InfoBottomSheet extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  final bool isComeFromLogout;
  final bool? isComeFromSubscription;

  const InfoBottomSheet({
    super.key,
    required this.onYes,
    required this.onNo,
    required this.isComeFromLogout,
    this.isComeFromSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth > 500
            ? 500
            : constraints.maxWidth;

        Widget content = Container(
          width: maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              SvgPicture.asset(
                CommonUi.setSvgImage(
                  isComeFromSubscription == false
                      ? (isComeFromLogout == true
                            ? AssetsPath.logoutProfile
                            : AssetsPath.deleteProfile)
                      : AssetsPath.crossIconSubscription,
                ),
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 20),

              Text(
                isComeFromSubscription == false
                    ? (isComeFromLogout
                          ? "Do you want to Logout\n account?"
                          : "Do you want to Delete\n account?")
                    : "Do you want to Cancel\n Subscription?",
                textAlign: TextAlign.center,
                style: AppTextStyles.bold(
                  22,
                ).copyWith(height: 1.0, color: AppColors.primaryValueColour),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: onYes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryValueColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Yes",
                          style: AppTextStyles.semiBold(
                            18,
                          ).copyWith(height: 1.4, color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: onNo,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.dividerLineColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "No",
                          style: AppTextStyles.semiBold(
                            18,
                          ).copyWith(height: 1.4, color: AppColors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );

        // Web -> Center, Mobile -> Bottom
        return kIsWeb
            ? Center(child: content)
            : Align(alignment: Alignment.bottomCenter, child: content);
      },
    );
  }
}
