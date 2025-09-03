import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getRotatedPlaneIcon(double direction, {Color color = Colors.red}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final size = 80.0;
  final paint = Paint()..color = color;

  // Draw airplane icon rotated
  final textPainter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(Icons.airplanemode_active.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: Icons.airplanemode_active.fontFamily,
        color: color,
      ),
    ),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout();
  canvas.save();
  canvas.translate(size / 2, size / 2);
  canvas.rotate(direction * 3.1415926535 / 180);
  canvas.translate(-size / 2, -size / 2);
  textPainter.paint(canvas, Offset(0, 0));
  canvas.restore();

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.toInt(), size.toInt());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}
