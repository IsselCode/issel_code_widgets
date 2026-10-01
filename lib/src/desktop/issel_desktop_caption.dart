import 'package:flutter/material.dart';

/// Barra global. [title] admite título o breadcrumbs de la aplicación.
///
/// El adaptador de plataforma proporciona [dragAreaBuilder] y [windowControls].
/// Las acciones quedan fuera del área arrastrable; no se invocan plugins aquí.
class IsselDesktopCaption extends StatelessWidget {
  const IsselDesktopCaption({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.actions = const [],
    this.windowControls,
    this.dragAreaBuilder,
    this.backgroundColor,
    this.height = 32,
  }) : assert(height >= 28);

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> actions;
  final Widget? windowControls;
  final Widget Function(BuildContext context, Widget child)? dragAreaBuilder;
  final Color? backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleArea = SizedBox(
      height: height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: DefaultTextStyle(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall!.copyWith(
            color: theme.colorScheme.primary,
          ),
          child: title,
        ),
      ),
    );

    return SizedBox(
      height: height,
      child: Material(
        color: backgroundColor ?? theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            if (leading != null) ...[
              const SizedBox(width: 6),
              leading!,
            ],
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: dragAreaBuilder?.call(context, titleArea) ?? titleArea,
              ),
            ),
            if (trailing != null) trailing!,
            for (final action in actions) ...[
              const SizedBox(width: 10),
              action,
            ],
            if (windowControls != null) ...[
              const SizedBox(width: 5),
              windowControls!,
            ],
          ],
        ),
      ),
    );
  }
}
