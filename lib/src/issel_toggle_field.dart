import 'package:flutter/material.dart';
import 'package:issel_code_widgets/src/issel_toggle.dart';

class IsselToggleField extends StatelessWidget {

  final bool value;
  final String title;
  final double height;
  final double width;
  final Color? backColor;
  final ValueChanged<bool> onChanged;

  const IsselToggleField({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.height = 50,
    this.width = 60,
    this.backColor,
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
        color: backColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          // Text
          Expanded(
            child: Text(
                title
            )
          ),

          // Switch
          IsselToggle(
            onChanged: onChanged,
            value: value,
            height: height,
            width: width,
            backColor: backColor,
          )

        ],
      ),
    );
  }
}
