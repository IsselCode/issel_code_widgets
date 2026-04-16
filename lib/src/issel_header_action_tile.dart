import 'package:flutter/material.dart';
import 'package:issel_code_widgets/src/issel_button.dart';

/// Encabezado con texto descriptivo y un botón de acción.
class IsselHeaderActionTile extends StatelessWidget {
  /// Altura total del encabezado.
  final double height;

  /// Texto mostrado en el botón.
  final String textButton;

  /// Título principal del encabezado.
  final String title;

  /// Subtítulo descriptivo del encabezado.
  final String subTitle;

  /// Callback invocado al presionar el botón.
  final VoidCallback onPressed;

  /// Crea un encabezado con acción lateral.
  const IsselHeaderActionTile({
    super.key,
    this.height = 50,
    required this.textButton,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 10,
        children: [
          //* Text
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
                Text(
                  title,
                  style:
                      textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                )
              ],
            ),
          ),

          //* Buttón
          Expanded(child: IsselButton(text: textButton, onTap: onPressed))
        ],
      ),
    );
  }
}
