import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IsselButton extends StatelessWidget {

  final String text;
  final double height;
  final double width;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final Color? color;
  final Color? textColor;

  const IsselButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.textColor,
    this.focusNode,
    this.width = double.infinity,
    this.height = 60
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    ColorScheme colorScheme = theme.colorScheme;
    return FilledButton(
        focusNode: focusNode,
        onPressed: onTap,
        style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            fixedSize: Size.fromHeight(height),
            minimumSize: Size(width, height),
            maximumSize: Size(width, height),
            visualDensity: VisualDensity.standard,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: color,
            enabledMouseCursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic
        ),
        child: Text(text, style: textTheme.bodyMedium?.copyWith(color: textColor ?? colorScheme.onPrimary, fontWeight: FontWeight.bold),)
    );
  }
}
