import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../Constants/AppColors.dart';
import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class AirplaneCompleteScreen extends StatefulWidget {
  const AirplaneCompleteScreen({super.key});

  @override
  State<AirplaneCompleteScreen> createState() => _AirplaneCompleteScreenState();
}

class _AirplaneCompleteScreenState extends State<AirplaneCompleteScreen> {
  late final Flutter3DController _controller;

  @override
  void initState() {
    super.initState();

    _controller = Flutter3DController();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: "3D Airplane",
        centerTitle: false,
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                const SizedBox(height: 24),

                Text(
                  "Aircraft Complete!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold(
                    isDesktopWeb ? 24 : 28,
                  ).copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: isDesktopWeb ? 350 : 320,
                  child: Flutter3DViewer(
                    controller: _controller,
                    src: 'assets/3d_models/Airplane1.glb',
                    progressBarColor: Colors.transparent,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.dragRotateIcon),
                      width: 25,
                      height: 23,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      "Drag to rotate the Aircraft",
                      style: AppTextStyles.bold(
                        isDesktopWeb ? 14 : 12,
                      ).copyWith(
                        color: const Color(0xFF575757),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
