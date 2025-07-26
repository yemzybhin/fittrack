import 'package:fittrack/core/utils/fonts.dart';
import 'package:fittrack/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedStatCard extends StatefulWidget {
  final String text;
  final double value;
  final String unit;
  final String icon;

  const AnimatedStatCard({
    Key? key,
    required this.text,
    required this.value,
    this.unit = '',
    required this.icon,
  }) : super(key: key);

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _oldValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: widget.value).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _oldValue = _animation.value;
      _controller.reset();
      _animation = Tween<double>(
        begin: _oldValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: Colors.white54, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(widget.icon, height: 20, color: Colors.white),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: _animation.value < 1000
                      ? _animation.value.toStringAsFixed(0)
                      : Formatter.formatK(_animation.value),
                  style: TextStyle(
                    fontFamily: CustomFonts.Montserrat_ExtraBlack,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: '${widget.unit}',
                  style: TextStyle(
                    fontFamily: CustomFonts.Montserrat_ExtraBlack,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.text,
            style: TextStyle(
                fontSize: 11,
                fontFamily: CustomFonts.Montserrat_Regular,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
