import 'dart:ui';

import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Screens/Onboarding/Splash/startExploringScreen.dart';
import 'package:avionics_internal/Screens/Onboarding/Splash/widgets/OnboardingPages.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../bloc/Onboarding/splashInfo/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.onBoardingScreen);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isWeb = kIsWeb;

    final double bottomControlsHeight = isWeb ? 60 : 100;
    final double imageHeight = isWeb ? size.height : size.height * 0.45;

    final List<OnboardingInfo> pages = [
      OnboardingInfo(
        title: ConstantStrings.title1,
        description: ConstantStrings.description1,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.splashUndrawAircraft, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.15,
                  bottom: size.width * 0.08,
                  left: size.width * 0.02,
                ),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.splashUndrawAircraft),
                  fit: BoxFit.fill,
                ),
              ),
        videoUrl: "",
      ),
      OnboardingInfo(
        title: ConstantStrings.title2,
        description: ConstantStrings.description2,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.splashMap, imageHeight)
            : SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.splashMap),
                width: size.width,
                height: size.height * 0.7,
                fit: BoxFit.cover,
              ),
        videoUrl: "",
      ),
      OnboardingInfo(
        title: ConstantStrings.title3,
        description: ConstantStrings.description3,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.splashCompareIcon, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.30,
                  bottom: size.width * 0.08,
                  left: size.width * 0.08,
                ),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.splashCompareIcon),
                  height: size.height * 0.40,
                  fit: BoxFit.fill,
                ),
              ),
        videoUrl: "",
      ),
      OnboardingInfo(
        title: ConstantStrings.title4,
        description: ConstantStrings.description4,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.splashFilter, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.30,
                  bottom: size.width * 0.08,
                  left: size.width * 0.08,
                ),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.splashFilter),
                  height: size.height * 0.40,
                  fit: BoxFit.contain,
                ),
              ),
        videoUrl: "",
      ),
      OnboardingInfo(
        title: ConstantStrings.title5,
        description: ConstantStrings.description5,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.splashInstantAI, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.35,
                  bottom: size.width * 0.08,
                ),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.splashInstantAI),
                  height: size.height * 0.40,
                  fit: BoxFit.contain,
                ),
              ),
        videoUrl: "",
      ),
      OnboardingInfo(
        title: ConstantStrings.title6,
        description: ConstantStrings.description6,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.splashQuiz, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.35,
                  bottom: size.width * 0.08,
                  left: size.width * 0.04,
                ),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.splashQuiz),
                  height: size.height * 0.40,
                  fit: BoxFit.contain,
                ),
              ),
        videoUrl: "",
      ),
      OnboardingInfo(
        title: "",
        description: "",
        imageWidget: Wrap(),
        videoUrl:
            "${ApiBaseUrlConstant.baseUrl}s3/manufacturer/aviation_tutorial.mp4",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: isWeb
              ? const BoxConstraints(maxWidth: 1500)
              : const BoxConstraints(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: bottomControlsHeight),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus,
                    },
                  ),
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      if (!mounted) return;
                      setState(() {
                        onLastPage = index == pages.length - 1;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPage(info: pages[index]);
                    },
                  ),
                ),
              ),

              // --- Indicator ---
              Positioned(
                bottom: size.height * (isWeb ? 0.06 : 0.115),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: WormEffect(
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey.shade300,
                    dotHeight: isWeb ? 12 : 10,
                    dotWidth: isWeb ? 12 : 10,
                  ),
                ),
              ),

              // --- Buttons ---
              Positioned(
                bottom: size.height * (isWeb ? 0.06 : 0.09),
                left: isWeb ? 60 : 30,
                right: isWeb ? 60 : 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (!mounted) return;
                        AppNavigator.pushReplacement(
                          context,
                          StartExploringApp(),
                          disableSwipeBack: true,
                        );
                      },
                      child: Text(
                        ConstantStrings.skip,
                        style: TextStyle(
                          color: AppColors.skip,
                          fontSize: isWeb ? 20 : 15,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (!mounted) return;

                        if (onLastPage) {
                          AppNavigator.pushReplacement(
                            context,
                            StartExploringApp(),
                            disableSwipeBack: true,
                          );
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        ConstantStrings.next,
                        style: TextStyle(
                          color: AppColors.next,
                          fontSize: isWeb ? 20 : 15,
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

  Widget _buildImage(String path, double height) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: SvgPicture.asset(CommonUi.setSvgImage(path)),
      ),
    );
  }
}
