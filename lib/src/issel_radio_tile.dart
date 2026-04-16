import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// Opción seleccionable horizontal con texto.
///
/// Se considera seleccionada cuando [value] coincide con [groupValue].
class IsselRadioTile<T> extends StatelessWidget {
  /// Valor representado por esta opción.
  final T value;

  /// Valor seleccionado del grupo.
  final T? groupValue;

  /// Texto mostrado en la opción.
  final String label;

  /// Callback invocado al seleccionar la opción.
  final ValueChanged<T>? onChanged; // ← callback

  /// Altura de la opción.
  final double height;

  /// Color de fondo cuando la opción no está seleccionada.
  final Color? surfaceColor;

  /// Alineación del texto dentro de la opción.
  final AlignmentGeometry alignment;

  /// Crea una opción tipo tile para un grupo de selección.
  const IsselRadioTile(
      {super.key,
      required this.value,
      required this.label,
      required this.alignment,
      this.groupValue,
      this.onChanged,
      this.height = 125,
      this.surfaceColor});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return FilledButton(
      onPressed: () => onChanged?.call(value),
      style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(height),
          maximumSize: Size.fromHeight(height),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
          backgroundColor: value == groupValue
              ? colorScheme.primary
              : surfaceColor ?? colorScheme.surface),
      child: Align(
        alignment: alignment,
        child: Text(
          label,
          maxLines: 1,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
