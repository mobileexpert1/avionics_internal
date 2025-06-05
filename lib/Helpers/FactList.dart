import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Constants/constantImages.dart';

Widget InterestingFacts(Size size) {
  final List<String> facts = [
    'The A320 family is one of the best-selling aircraft in the world.',
    'It was the first commercial airplane to use fly-by-wire technology.',
    'The A320 can seat 140 to 170 passengers depending on the configuration.'
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Facts list
      ...facts.map(
            (fact) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.Plane1),
                  fit: BoxFit.fill,
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  fact,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 20),

      // Image scroll
      SizedBox(
        height: 150,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(
              3,
                  (index) => Padding(
                padding: EdgeInsets.only(right: index == 2 ? 0 : 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    CommonUi.setPngImage(AssetsPath.HistoryImg),
                    width: 300,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 20),
    ],
  );
}
