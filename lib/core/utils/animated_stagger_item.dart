import 'package:flutter/material.dart';

class AnimatedStaggerItem extends StatefulWidget {
  final Widget child;
  final int delayMilliseconds;

  const AnimatedStaggerItem({
    required this.child,
    required this.delayMilliseconds,
  });

  @override
  _AnimatedStaggerItemState createState() => _AnimatedStaggerItemState();
}

class _AnimatedStaggerItemState extends State<AnimatedStaggerItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scale = Tween(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );

    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
