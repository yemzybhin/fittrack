import 'dart:math';

import 'package:fittrack/core/utils/fonts.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatefulWidget {
  final double thisWeekSteps;
  final double thisWeekCalories;
  final double thisWeekDistance;

  CustomChart(
      {required this.thisWeekSteps,
      required this.thisWeekCalories,
      required this.thisWeekDistance});

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<String> weeks = ['Week 1', 'Week 2', 'Week 3', 'Last Week', 'This Week'];
  List<double> stepsData = [500, 1200, 1100, 1300];
  List<double> caloriesData = [200, 700, 650, 850];
  List<double> distanceData = [0.2, 0.5, 0.8, 1];
  int? hoveredIndex;
  Offset? hoverPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details, Size size) {
    final dx = details.localPosition.dx;
    final spacing = size.width / (weeks.length - 1);

    int index = (dx / spacing).round();
    if (index >= 0 && index < weeks.length) {
      setState(() {
        hoveredIndex = index;
        hoverPosition = details.localPosition;
      });
    }
  }

  void _handleTapCancel() {
    setState(() {
      hoveredIndex = null;
      hoverPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(color: Colors.white54, width: 1)),
          child: GestureDetector(
            onTapDown: (d) => _handleTapDown(d, context.size ?? Size.zero),
            onTapUp: (_) => _handleTapCancel(),
            onTapCancel: _handleTapCancel,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _ChartPainter(
                  weeks: weeks,
                  steps: [...stepsData, widget.thisWeekSteps],
                  calories: [...caloriesData, (widget.thisWeekCalories * 10)],
                  distance: [...distanceData, widget.thisWeekDistance],
                  hoveredIndex: hoveredIndex,
                  hoverPosition: hoverPosition,
                  animationValue: _controller.value,
                ),
                size: const Size(double.infinity, 250),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            chartLabel(title: "Distance", color: Colors.blue),
            chartLabel(title: "Steps", color: Colors.green),
            chartLabel(title: "Calories", color: Colors.redAccent),
          ],
        )
      ],
    );
  }

  Widget chartLabel({required String title, required Color color}) {
    return Expanded(
      child: Container(
        height: 30,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        color: color,
        child: Text(title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: CustomFonts.Montserrat_Bold,
                fontSize: 12,
                height: 0)),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<String> weeks;
  final List<double> steps;
  final List<double> calories;
  final List<double> distance;
  final int? hoveredIndex;
  final Offset? hoverPosition;
  final double animationValue;

  _ChartPainter({
    required this.weeks,
    required this.steps,
    required this.calories,
    required this.distance,
    this.hoveredIndex,
    this.hoverPosition,
    required this.animationValue,
  });

  final labelStyle = TextStyle(
      fontFamily: CustomFonts.Montserrat_Bold,
      fontSize: 8,
      color: Colors.white);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stepPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint calPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint distPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double padding = 30;
    final double chartHeight = size.height - 60;
    final double chartWidth = size.width - padding * 2;

    final maxY =
        [...steps, ...calories, ...distance.map((e) => e * 1000)].reduce(max);

    Path buildCurve(List<double> values, double multiplier) {
      final path = Path();
      final dx = chartWidth / (weeks.length - 1);
      for (int i = 0; i < values.length; i++) {
        double x = padding + i * dx;
        double y = size.height -
            40 -
            ((values[i] * animationValue * multiplier) / maxY * chartHeight);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          final prevX = padding + (i - 1) * dx;
          final prevY = size.height -
              40 -
              ((values[i - 1] * animationValue * multiplier) /
                  maxY *
                  chartHeight);
          final midX = (x + prevX) / 2;
          path.cubicTo(midX, prevY, midX, y, x, y);
        }
      }
      return path;
    }

    canvas.drawPath(buildCurve(steps, 1), stepPaint);
    canvas.drawPath(buildCurve(calories, 1), calPaint);
    canvas.drawPath(buildCurve(distance, 1000), distPaint);
    final dx = chartWidth / (weeks.length - 1);
    for (int i = 0; i < weeks.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: weeks[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
          canvas, Offset(padding + i * dx - tp.width / 2, size.height - 20));
    }

    if (hoveredIndex != null && hoverPosition != null) {
      final index = hoveredIndex!;
      final tooltipText =
          'Steps: ${steps[index].toInt()}\nCalories: ${(calories[index] / 10).toInt()}\nDist: ${distance[index].toStringAsFixed(2)}km';

      final tooltip = TextPainter(
        text: TextSpan(
          text: tooltipText,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 120);

      final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(hoverPosition!.dx - 60, hoverPosition!.dy - 80, 120,
              tooltip.height + 10),
          const Radius.circular(6));

      final tooltipPaint = Paint()..color = Colors.black;
      canvas.drawRRect(rect, tooltipPaint);
      tooltip.paint(canvas, Offset(rect.left + 6, rect.top + 5));
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.animationValue != animationValue ||
      old.hoveredIndex != hoveredIndex ||
      old.steps != steps ||
      old.calories != calories ||
      old.distance != distance;
}
