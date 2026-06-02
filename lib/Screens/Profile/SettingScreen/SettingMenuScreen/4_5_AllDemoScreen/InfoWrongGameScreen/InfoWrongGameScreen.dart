import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../../Helpers/CustomHeaderViewExpandable.dart';

class InfoWrongGameScreen extends StatefulWidget {
  final int screenIndex;
  final String gameTitle;

  const InfoWrongGameScreen({
    super.key,
    required this.screenIndex,
    required this.gameTitle,
  });

  @override
  State<InfoWrongGameScreen> createState() => _InfoWrongGameState();
}

class _InfoWrongGameState extends State<InfoWrongGameScreen> {

  String getTitle() {
    switch (widget.screenIndex) {
      case 1:
        return "Turbulence happens!";

      case 2:
        return "Your are still on course";

      default:
        return "Your are still on course";
    }
  }

  String getBottomTitle() {
    switch (widget.screenIndex) {
      case 1:
        return "Try Next Round";

      case 2:
        return "Continue Journey";

      default:
        return "Continue Journey";
    }
  }

  String getImage() {
    switch (widget.screenIndex) {
      case 1:
        return AssetsPath.infoWrongFirst;

      case 2:
        return AssetsPath.infoWrongSecond;

      default:
        return AssetsPath.infoWrongThird;
    }
  }

  Widget buildDescription() {
    if (widget.screenIndex == 1) {
      return Text(
        "Not every flight is smooth. Adjust your\ncourse and keep climbing.",
        textAlign: TextAlign.center,
        style: AppTextStyles.semiRegular(
          16,
        ).copyWith(
          height: 1.4,
          color: AppColors.black,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.semiRegular(
          16,
        ).copyWith(
          height: 1.3,
          color: AppColors.black,
        ),
        children: [
          const TextSpan(
            text:
            "You're navigating through some\nchallenging airspace.\n",
          ),

          TextSpan(
            text: "Keep going!\n",
            style: AppTextStyles.bold(
              18,
            ).copyWith(
              color: AppColors.black,
              height: 1.9,
            ),
          ),

          const TextSpan(
            text:
            "Every answer gets you closer to your\ndestination.",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.gameTitle,
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.black,
              width: 1,
            ),
          ),
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
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        CommonUi.setSvgImage(
                          AssetsPath.gameInfoClose,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTitle(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bold(
                      20,
                    ).copyWith(
                      height: 0.9,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset(
                  CommonUi.setPngImage(
                    getImage(),
                  ),
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              buildDescription(),

              if (widget.screenIndex == 1)
                Text(
                  "You've got this!",
                  style: AppTextStyles.semiRegular(
                    18,
                  ).copyWith(
                    height: 3.0,
                    color: AppColors.black,
                  ),
                ),

              const SizedBox(height: 30),

              CustomHeaderViewExpandable(
                isNeedToShowLeftRightBottomBorder: false,
                isNeedToShowLeftImage: false,
                isExpanded: false,
                title: getBottomTitle(),
                headerColor: AppColors.primaryDark,
                arrowBackgroundColor:
                AppColors.extraDarkYellow,
                arrowFrontColor: Colors.black,
                isExpandedViewAvailable: true,
                fontStyle: AppTextStyles.regular(18).copyWith(
                  height: 1.4,
                  color: AppColors.white,
                  letterSpacing: 0.2,
                ),
                isLeftImage: IconButton(
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(
                      AssetsPath.homeLiveTracking,
                    ),
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                  onPressed: () async {},
                ),
                onHeaderTap: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}