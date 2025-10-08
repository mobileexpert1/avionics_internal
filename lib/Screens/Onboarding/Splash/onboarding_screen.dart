import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Screens/Onboarding/Splash/startExploringScreen.dart';
import 'package:avionics_internal/Screens/Onboarding/Splash/widgets/OnboardingPages.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
    final size = MediaQuery.of(context).size;
    final bool isWeb = kIsWeb;

    // --- Adjust sizes for Chrome vs Mobile ---
    final double imageHeight = isWeb ? size.height * 0.55 : size.height * 0.45;
    final double titleFont = isWeb ? 22 : 20;
    final double descFont = isWeb ? 16 : 14;
    final double textPadding = isWeb ? 24 : 16;

    final List<OnboardingInfo> pages = [
      OnboardingInfo(
        title: ConstantStrings.title1,
        description: ConstantStrings.description1,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.undraw_aircraft_fbvl, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.15,
                  bottom: size.width * 0.08,
                  left: size.width * 0.02,
                ),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.undraw_aircraft_fbvl),
                  fit: BoxFit.fill,
                ),
              ),
      ),
      OnboardingInfo(
        title: ConstantStrings.title2,
        description: ConstantStrings.description2,
        imageWidget: isWeb
            ? _buildImage(AssetsPath.map, imageHeight)
            : Padding(
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
        imageWidget: isWeb
            ? _buildImage(AssetsPath.compare, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.30,
                  bottom: size.width * 0.08,
                  left: size.width * 0.08,
                ),
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
        imageWidget: isWeb
            ? _buildImage(AssetsPath.filter, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.30,
                  bottom: size.width * 0.08,
                  left: size.width * 0.08,
                ),
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
        imageWidget: isWeb
            ? _buildImage(AssetsPath.instantAI, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.35,
                  bottom: size.width * 0.08,
                ),
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
        imageWidget: isWeb
            ? _buildImage(AssetsPath.Quiz, imageHeight)
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.35,
                  bottom: size.width * 0.08,
                  left: size.width * 0.04,
                ),
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
      body: Center(
        child: ConstrainedBox(
          constraints: isWeb
              ? const BoxConstraints(maxWidth: 600)
              : const BoxConstraints(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => onLastPage = index == pages.length - 1);
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(info: pages[index]);
                },
              ),

              // --- SmoothPageIndicator ---
              Positioned(
                bottom: size.height * (isWeb ? 0.12 : 0.115),
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: pages.length,
                    effect: WormEffect(
                      spacing: isWeb ? 14 : 10,
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey.shade300,
                      dotHeight: isWeb ? 12 : 10,
                      dotWidth: isWeb ? 12 : 10,
                    ),
                  ),
                ),
              ),

              // --- Skip & Next Buttons ---
              Positioned(
                bottom: size.height * (isWeb ? 0.07 : 0.09),
                left: isWeb ? 60 : 30,
                right: isWeb ? 60 : 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StartExploringApp(),
                          ),
                        );
                      },
                      child: Text(
                        ConstantStrings.skip,
                        style: TextStyle(
                          color: AppColors.skip,
                          fontSize: isWeb ? 15 : 13,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (onLastPage) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StartExploringApp(),
                            ),
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
                          fontSize: isWeb ? 15 : 13,
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
    return Center(
      child: SizedBox(
        height: height,
        child: SvgPicture.asset(
          CommonUi.setSvgImage(path),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
