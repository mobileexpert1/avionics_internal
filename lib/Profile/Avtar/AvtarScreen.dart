import 'package:avionics_internal/Constants/OnboardingTexts.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Constants/constantImages.dart';

class AvtarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AvtarScreenState();
}

class _AvtarScreenState extends State<AvtarScreen> {
  int? selectedIndex = 0;
  final List<String> titles = ['Pilot', 'ATCO', 'Student', 'Enthusiasts'];
  final List<String> icons = [
    AssetsPath.avtarFirst,
    AssetsPath.avtarSecond,
    AssetsPath.avtarThird,
    AssetsPath.avtarFouth,
  ]; // Replace with your correct asset paths

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: OnboardingTexts.avtarTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        itemCount: titles.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 0.1, color: Colors.grey, thickness: 0.1),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Card(
                color: Colors.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        CommonUi.setSvgImage(icons[index])!,
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          titles[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check, size: 20, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
