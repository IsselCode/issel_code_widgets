import 'package:flutter/material.dart';

class IsselPill extends StatelessWidget {

  final Color? color;
  final Color? textColor;
  final double? height;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTap;
  //* Text
  final String? text;
  //* Widget
  final Widget? widget;

  IsselPill({
    super.key,
    this.text,
    this.widget,
    this.onTap,
    this.height = 50,
    this.textColor,
    this.color,
    this.alignment = Alignment.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  }) : assert((text != null) ^ (widget != null), "Solo puedes colocar texto o widget", );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    TextTheme textTheme = theme.textTheme;

    final borderRadius = BorderRadius.circular(10);

    return Material(
      color: color ?? colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          height: height,
          padding: padding,
          child: Align(
            alignment: alignment!,
            child: widget ?? Text(
              text!,
              style: textTheme.bodyMedium?.copyWith(
                color: textColor ?? colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
