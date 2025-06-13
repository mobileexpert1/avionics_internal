import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/constantImages.dart';
import '../../../RootDecider.dart';
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
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    final isFirst = await SharedPrefsHelper.isFirstLaunch();

    if (!isFirst) {
      await SharedPrefsHelper.setFirstLaunchDone();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RootDecider()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust sizes based on screen width
    double logoWidth = screenWidth * 0.4;
    double textFontSize = screenWidth < 600 ? 13 : 16;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.logoMain),
                    width: logoWidth.clamp(100, 300), // limit range
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
                      color: Colors.grey,
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
