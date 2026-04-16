import 'package:flutter/material.dart';

/// Campo informativo que muestra un título y un valor destacado.
class IsselInfoField extends StatelessWidget {
  /// Valor mostrado en el bloque derecho.
  final String value;

  /// Texto descriptivo mostrado en el bloque izquierdo.
  final String title;

  /// Altura total del campo.
  final double height;

  /// Color de fondo opcional del campo.
  final Color? backColor;

  /// Color de fondo opcional del bloque del valor.
  final Color? valueBackColor;

  /// Crea un campo informativo con título y valor.
  const IsselInfoField({
    super.key,
    required this.title,
    required this.value,
    this.height = 50,
    this.backColor,
    this.valueBackColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: backColor ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          // Text
          Expanded(child: Text(title)),

          // Counter
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: valueBackColor ?? theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
