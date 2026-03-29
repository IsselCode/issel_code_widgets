import 'package:flutter/material.dart';
import 'package:issel_code_widgets/src/issel_table/issel_header_table.dart';
import 'package:issel_code_widgets/src/issel_table/issel_row_table.dart';

class IsselTableWidget extends StatefulWidget {

  final IsselHeaderTable header;
  final List<IsselRowTable> rows;
  final Color? color;
  final bool showHoverRow;
  final Function(int index)? onTapRow;

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
          color: widget.color ?? colorScheme.surface
      ),
      child: Column(
        children: [
          //* Header
          widget.header,
          const SizedBox(height: 5,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  widget.rows.length, (index) {
                  return Column(
                    children: [
                      if (index != 0) const SizedBox(height: 5),
                      InkWell(
                        onTap: widget.showHoverRow || widget.onTapRow != null ? widget.onTapRow != null ? () {widget.onTapRow?.call(index);} : () {} : null,
                        onHover: widget.showHoverRow ? (value) {
                          value ? hoverIndex = index : hoverIndex = null;
                          setState(() {});
                        } : null,
                        child: Stack(
                          children: [
                            widget.rows[index],
                            if (hoverIndex == index)
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: colorScheme.primary.withAlpha(15),
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
