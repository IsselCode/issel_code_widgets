import 'package:flutter/material.dart';

import 'package:issel_code_widgets/src/issel_pill.dart';

/// Opción que puede seleccionarse desde una [IsselFilterBar].
class IsselFilterOption<T> {
  /// Crea una opción de filtro.
  const IsselFilterOption({required this.value, required this.label});

  /// Valor que se entrega al seleccionar la opción.
  final T value;

  /// Texto mostrado en la opción.
  final String label;
}

/// Barra horizontal de filtros basada en [IsselPill].
///
/// Las opciones se desplazan horizontalmente cuando no caben en el espacio
/// disponible. La opción cuyo valor coincide con [value] se muestra como
/// seleccionada.
class IsselFilterBar<T> extends StatelessWidget {
  /// Crea una barra horizontal de filtros.
  const IsselFilterBar({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.height = 48,
    this.itemHeight = 44,
    this.padding = EdgeInsets.zero,
    this.spacing = 8,
    this.selectedColor,
    this.selectedTextColor,
    this.unselectedColor,
    this.unselectedTextColor,
  });

  /// Valor de la opción seleccionada.
  final T value;

  /// Opciones disponibles en la barra.
  final List<IsselFilterOption<T>> options;

  /// Callback invocado con el valor de la opción seleccionada.
  final ValueChanged<T> onChanged;

  /// Altura total de la barra.
  final double height;

  /// Altura de cada opción.
  final double itemHeight;

  /// Espaciado exterior de la lista horizontal.
  final EdgeInsetsGeometry padding;

  /// Espacio entre opciones.
  final double spacing;

  /// Color de la opción seleccionada.
  final Color? selectedColor;

  /// Color del texto de la opción seleccionada.
  final Color? selectedTextColor;

  /// Color de las opciones no seleccionadas.
  final Color? unselectedColor;

  /// Color del texto de las opciones no seleccionadas.
  final Color? unselectedTextColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: options.length,
        separatorBuilder: (_, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final option = options[index];
          final selected = option.value == value;
          return IsselPill(
            height: itemHeight,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            text: option.label,
            color: selected
                ? selectedColor ?? colors.onSurface
                : unselectedColor ?? colors.surface,
            textColor: selected
                ? selectedTextColor ?? colors.surface
                : unselectedTextColor ?? colors.onSurface,
            onTap: () => onChanged(option.value),
          );
        },
      ),
    );
  }
}
