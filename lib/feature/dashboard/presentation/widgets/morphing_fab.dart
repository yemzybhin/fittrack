import 'package:flutter/material.dart';

class MorphingFAB extends StatefulWidget {
  @override
  _MorphingFABState createState() => _MorphingFABState();
}

class _MorphingFABState extends State<MorphingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _expanded = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    super.initState();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _toggle,
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _controller,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
