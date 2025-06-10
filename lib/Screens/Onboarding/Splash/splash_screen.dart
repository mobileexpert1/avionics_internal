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
    await Future.delayed(const Duration(seconds: 2));
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.splashImage),
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            const Text(
              ConstantStrings.avionica,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
