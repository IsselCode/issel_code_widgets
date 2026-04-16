import 'package:flutter/material.dart';

import '../custom_paints/gradient_border_painter.dart';

/// Indicador de progreso circular animado con borde degradado.
class IsselCircularProgressIndicator extends StatefulWidget {
  /// Altura deseada del indicador.
  double height;

  /// Ancho deseado del indicador.
  double width;

  /// Color opcional del indicador.
  Color? color;

  /// Crea un indicador circular animado.
  IsselCircularProgressIndicator(
      {super.key, this.color, this.height = 24, this.width = 24});

  @override
  State<IsselCircularProgressIndicator> createState() =>
      _IsselCircularProgressIndicatorState();
}

class _IsselCircularProgressIndicatorState
    extends State<IsselCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
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
