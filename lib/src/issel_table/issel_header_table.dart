import 'package:flutter/material.dart';

import '../issel_pill.dart';

class IsselHeaderTable extends StatelessWidget {
  final List<String> titleHeaders;

  const IsselHeaderTable({
    super.key,
    required this.titleHeaders,
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
                    text: titleHeaders[index],
                    color: colorScheme.inverseSurface,
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
