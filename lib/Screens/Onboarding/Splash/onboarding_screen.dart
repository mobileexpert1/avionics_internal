import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Screens/Onboarding/Splash/startExploringScreen.dart';
import 'package:avionics_internal/Screens/Onboarding/Splash/widgets/OnboardingPages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double textFontSize = size.width < 600 ? 13 : 16;

    final List<OnboardingInfo> pages = [
      OnboardingInfo(
        title: ConstantStrings.title1,
        description: ConstantStrings.description1,
        imageWidget: Padding(
          padding: EdgeInsets.only(top: size.width * 0.08, bottom: size.width * 0.08, left: size.width * 0.02),
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.undraw_aircraft_fbvl),
            fit: BoxFit.fill,
          ),
        ),
      ),
      OnboardingInfo(
        title: ConstantStrings.title2,
        description: ConstantStrings.description2,
        imageWidget: Padding(
          padding: EdgeInsets.zero,
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.map),
            width: size.width,
            height: size.height * 0.7,
            fit: BoxFit.cover,
          ),
        ),
      ),
      OnboardingInfo(
        title: ConstantStrings.title3,
        description: ConstantStrings.description3,
        imageWidget: Padding(
          padding: EdgeInsets.only(top: size.width * 0.30, bottom: size.width * 0.08, left: size.width * 0.08),
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.compare),
            height: size.height * 0.40,
            fit: BoxFit.fill,
          ),
        ),
      ),
      OnboardingInfo(
        title: ConstantStrings.title4,
        description: ConstantStrings.description4,
        imageWidget: Padding(
          padding: EdgeInsets.only(top: size.width * 0.30, bottom: size.width * 0.08, left: size.width * 0.08),
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.filter),
            height: size.height * 0.40,
            fit: BoxFit.contain,
          ),
        ),
      ),
      OnboardingInfo(
        title: ConstantStrings.title5,
        description: ConstantStrings.description5,
        imageWidget: Padding(
          padding: EdgeInsets.only(top: size.width * 0.35, bottom: size.width * 0.08),
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.instantAI),
            height: size.height * 0.40,
            fit: BoxFit.contain,
          ),
        ),
      ),
      OnboardingInfo(
        title: ConstantStrings.title6,
        description: ConstantStrings.description6,
        imageWidget: Padding(
          padding: EdgeInsets.only(top: size.width * 0.35, bottom: size.width * 0.08, left: size.width * 0.04),
          child: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.Quiz),
            height: size.height * 0.40,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = index == pages.length - 1;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(info: pages[index]);
                },
              ),
              Positioned(
                bottom: size.height * 0.09,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: WormEffect(
                      spacing: size.width * 0.04,
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey.shade300,
                      dotHeight: size.height * 0.010,
                      dotWidth: size.height * 0.010,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.07,
                left: size.width * 0.08,
                right: size.width * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StartExploringApp()),
                        );
                      },
                      child: Text(
                        ConstantStrings.skip,
                        style: TextStyle(
                          color: AppColors.skip,
                          fontSize: textFontSize,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (onLastPage) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StartExploringApp()),
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
                          fontSize: textFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
