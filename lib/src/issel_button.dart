import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Botón principal con el estilo visual del paquete.
///
/// Usa [FilledButton] internamente y permite controlar el tamaño, colores,
/// foco y acción de presión.
class IsselButton extends StatelessWidget {
  /// Texto mostrado dentro del botón.
  final String text;

  /// Altura fija del botón.
  final double height;

  /// Ancho mínimo y máximo del botón.
  final double width;

  /// Callback invocado al presionar el botón.
  ///
  /// Si es null, el botón queda deshabilitado.
  final VoidCallback? onTap;

  /// Nodo de foco opcional usado por el botón.
  final FocusNode? focusNode;

  /// Color de fondo opcional.
  final Color? color;

  /// Color opcional del texto.
  final Color? textColor;

  /// Crea un botón con texto y dimensiones configurables.
  const IsselButton(
      {super.key,
      required this.text,
      this.onTap,
      this.color,
      this.textColor,
      this.focusNode,
      this.width = double.infinity,
      this.height = 60});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    return FilledButton(
        focusNode: focusNode,
        onPressed: onTap,
        style: FilledButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            fixedSize: Size.fromHeight(height),
            minimumSize: Size(width, height),
            maximumSize: Size(width, height),
            visualDensity: VisualDensity.standard,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: color,
            enabledMouseCursor: onTap != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic),
        child: Text(
          text,
          style: textTheme.bodyMedium?.copyWith(
              color: textColor ?? colorScheme.onPrimary,
              fontWeight: FontWeight.bold),
        ));
  }
}
