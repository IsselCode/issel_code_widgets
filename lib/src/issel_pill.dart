import 'package:flutter/material.dart';

/// Contenedor tipo píldora para mostrar texto o un widget personalizado.
///
/// Debe recibir exactamente uno entre [text] y [widget].
class IsselPill extends StatelessWidget {
  /// Color de fondo opcional.
  final Color? color;

  /// Color opcional del texto cuando se usa [text].
  final Color? textColor;

  /// Altura opcional de la píldora.
  final double? height;

  /// Padding interno de la píldora.
  final EdgeInsetsGeometry padding;

  /// Alineación del contenido dentro de la píldora.
  final AlignmentGeometry? alignment;

  /// Callback invocado al presionar la píldora.
  final VoidCallback? onTap;

  //* Text
  /// Texto mostrado cuando no se proporciona [widget].
  final String? text;

  //* Widget
  /// Widget personalizado mostrado cuando no se proporciona [text].
  final Widget? widget;

  /// Crea una píldora con texto o contenido personalizado.
  IsselPill({
    super.key,
    this.text,
    this.widget,
    this.onTap,
    this.height = 50,
    this.textColor,
    this.color,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  }) : assert(
          (text != null) ^ (widget != null),
          "Solo puedes colocar texto o widget",
        );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    final borderRadius = BorderRadius.circular(10);

    return Material(
      color: color ?? colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          height: height,
          padding: padding,
          child: Align(
            alignment: alignment!,
            child: widget ??
                Text(
                  text!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: textColor ?? colorScheme.onSurface,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
