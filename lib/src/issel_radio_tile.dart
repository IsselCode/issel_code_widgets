import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IsselRadioTile<T> extends StatelessWidget {

  final T value;
  final T? groupValue;
  final String label;
  final String asset;
  final ValueChanged<T>? onChanged; // ← callback
  final double height;
  final Color? surfaceColor;
  final AlignmentGeometry alignment;

  const IsselRadioTile({
    super.key,
    required this.value,
    required this.label,
    required this.asset,
    required this.alignment,
    this.groupValue,
    this.onChanged,
    this.height = 125,
    this.surfaceColor
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    return FilledButton(
      onPressed: () => onChanged?.call(value),
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(height),
        maximumSize: Size.fromHeight(height),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(10),
        backgroundColor: value == groupValue ? colorScheme.primary : surfaceColor ?? colorScheme.surface
      ),
      child: Align(
        alignment: alignment,
        child: Text(
          label,
          maxLines: 1,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}

