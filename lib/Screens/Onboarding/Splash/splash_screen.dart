import 'package:avionics_internal/Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import 'package:avionics_internal/Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import 'package:avionics_internal/Constants/ApiClass/shared_prefs_helper.dart';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../Home/RootTabbar/RootDecider.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.splashScreen);
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final isFirst = await SharedPrefsHelper.isFirstLaunch();
    if (!mounted) return;
    if (!isFirst) {
      await SharedPrefsHelper.setFirstLaunchDone();
      if (!mounted) return;
      AppNavigator.pushReplacement(
        context,
        OnboardingScreen(),
        disableSwipeBack: true,
      );
    } else {
      AppNavigator.pushReplacement(
        context,
        RootDecider(),
        disableSwipeBack: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double logoWidth = screenWidth * 0.4;
    double textFontSize = screenWidth < 600 ? 13 : 16;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.mainLogoWhiteColour),
                    width: logoWidth.clamp(100, 300),
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    ConstantStrings.poweredBy,
                    style: TextStyle(
                      fontSize: textFontSize,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
