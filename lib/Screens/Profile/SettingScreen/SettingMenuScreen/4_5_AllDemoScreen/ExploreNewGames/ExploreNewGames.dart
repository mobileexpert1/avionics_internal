import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../Constants/constantImages.dart';
import '../../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../../Helpers/AppTextStyles/AppTextStyles.dart';

class GamePairModel {
  final GameCardModel? left;
  final GameCardModel? right;

  const GamePairModel({this.left, this.right});
}

class GameCardModel {
  final String title;
  final Color color;
  final double topValue;

  const GameCardModel({
    required this.title,
    required this.color,
    required this.topValue,
  });
}

final List<GamePairModel> rows = [
  GamePairModel(
    left: GameCardModel(
      title: "Aviation\nQuiz",
      color: AppColors.greenColourForPlan,
      topValue: 250,
    ),
    right: GameCardModel(
      title: "Black Box",
      color: AppColors.blackBoxColorForGame,
      topValue: 250,
    ),
  ),
  GamePairModel(
    left: GameCardModel(
      title: "Citius. Altius.\nLongius.",
      color: AppColors.citiusAltiusColorForGame,
      topValue: 370,
    ),
    right: GameCardModel(
      title: "Jetting\nAround\nThe World",
      color: AppColors.primaryBlue,
      topValue: 370,
    ),
  ),
  GamePairModel(
    left: GameCardModel(
      title: "Basic Topics",
      color: AppColors.primaryDark,
      topValue: 490,
    ),
    right: GameCardModel(
      title: "Plane\nSpotter",
      color: AppColors.planeSpotterColorForGame,
      topValue: 490,
    ),
  ),
  GamePairModel(
    left: GameCardModel(
      title: "Calculations",
      color: AppColors.greenColourForPlan,
      topValue: 610,
    ),
  ),
];

class ExploreGamesScreen extends StatefulWidget {
  const ExploreGamesScreen({super.key});

  @override
  ExploreGamesState createState() => ExploreGamesState();
}

