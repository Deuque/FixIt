import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  final Widget Function(AnimationController) builder;

  const AnimatedDialog({Key? key, required this.builder}) : super(key: key);

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late final _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
  late final Animation<double> _scaleAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticInOut,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.builder(_animationController),
    );
  }
}
