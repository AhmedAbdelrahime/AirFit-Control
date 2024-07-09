import 'dart:math';
import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter {
  final double value;
  final int maximumValue = 290;

  CircleProgress(this.value);

  @override
  bool shouldRepaint(CircleProgress oldDelegate) {
    return oldDelegate.value != value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = size.width * 0.1
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke;

    Paint arcPaint = Paint()
      ..strokeWidth = size.width * 0.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint shadowPaint = Paint()
      ..strokeWidth = size.width * 0.1
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - size.width * 0.1;
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (value / maximumValue);
    Rect arcRect = Rect.fromCircle(center: center, radius: radius);

    // Create a gradient
    Gradient gradient = LinearGradient(
      colors: [Color(0xFF0E88D9), Color(0xFF41718D), Color(0xFF7AB9D4)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // Apply the gradient to the arcPaint shader
    arcPaint.shader = gradient.createShader(arcRect);

    canvas.drawArc(
      arcRect,
      -pi / 2,
      angle,
      false,
      shadowPaint,
    );

    canvas.drawArc(
      arcRect,
      -pi / 2,
      angle,
      false,
      arcPaint,
    );
  }
}
