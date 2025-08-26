import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class InfoTooltip extends StatelessWidget {
  final String message;

  const InfoTooltip({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const Icon(Icons.info_outline, size: 24, color: Colors.black),
        CustomPaint(
          size: const Size(20, 10),
          painter: TrianglePainter(),
        ),
        Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black26, 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class InfoTooltip extends StatelessWidget {
//   final String message;
//
//   const InfoTooltip({super.key, required this.message});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 260.0, // Match the image's approximate width
//           constraints: const BoxConstraints(maxHeight: 70.0), // Approximate height from image
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.9), // Light background like the image
//             borderRadius: BorderRadius.circular(8.0), // Subtle rounded corners
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 4.0,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               message,
//               textAlign: TextAlign.center, // Centered text like the image
//               style: const TextStyle(
//                 fontSize: 14.0, // Matches the image's text size
//                 color: Color(0xFF333333), // Darker grey to match the image's text color
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ),
//         CustomPaint(
//           size: const Size(20, 10),
//           painter: TrianglePainter(isUpward: true), // Use upward arrow
//         ),
//       ],
//     );
//   }
// }
//
// class TrianglePainter extends CustomPainter {
//   final bool isUpward;
//
//   TrianglePainter({this.isUpward = false});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.9) // Match container background
//       ..style = PaintingStyle.fill;
//
//     final path = Path();
//     if (isUpward) {
//       path.moveTo(size.width / 2, size.height); // Start at bottom center
//       path.lineTo(0, 0); // Left top
//       path.lineTo(size.width, 0); // Right top
//     } else {
//       path.moveTo(0, size.height); // Default downward triangle
//       path.lineTo(size.width / 2, 0);
//       path.lineTo(size.width, size.height);
//     }
//     path.close();
//
//     canvas.drawShadow(path, Colors.black26, 3, true);
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }