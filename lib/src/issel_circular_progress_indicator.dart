import 'package:flutter/material.dart';

import '../custom_paints/gradient_border_painter.dart';

class IsselCircularProgressIndicator extends StatefulWidget {

  double height;
  double width;
  Color? color;

  IsselCircularProgressIndicator({
    super.key,
    this.color,
    this.height = 24,
    this.width = 24
  });

  @override
  State<IsselCircularProgressIndicator> createState() => _IsselCircularProgressIndicatorState();
}

class _IsselCircularProgressIndicatorState extends State<IsselCircularProgressIndicator> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: GradientBorderPainter(_animation, colorScheme.primary),
          );
        },
      ),
    );
  }
}