class ExploreGamesState extends State<ExploreGamesScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollToAboveScreen();
  }

  Future<void> scrollToAboveScreen() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final cx = sw / 2;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leftButton: IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.backArrowButton),
            fit: BoxFit.cover,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: "Explore Games",
        centerTitle: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  color: Colors.white,
                  child: Image.asset(
                    'assets/png_images/62TowerImage.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight + 30,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              top: 350,
                              left: cx - 2,
                              width: 8,
                              bottom: 0,
                              child: CustomPaint(
                                painter: _DoubleCenterLinePainter(),
                              ),
                            ),

                            Positioned.fill(
                              child: CustomPaint(
                                painter: _AllLinesPainter(screenWidth: sw),
                              ),
                            ),

                            ...List.generate(rows.length, (index) {
                              final row = rows[index];
                              return Stack(
                                children: [
                                  if (row.left != null)
                                    Positioned(
                                      top: row.left!.topValue,
                                      left: 30,
                                      child: GameCard(model: row.left!),
                                    ),

                                  if (row.right != null)
                                    Positioned(
                                      top: row.right!.topValue,
                                      right: 30,
                                      child: GameCard(model: row.right!),
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final GameCardModel model;

  const GameCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 90,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: model.color, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(15, 15),
                    painter: CornerPainter(color: model.color),
                  ),
                ),

                /// TEXT
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      model.title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.medium(
                        14,
                      ).copyWith(height: 1.1, color: AppColors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CornerPainter extends CustomPainter {
  final Color color;

  CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _AllLinesPainter extends CustomPainter {
  final double screenWidth;

  _AllLinesPainter({required this.screenWidth});

  Paint _linePaint(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = screenWidth / 2;
    final leftEnd = 80.0;
    final rightEnd = screenWidth - 80.0;

    final leftPath = Path();
    leftPath.moveTo(cx - 1, 370);
    leftPath.lineTo(cx - 1, 250);
    leftPath.quadraticBezierTo(cx - 1, 215, cx - 40, 215);
    leftPath.lineTo(leftEnd, 215);
    canvas.drawPath(leftPath, _linePaint(AppColors.greenColourForPlan));

    _drawPlane(
      canvas,
      Offset(leftEnd, 250 - 35),
      AppColors.greenColourForPlan,
      true,
    );

    final rightPath = Path();
    rightPath.moveTo(cx + 4.5, 370);
    rightPath.lineTo(cx + 4.5, 250);
    rightPath.quadraticBezierTo(cx + 4.5, 215, cx + 40, 215);
    rightPath.lineTo(rightEnd, 215);
    canvas.drawPath(rightPath, _linePaint(AppColors.blackBoxColorForGame));
    _drawPlane(
      canvas,
      Offset(rightEnd, 250 - 35),
      AppColors.blackBoxColorForGame,
      false,
    );

    _drawHorizontalCurvedLine(
      canvas: canvas,
      cx: cx,
      y: 370,
      leftColor: AppColors.citiusAltiusColorForGame,
      rightColor: AppColors.primaryBlue,
      showRight: true,
      screenWidth: screenWidth,
    );

    _drawHorizontalCurvedLine(
      canvas: canvas,
      cx: cx,
      y: 490,
      leftColor: AppColors.primaryDark,
      rightColor: AppColors.planeSpotterColorForGame,
      showRight: true,
      screenWidth: screenWidth,
    );

    _drawHorizontalCurvedLine(
      canvas: canvas,
      cx: cx,
      y: 610,
      leftColor: AppColors.greenColourForPlan,
      rightColor: Colors.transparent,
      showRight: true,
      screenWidth: screenWidth,
    );
  }

  void _drawHorizontalCurvedLine({
    required Canvas canvas,
    required double cx,
    required double y,
    required Color leftColor,
    required Color rightColor,
    required bool showRight,
    required double screenWidth,
  }) {
    const leftEnd = 80.0;
    final rightEnd = screenWidth - 80.0;

    final leftPath = Path();
    leftPath.moveTo(cx - 1, y);
    leftPath.quadraticBezierTo(cx - 1, y - 35, cx - 35, y - 35);
    leftPath.lineTo(leftEnd, y - 35);
    canvas.drawPath(leftPath, _linePaint(leftColor));
    _drawPlane(canvas, Offset(rightEnd, y - 35), rightColor, false);

    _drawCenterDot(canvas, Offset(cx + 1, y));

    if (!showRight) return;

    final rightPath = Path();
    rightPath.moveTo(cx + 4.5, y);
    rightPath.quadraticBezierTo(cx + 4.5, y - 35, cx + 35, y - 35);
    rightPath.lineTo(rightEnd, y - 35);
    canvas.drawPath(rightPath, _linePaint(rightColor));
    _drawPlane(canvas, Offset(leftEnd, y - 35), leftColor, true);
  }

  void _drawCenterDot(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = const Color(0xFF1A1A4E)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawPlane(Canvas canvas, Offset offset, Color color, bool facingRight) {
    canvas.save();
    if (facingRight) {
      canvas.translate(offset.dx - 20, offset.dy);
    } else {
      canvas.translate(offset.dx + 20, offset.dy);
    }
    canvas.rotate(facingRight ? -1.5708 : 1.5708);

    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.airplanemode_active_outlined.codePoint),
        style: TextStyle(
          fontSize: 35,
          fontFamily: Icons.airplanemode_active_outlined.fontFamily,
          package: Icons.airplanemode_active_outlined.fontPackage,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    tp.layout();
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _DoubleCenterLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A4E)
      ..strokeWidth = 1.0;
    canvas.drawLine(const Offset(1, 0), Offset(1, size.height - 205), paint);
    canvas.drawLine(
      Offset(size.width - 1, 0),
      Offset(size.width - 1, size.height - 205),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
