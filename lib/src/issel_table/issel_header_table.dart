import 'package:flutter/material.dart';

import '../issel_pill.dart';

/// Fila de encabezados para [IsselTableWidget].
class IsselHeaderTable extends StatelessWidget {
  /// Color de fondo opcional de las píldoras del encabezado.
  final Color? colorPills;

  /// Títulos mostrados como columnas del encabezado.
  final List<String> titleHeaders;

  /// Crea una fila de encabezados de tabla.
  const IsselHeaderTable({
    super.key,
    required this.titleHeaders,
    this.colorPills,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Row(
      children: List.generate(
        titleHeaders.length,
        (index) {
          return Expanded(
            child: Row(
              children: [
                if (index != 0) const SizedBox(width: 20),
                Expanded(
                  child: IsselPill(
                    widget: Text(
                      titleHeaders[index],
                      maxLines: 1,
                    ),
                    color: colorPills ?? colorScheme.surface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
