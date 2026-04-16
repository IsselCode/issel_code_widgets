import 'package:flutter/material.dart';
import 'package:issel_code_widgets/src/issel_table/issel_header_table.dart';
import 'package:issel_code_widgets/src/issel_table/issel_row_table.dart';

/// Tabla personalizada con encabezado fijo y filas desplazables.
///
/// Cada fila debe tener una cantidad de celdas menor o igual a la cantidad de
/// columnas del encabezado.
class IsselTableWidget extends StatefulWidget {
  /// Encabezado de la tabla.
  final IsselHeaderTable header;

  /// Filas mostradas debajo del encabezado.
  final List<IsselRowTable> rows;

  /// Color de fondo opcional de la tabla.
  final Color? color;

  /// Indica si se muestra el resaltado al pasar el cursor sobre una fila.
  final bool showHoverRow;

  /// Callback invocado al tocar una fila.
  final Function(int index)? onTapRow;

  /// Crea una tabla con encabezado y filas.
  IsselTableWidget({
    super.key,
    required this.header,
    required this.rows,
    this.onTapRow,
    this.color,
    this.showHoverRow = true,
  }) : assert(
          rows.every((row) => row.cells.length <= header.titleHeaders.length),
          'IsselTableWidget: una fila tiene más celdas que las columnas de encabezado.',
        );

  @override
  State<IsselTableWidget> createState() => _IsselTableWidgetState();
}

class _IsselTableWidgetState extends State<IsselTableWidget> {
  int? hoverIndex;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.color ?? colorScheme.surface),
      child: Column(
        children: [
          //* Header
          widget.header,
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  widget.rows.length,
                  (index) {
                    return Column(
                      children: [
                        if (index != 0) const SizedBox(height: 5),
                        InkWell(
                          onTap: widget.showHoverRow || widget.onTapRow != null
                              ? widget.onTapRow != null
                                  ? () {
                                      widget.onTapRow?.call(index);
                                    }
                                  : () {}
                              : null,
                          onHover: widget.showHoverRow
                              ? (value) {
                                  value
                                      ? hoverIndex = index
                                      : hoverIndex = null;
                                  setState(() {});
                                }
                              : null,
                          child: Stack(
                            children: [
                              widget.rows[index],
                              if (hoverIndex == index)
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            colorScheme.primary.withAlpha(15),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
