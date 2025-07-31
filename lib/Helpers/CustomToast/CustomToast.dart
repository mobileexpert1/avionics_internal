import 'package:flutter/material.dart';

class info extends StatefulWidget {
  const info({super.key});

  @override
  State<info> createState() => _infoState();
}

final GlobalKey _iconKey = GlobalKey();

class _infoState extends State<info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 80),
        child: GestureDetector(
          key: _iconKey,
          onTap: () {
            showPopupBelowIcon(context, _iconKey, ArrowDirection.right);
          },
          child: Image.asset(
            'assets/Vector-4.png',
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void showPopupBelowIcon(
    BuildContext context,
    GlobalKey key,
    ArrowDirection direction,
  ) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              left: offset.dx + size.width / 2 - 175,
              top: offset.dy + size.height + 10,
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Popup box
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BulletText(
                            "Structure and behaviour of the atmosphere",
                          ),
                          BulletText("METAR and TAF decoding"),
                          BulletText(
                            "Wind, pressure systems, temperature gradients",
                          ),
                          BulletText(
                            "Fronts, clouds, thunderstorms, turbulence",
                          ),
                          BulletText("Icing conditions, visibility, fog"),
                          BulletText(
                            "Weather radar and satellite interpretation",
                          ),
                          BulletText(
                            "Environmental awareness: noise abatement, emissions, contrail formation",
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: direction == ArrowDirection.top ? -20 : null,
                      bottom: direction == ArrowDirection.bottom ? -20 : null,
                      left: direction == ArrowDirection.left ? -20 : null,
                      right: direction == ArrowDirection.right ? -20 : null,
                      child: CustomPaint(
                        size:
                            direction == ArrowDirection.top ||
                                direction == ArrowDirection.bottom
                            ? const Size(
                                80,
                                40,
                              ) // Bigger arrow (Width x Height)
                            : const Size(40, 80),
                        painter: TrianglePainter(
                          color: Colors.white,
                          direction: direction,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum ArrowDirection { top, bottom, left, right }

class TrianglePainter extends CustomPainter {
  final Color color;
  final ArrowDirection direction;

  const TrianglePainter({required this.color, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    switch (direction) {
      case ArrowDirection.top:
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        break;
      case ArrowDirection.bottom:
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case ArrowDirection.left:
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      case ArrowDirection.right:
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.direction != direction;
}

class BulletText extends StatelessWidget {
  final String text;

  const BulletText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 11, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
