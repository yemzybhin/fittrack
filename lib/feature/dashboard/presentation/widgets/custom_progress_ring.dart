import 'dart:math';

import 'package:fittrack/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomProgressRing extends StatelessWidget {
  final double progress;

  const CustomProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width(context, 70), width(context, 70)),
      painter: _RingPainter(progress),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pinkAccent, Colors.orangeAccent],
      ).createShader(Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2))
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, basePaint);
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
