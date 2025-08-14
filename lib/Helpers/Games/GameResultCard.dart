import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/AppColors.dart';
import '../../Constants/ConstantStrings.dart';

class GameResultCard extends StatelessWidget {
  final String title;
  final int score;
  final int total;
  final int totalPoints;
  final int correctPoints;
  final List<String> bonusPoints;
  final String? badgeText;
  final VoidCallback? onBackTap;

  const GameResultCard({
    super.key,
    required this.title,
    required this.score,
    required this.total,
    required this.totalPoints,
    required this.correctPoints,
    required this.bonusPoints,
    this.badgeText,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.resultIcon),
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              const Text("Your Result"),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade100),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF0F7FF),
                ),
                child: Column(
                  children: [
                    Text(
                      "$score/$total",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("$totalPoints points earned"),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: score / total,
                      minHeight: 6,
                      color: Colors.blue,
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text("Keep learning and Keep playing"),
              const SizedBox(height: 5),
              correctPoints != 0
                  ? Text(
                      "$correctPoints points for correct answers",
                      style: const TextStyle(fontSize: 15),
                    )
                  : const SizedBox.shrink(),
              ...bonusPoints.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  // space below each item
                  child: Text(
                    b,
                    style: const TextStyle(fontSize: 15, color: Colors.orange),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              CustomBottomButton(
                title: ConstantStrings.backToGame,
                backgroundColor: AppColors.customBottomEnabledColour,
                textColor: Colors.white,
                icon: const SizedBox(width: 0),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        if (badgeText != null) ...[
          const SizedBox(height: 20),
          Text(badgeText!, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 1),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: const TextStyle(decoration: TextDecoration.underline),
            ),
            child: const Text("See in profile"),
          ),
        ],
      ],
    );
  }
}
