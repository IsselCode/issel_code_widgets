import 'package:flutter/material.dart';

class IsselInfoField extends StatelessWidget {

  final String value;
  final String title;
  final double height;
  final Color? backColor;
  final Color? valueBackColor;

  const IsselInfoField({
    super.key,
    required this.title,
    required this.value,
    this.height = 50,
    this.backColor,
    this.valueBackColor,
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

          // Counter
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: valueBackColor ?? theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Text(
                  value,
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
