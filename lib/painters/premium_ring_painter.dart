import 'dart:math';
import 'package:flutter/material.dart';

class PremiumRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final paint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Colors.cyanAccent,
          Colors.blueAccent,
          Colors.transparent,
          Colors.cyanAccent,
        ],
        stops: const [
          0.0,
          0.35,
          0.75,
          1.0,
        ],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: size.width / 2,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: size.width / 2,
      ),
      -pi / 2,
      pi * 1.7,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}