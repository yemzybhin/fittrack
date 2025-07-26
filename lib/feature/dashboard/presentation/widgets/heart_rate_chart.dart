import 'dart:math';

import 'package:flutter/material.dart';

class HeartRateChart extends StatelessWidget {
  final List<int> heartRateHistory;

  const HeartRateChart({super.key, required this.heartRateHistory});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return CustomPaint(
          painter: _HeartRateChartPainter(
            heartRateHistory: heartRateHistory,
            progress: value,
          ),
          size: const Size(double.infinity, 200),
        );
      },
    );
  }
}

class _HeartRateChartPainter extends CustomPainter {
  final List<int> heartRateHistory;
  final double progress;

  _HeartRateChartPainter({
    required this.heartRateHistory,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (heartRateHistory.isEmpty) return;

    final paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    final maxY = heartRateHistory.reduce(max).toDouble();
    final minY = heartRateHistory.reduce(min).toDouble();
    final range = maxY - minY;

    final widthStep = size.width / (heartRateHistory.length - 1);

    for (int i = 0; i < heartRateHistory.length; i++) {
      final x = i * widthStep;
      final normalizedY =
          (heartRateHistory[i] - minY) / (range == 0 ? 1 : range);
      final y = size.height - (normalizedY * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x * progress, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartRateChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.heartRateHistory != heartRateHistory;
  }
}
