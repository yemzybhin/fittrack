import 'package:fittrack/core/utils/fonts.dart';
import 'package:fittrack/core/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeartRateDisplay extends StatefulWidget {
  final int heartRate;

  const HeartRateDisplay({required this.heartRate});

  @override
  _HeartRateDisplayState createState() => _HeartRateDisplayState();
}

class _HeartRateDisplayState extends State<HeartRateDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.15).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      )),
      child: Column(
        children: [
          SvgPicture.asset(CustomIcons.heart, height: 30),
          SizedBox(height: 7),
          Text(
            "${widget.heartRate} bpm",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: CustomFonts.Montserrat_ExtraBlack),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
