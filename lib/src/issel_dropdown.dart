import 'package:flutter/material.dart';

/// Dropdown simple con contenedor estilizado.
///
/// Permite seleccionar valores de tipo [T] usando una lista de
/// [DropdownMenuItem].
class IsselDropdown<T> extends StatelessWidget {
  /// Valor seleccionado actualmente.
  final T? value;

  /// Texto mostrado cuando no hay valor seleccionado.
  final String hintText;

  /// Opciones disponibles en el dropdown.
  final List<DropdownMenuItem<T>>? items;

  /// Callback invocado cuando cambia el valor seleccionado.
  final void Function(T?)? onChanged;

  /// Altura del contenedor del dropdown.
  final double height;

  /// Color de fondo opcional.
  ///
  /// Si es null, usa [ColorScheme.surface].
  final Color? color;

  /// Crea un dropdown estilizado.
  const IsselDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.height = 50,
    this.value,
    this.color,
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
          color: color ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
            hint: Text(
              hintText,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
            style: textTheme.bodyMedium,
            padding: EdgeInsets.zero,
            value: value,
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            items: items,
            onChanged: onChanged),
      ),
    );
  }
}
