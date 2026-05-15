import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';

class InfoWrongGameScreen extends StatefulWidget {
  const InfoWrongGameScreen({super.key});

  @override
  State<InfoWrongGameScreen> createState() => _InfoWrongGameState();
}

class _InfoWrongGameState extends State<InfoWrongGameScreen> {
  @override
  void initState() {
    print(CommonUi.setSvgImage(AssetsPath.infoWrongFirst));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Trivia Level Demo Screen",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xff2F9BFF), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  const Text(
                    "Turbulence happens!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black54),
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.7,

                child: Image.asset(
                  CommonUi.setPngImage(AssetsPath.infoWrongFirst),
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 28),

              /// Description
              const Text(
                "Not every flight is smooth. Adjust your\ncourse and keep climbing.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "You've got this!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 40),

              // Button
              Container(
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xff1A1647),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Try Next Round",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 58,
                      width: 58,
                      decoration: const BoxDecoration(
                        color: Color(0xffFFC928),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
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
}
