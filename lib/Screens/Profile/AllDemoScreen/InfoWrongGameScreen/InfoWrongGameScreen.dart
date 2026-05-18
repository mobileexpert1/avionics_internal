import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CustomHeaderViewExpandable.dart';

class InfoWrongGameScreen extends StatefulWidget {
  const InfoWrongGameScreen({super.key});

  @override
  State<InfoWrongGameScreen> createState() => _InfoWrongGameState();
}

class _InfoWrongGameState extends State<InfoWrongGameScreen> {
  @override
  void initState() {
    print(CommonUi.setSvgImage(AssetsPath.infoWrongFirst));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Game Info Hint Screen",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.black, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 25),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.gameInfoClose),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Turbulence happens!",
                    style: AppTextStyles.bold(
                      20,
                    ).copyWith(height: 1.0, color: AppColors.black),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.7,

                child: Image.asset(
                  CommonUi.setPngImage(AssetsPath.infoWrongFirst),
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Not every flight is smooth. Adjust your\ncourse and keep climbing.",
                textAlign: TextAlign.center,
                style: AppTextStyles.semiRegular(
                  18,
                ).copyWith(height: 1.4, color: AppColors.black),
              ),

              const SizedBox(height: 30),

              Text(
                "You've got this!",
                style: AppTextStyles.semiRegular(
                  18,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),

              const SizedBox(height: 30),

              CustomHeaderViewExpandable(
                isNeedToShowLeftRightBottomBorder: false,
                isNeedToShowLeftImage: false,
                isExpanded: false,
                title: "Try Next Round",
                headerColor: AppColors.primaryDark,
                arrowBackgroundColor: AppColors.extraDarkYellow,
                arrowFrontColor: Colors.black,
                isExpandedViewAvailable: true,
                fontStyle: AppTextStyles.regular(18).copyWith(
                  height: 1.4,
                  color: AppColors.white,
                  letterSpacing: 0.2,
                ),
                isLeftImage: IconButton(
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.homeLiveTracking),
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                  onPressed: () async {},
                ),
                onHeaderTap: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
