import 'package:flutter/material.dart';


class IsselDropdown<T> extends StatelessWidget {

  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final double height;
  final Color? color;

  const IsselDropdown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.height = 50,
    this.value,
    this.color,
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
        color: color ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(10)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text(hintText, style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),),
          style: textTheme.bodyMedium,
          padding: EdgeInsets.zero,
          value: value,
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          items: items,
          onChanged: onChanged
        ),
      ),
    );
  }
}
