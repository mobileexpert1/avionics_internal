import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoInternetDialog {
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function() onRetry,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => _NoInternetDialogContent(onRetry: onRetry),
    );
  }
}

class _NoInternetDialogContent extends StatefulWidget {
  const _NoInternetDialogContent({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  State<_NoInternetDialogContent> createState() =>
      _NoInternetDialogContentState();
}

class _NoInternetDialogContentState extends State<_NoInternetDialogContent>
    with SingleTickerProviderStateMixin {
  bool _isRetrying = false;
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  static const Color _navy = Color(0xFF1E2051);
  static const Color _iconBg = Color(0xFFE8E8F5);
  static const Color _textMuted = Color(0xFF6B6D8D);

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutBack);
    _scaleCtrl.forward();
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    setState(() => _isRetrying = true);
    try {
      Navigator.of(context).pop();
      await widget.onRetry();
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  // void _handleClose() {
  //   Navigator.of(context).pop();
  //   if (Platform.isAndroid) {
  //     SystemNavigator.pop();
  //   } else {
  //     exit(0);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ScaleTransition(
      scale: _scaleAnim,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        child: SizedBox(
          width: screenWidth > 800 ? 500 : screenWidth * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 36,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: _iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: _NoWifiIcon(),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Please check your internet connection\nand try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: _textMuted,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isRetrying ? null : _handleRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      disabledBackgroundColor:
                      _navy.withValues(alpha: 0.6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isRetrying
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
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

class _NoWifiIcon extends StatelessWidget {
  const _NoWifiIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(48, 40), painter: _NoWifiPainter());
  }
}

class _NoWifiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const Color navy = Color(0xFF1E2051);
    final paint = Paint()
      ..color = navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height * 0.52;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: size.width,
        height: size.width,
      ),
      3.6,
      -3.6 + (3.14159 * 2 - 3.6) * 0.0 + 3.14159,
      false,
      paint,
    );

    void drawArc(double radius) {
      final path = Path()
        ..addArc(
          Rect.fromCenter(
            center: Offset(cx, cy),
            width: radius * 2,
            height: radius * 2,
          ),
          3.14159 + 0.4,
          3.14159 - 0.8,
        );
      canvas.drawPath(path, paint);
    }

    drawArc(size.width * 0.5);
    drawArc(size.width * 0.35);
    drawArc(size.width * 0.20);

    canvas.drawCircle(
      Offset(cx, cy + size.width * 0.08),
      3.2,
      paint..style = PaintingStyle.fill,
    );

    final slashPaint = Paint()
      ..color = navy
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - size.width * 0.38, cy - size.height * 0.55),
      Offset(cx + size.width * 0.38, cy + size.height * 0.25),
      slashPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
