import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientBorderPainter extends CustomPainter {
  final Animation<double> animation;
  Color color;

  GradientBorderPainter(this.animation, this.color) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Crear el degradado animado para las líneas
    final gradient = LinearGradient(
      colors: [
        Colors.transparent,
        color.withOpacity(0.5), // Cambiar opacidad para un efecto más suave
        color,
      ],
      stops: [
        0.0,
        0.5, // Progreso de la mitad
        1.0,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(math.pi * 2 * animation.value), // Gira todo el borde
    );

    // Crear un RRect (rectángulo con bordes redondeados)
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(20),
    );

    // Crear el borde del contenedor con el degradado
    final paint = Paint()
      ..shader = gradient.createShader(rrect.outerRect) // Aplicar el degradado al RRect
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}