import 'package:flutter/material.dart';

import '../issel_pill.dart';

class IsselRowTable extends StatelessWidget {
  final List<IsselPill> cells;

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
