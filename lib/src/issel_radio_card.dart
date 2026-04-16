import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// Opción seleccionable tipo tarjeta con imagen y etiqueta.
///
/// Se considera seleccionada cuando [value] coincide con [groupValue].
class IsselRadioCard<T> extends StatelessWidget {
  /// Valor representado por esta opción.
  final T value;

  /// Valor seleccionado del grupo.
  final T? groupValue;

  /// Texto mostrado en la tarjeta.
  final String label;

  /// Ruta del asset mostrado como imagen.
  final String asset;

  /// Callback invocado al seleccionar la tarjeta.
  final ValueChanged<T>? onChanged; // ← callback

  /// Tamaño cuadrado de la tarjeta.
  final double size;

  /// Color de fondo cuando la tarjeta no está seleccionada.
  final Color? surfaceColor;

  /// Crea una opción tipo tarjeta para un grupo de selección.
  const IsselRadioCard(
      {super.key,
      required this.value,
      required this.label,
      required this.asset,
      this.groupValue,
      this.onChanged,
      this.size = 125,
      this.surfaceColor});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return FilledButton(
      onPressed: () => onChanged?.call(value),
      style: FilledButton.styleFrom(
          minimumSize: Size(size, size),
          maximumSize: Size(size, size),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
          backgroundColor: value == groupValue
              ? colorScheme.primary
              : surfaceColor ?? colorScheme.surface,
          enabledMouseCursor: onChanged != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            fit: BoxFit.contain,
            height: size * 0.4,
          ),
          AutoSizeText(
            label,
            maxLines: 1,
            minFontSize: (size * 0.10).roundToDouble(),
            maxFontSize: (size * 0.15).roundToDouble(),
            style: textTheme.bodyMedium?.copyWith(
                fontSize: (size * 0.15).roundToDouble(),
                color: value == groupValue
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface),
          )
        ],
      ),
    );
  }
}
