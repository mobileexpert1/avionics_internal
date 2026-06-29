import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Constants/AppColors.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../Helpers/CustomHeaderViewExpandable.dart';

class InfoWrongGameScreen extends StatefulWidget {
  final int screenIndex;
  final String gameTitle;
  final VoidCallback? callBackForMoveToNextScreen;


  const InfoWrongGameScreen({
    super.key,
    this.callBackForMoveToNextScreen,
    required this.screenIndex,
    required this.gameTitle,
  });

  @override
  State<InfoWrongGameScreen> createState() => _InfoWrongGameState();
}

class _InfoWrongGameState extends State<InfoWrongGameScreen> {

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    final contentWidth = kIsWeb
        ? (screenWidth > 1200 ? 700.0 : screenWidth * 0.7)
        : screenWidth * 0.9;

    final imageWidth = kIsWeb
        ? 350.0
        : screenWidth * 0.7;

    final imageHeight = kIsWeb
        ? 280.0
        : screenWidth * 0.6;

    final data = getImageAndDescription(widget.screenIndex);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.gameTitle,
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context);
            widget.callBackForMoveToNextScreen?.call();
          },
        ),
      ),
      body: Center(
        child: Container(
            width: contentWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.black, width: 1),
          ),
          child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      widget.callBackForMoveToNextScreen?.call();
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(AssetsPath.gameInfoClose),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data["title"] ?? "",
                    style: AppTextStyles.bold(
                      20,
                    ).copyWith(height: 1.0, color: AppColors.black),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              SizedBox(
                height: imageHeight,
                width: imageWidth,
                child: Image.asset(
                  CommonUi.setPngImage(data["image"] ?? ""),
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                data["description"] ?? "",
                textAlign: TextAlign.center,
                style: AppTextStyles.semiRegular(
                  18,
                ).copyWith(height: 1.4, color: AppColors.black),
              ),

              const SizedBox(height: 15),

              if (widget.screenIndex == 2 || widget.screenIndex == 3) ...[
                Text(
                  "Keep going!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold(
                    18,
                  ).copyWith(height: 1.4, color: AppColors.black),
                ),
                const SizedBox(height: 15),
              ],

              Text(
                data["hint"] ?? "",
                textAlign: TextAlign.center,
                style: AppTextStyles.semiRegular(
                  18,
                ).copyWith(height: 1.0, color: AppColors.black),
              ),

              SizedBox(height: 30),

              CustomHeaderViewExpandable(
                isNeedToShowLeftRightBottomBorder: false,
                isNeedToShowLeftImage: false,
                isExpanded: false,
                title: "Continue Journey",
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
                onHeaderTap: () async {
                  Navigator.pop(context);
                  widget.callBackForMoveToNextScreen?.call();
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

Map<String, String> getImageAndDescription(int index) {
  switch (index) {
    case 1:
      return {
        "image": AssetsPath.infoWrongFirst,
        "description":
            "Not every flight is smooth. Adjust your course and keep climbing.",
        "hint": "You've got this!",
        "title": "Turbulence happens!",
      };

    case 2:
      return {
        "image": AssetsPath.infoWrongSecond,
        "description": "You're navigating through some challenging airspace.",
        "hint": "Every answer gets you closer to your destination.",
        "title": "Your are still on course",
      };

    default:
      return {
        "image": AssetsPath.infoWrongThird,
        "description": "You're navigating through some challenging airspace.",
        "hint": "Every answer gets you closer to your destination.",
        "title": "Your are still on course",
      };
  }
}
