import 'package:flutter/cupertino.dart';

class CardWithBadgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    const double r = 40;
    const double trR = 35;
    const double cutStart = 150;
    const double stepDepth = 50;

    final double x0 = w - cutStart;
    final double x1 = w - trR;

    final double cp1x = x0 + cutStart * 0.40;
    const double cp1y = -3;
    final double cp2x = x0 + cutStart * 0;
    const double cp2y = stepDepth + 10;

    final Path path = Path();
    path.moveTo(r, 0);
    path.lineTo(x0, 0);
    path.cubicTo(cp1x, cp1y, cp2x, cp2y, x1, stepDepth);
    path.quadraticBezierTo(w, stepDepth, w, stepDepth + trR);
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}