import 'package:flutter/material.dart';
import '../../../../CustomFiles/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingInfo info;

  const OnboardingPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: info.imageWidget,
          ),
          Positioned(
            top: size.height * 0.62, // 55% from top of screen
            left: size.width * 0.13,  // 8% horizontal padding
            right: size.width * 0.04, // 4% horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: TextStyle(
                    fontSize: size.width * 0.09, // responsive font size
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E2E3A),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  info.description,
                  style: TextStyle(
                    fontSize: size.width * 0.039,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
