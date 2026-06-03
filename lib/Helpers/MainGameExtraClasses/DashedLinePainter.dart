import 'package:flutter/cupertino.dart';

class DashedLinePainter extends CustomPainter {
  final bool isDark;

  const DashedLinePainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final lineColor = isDark
        ? const Color(0xFF2D2D54)
        : const Color(0xFFCCCCDD);

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;

    canvas.drawCircle(Offset(cx, 4), 3, dotPaint);

    const dashHeight = 6.0;
    const dashSpace = 4.0;
    double startY = 12.0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(cx, startY),
        Offset(cx, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}