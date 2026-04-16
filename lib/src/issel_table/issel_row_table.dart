import 'package:flutter/material.dart';
import '../issel_pill.dart';

/// Fila de datos para [IsselTableWidget].
class IsselRowTable extends StatelessWidget {
  /// Celdas mostradas en la fila.
  final List<IsselPill> cells;

  /// Crea una fila de tabla con celdas tipo [IsselPill].
  const IsselRowTable({
    super.key,
    required this.cells,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        cells.length,
        (index) {
          return Expanded(
            child: Row(
              children: [
                if (index != 0) const SizedBox(width: 20),
                Expanded(child: cells[index]),
              ],
            ),
          );
        },
      ),
    );
  }
}
