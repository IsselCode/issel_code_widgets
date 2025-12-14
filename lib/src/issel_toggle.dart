import 'package:flutter/material.dart';


class IsselToggle extends StatelessWidget {

  final bool value;
  final double height;
  final double width;
  final ValueChanged<bool> onChanged;
  final Color? backColor;

  const IsselToggle({
    super.key,
    required this.onChanged,
    required this.value,
    this.height = 50,
    this.width = 60,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    final double switchHeight = height * 0.65;
    final double thumbMargin = 4;
    final double thumbSize = switchHeight - thumbMargin * 2;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(height * 0.5),
      child: Container(
        height: switchHeight,
        width: width,
        padding: EdgeInsets.all(thumbMargin),
        decoration: BoxDecoration(
          color: backColor ?? theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(height * 0.5)
        ),
        child: AnimatedAlign(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: Container(
            height: thumbSize,
            width: thumbSize,
            decoration: BoxDecoration(
              color: value ? colorScheme.primary : colorScheme.outline,
              shape: BoxShape.circle
            ),
          ),
        ),
       ),
    );
  }
}
