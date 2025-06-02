import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Constants/constantImages.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>  OnboardingScreen()));
    });

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
            const Text(OnboardingTexts.avionica, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
