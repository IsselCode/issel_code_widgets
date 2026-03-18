import 'package:flutter/material.dart';
import 'package:issel_code_widgets/src/issel_table/issel_header_table.dart';
import 'package:issel_code_widgets/src/issel_table/issel_row_table.dart';

class IsselTableWidget extends StatelessWidget {

  final IsselHeaderTable header;
  final List<IsselRowTable> rows;
  final Color? color;

  IsselTableWidget({
    super.key,
    required this.header,
    required this.rows,
    this.color,
  }) : assert(
    rows.every((row) => row.cells.length <= header.titleHeaders.length),
    'IsselTableWidget: una fila tiene más celdas que las columnas de encabezado.',
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? colorScheme.surface
      ),
      child: Column(
        children: [
          //* Header
          header,
          const SizedBox(height: 5,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  rows.length,
                  (index) {
                    return Column(
                      children: [
                        if (index != 0) const SizedBox(height: 5),
                        rows[index]
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
