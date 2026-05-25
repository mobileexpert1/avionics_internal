import 'package:flutter/material.dart';

import '../../../Constants/AppColors.dart';

class AllLinesPainter extends CustomPainter {
  final double screenWidth;

  AllLinesPainter({required this.screenWidth});

  Paint _linePaint(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = screenWidth / 2 - 2;
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
