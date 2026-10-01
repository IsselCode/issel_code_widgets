import 'package:flutter/material.dart';

import 'issel_caption_button.dart';

class IsselBreadcrumbItem {
  const IsselBreadcrumbItem({
    required this.label,
    this.onTap,
    this.onCopy,
    this.copyTooltip = 'Copiar',
  });

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;
  final String copyTooltip;
}

/// Breadcrumbs acotados al espacio de la barra, con acciones opcionales.
class IsselBreadcrumbs extends StatelessWidget {
  const IsselBreadcrumbs({super.key, required this.items});

  final List<IsselBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('>', style: TextStyle(color: color)),
            ),
          Flexible(
            child: _Breadcrumb(item: items[index], color: color),
          ),
        ],
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.item, required this.color});

  final IsselBreadcrumbItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      item.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: item.onTap == null
              ? label
              : InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: label,
                  ),
                ),
        ),
        if (item.onCopy != null)
          IsselCaptionButton(
            icon: const Icon(Icons.copy_outlined),
            iconSize: 14,
            size: 22,
            tooltip: item.copyTooltip,
            onPressed: item.onCopy,
          ),
      ],
    );
  }
}
