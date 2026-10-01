import 'package:flutter/material.dart';

/// Acción compacta de barra de escritorio con foco, hover y teclado Material.
/// Para interfaces táctiles aumenta [size] a un tamaño apropiado.
class IsselCaptionButton extends StatelessWidget {
  const IsselCaptionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.color,
    this.size = 28,
    this.iconSize = 20,
    this.focusNode,
  }) : assert(size > 0);

  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final double iconSize;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: icon,
        tooltip: tooltip,
        onPressed: onPressed,
        focusNode: focusNode,
        iconSize: iconSize,
        color: color ?? Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: size, height: size),
        style: IconButton.styleFrom(
          minimumSize: Size.square(size),
          maximumSize: Size.square(size),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      );
}
