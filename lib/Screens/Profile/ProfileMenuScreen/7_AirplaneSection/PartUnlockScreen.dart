import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/AppColors.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';

class ComponentUnlockedScreen extends StatelessWidget {
  final String partName;
  final String image3d;
  final VoidCallback? onView3DPart;
  final VoidCallback? onNext;

  const ComponentUnlockedScreen({
    super.key,
    required this.partName,
    required this.image3d,
    this.onView3DPart,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isDesktopWeb = kIsWeb && screenWidth >= 900;
    final bool isMobileWeb = kIsWeb && screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: 'Component Unlocked',
        centerTitle: false,
        leftButton: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onNext,
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
          ),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktopWeb ? 900 : double.infinity,
            ),
            child: Column(
              children: [
                // Confetti section
                SizedBox(
                  height: isDesktopWeb ? 170 : 150,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background GIF
                      Positioned.fill(
                        child: Image.asset(
                          CommonUi.setGifAndVideoImage(
                            AssetsPath.badgeGif,
                            false,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Trophy
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: isDesktopWeb ? 70 : 60,
                          height: isDesktopWeb ? 70 : 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFAC200),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: isDesktopWeb ? 36 : 32,
                              height: isDesktopWeb ? 36 : 32,
                              child: SvgPicture.asset(
                                CommonUi.setSvgImage(
                                  AssetsPath.badgeTrophyIcon,
                                ),
                                fit: BoxFit.contain,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktopWeb ? 34 : 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),

                const SizedBox(height: 5),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktopWeb ? 20 : 16,
                  ),
                  child: Text(
                    'You have Earned the new 3D aircraft part',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktopWeb ? 15 : 14,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Part name
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktopWeb ? 40 : 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isDesktopWeb ? 45 : 28,
                        height: 1,
                        color: const Color(0xFF6EA8E5),
                      ),

                      const SizedBox(width: 5),

                      Flexible(
                        child: Text(
                          partName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktopWeb ? 30 : 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      Container(
                        width: isDesktopWeb ? 45 : 28,
                        height: 1,
                        color: const Color(0xFF6EA8E5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 3D Part section
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktopWeb ? 50 : 30,
                          ),
                          child: image3d.isNotEmpty
                              ? CachedAnyImage(
                            imagePath: image3d,
                            width: 150,
                            height: 125,
                            contentImage: BoxFit.contain,
                          )
                              : const SizedBox(),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '3D part Unlocked!',
                        style: TextStyle(
                          fontSize: isDesktopWeb ? 17 : 16,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // View 3D Part
                      SizedBox(
                        width: isDesktopWeb ? 180 : 160,
                        height: isDesktopWeb ? 48 : 45,
                        child: ElevatedButton(
                          onPressed: onView3DPart,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              const Color(0xFF4797DB),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            elevation: WidgetStateProperty.all(0),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Text(
                            'View your 3D Part',
                            style: TextStyle(
                              fontSize: isDesktopWeb ? 15 : 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Next
                      SizedBox(
                        width: isDesktopWeb ? 140 : 125,
                        height: isDesktopWeb ? 42 : 40,
                        child: ElevatedButton(
                          onPressed: onNext,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              const Color(0xFF201E48),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.white,
                            ),
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            elevation: WidgetStateProperty.all(0),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: isDesktopWeb ? 15 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1.5;

    final confetti = <Offset>[
      const Offset(5, 5),
      const Offset(20, 17),
      const Offset(35, 8),
      const Offset(55, 22),
      const Offset(72, 5),
      const Offset(90, 18),
      const Offset(110, 8),
      const Offset(130, 25),
      const Offset(150, 7),
      const Offset(175, 18),
      const Offset(195, 5),
      const Offset(215, 22),
      const Offset(235, 8),
      const Offset(255, 19),
      const Offset(275, 5),
      const Offset(295, 25),
      const Offset(315, 10),
      const Offset(335, 20),
      const Offset(355, 6),
      const Offset(375, 25),
      const Offset(395, 10),
    ];

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
    ];

    for (int i = 0; i < confetti.length; i++) {
      paint.color = colors[i % colors.length];

      final point = confetti[i];

      canvas.drawLine(point, Offset(point.dx + 5, point.dy + 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
