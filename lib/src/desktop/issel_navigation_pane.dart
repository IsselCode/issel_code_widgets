import 'package:flutter/material.dart';

/// Destino visual; rutas y permisos los resuelve la aplicación.
class IsselNavigationItem {
  const IsselNavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    this.enabled = true,
  });

  final String id;
  final String label;
  final IconData icon;
  final bool enabled;
}

/// Menú controlado por el destino real, sin guardar una selección independiente.
class IsselNavigationPane extends StatelessWidget {
  const IsselNavigationPane({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
    this.header,
    this.footer,
    this.width = 190,
  }) : assert(width > 0);

  final List<IsselNavigationItem> items;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final Widget? header;
  final Widget? footer;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SizedBox(
      width: width,
      child: Material(
        color: colors.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 22, 15, 18),
          child: Column(
            children: [
              if (header != null) ...[header!, const SizedBox(height: 24)],
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final selected = item.id == selectedId;
                    final foreground =
                        selected ? colors.onPrimary : colors.onSurface;
                    return Semantics(
                      selected: selected,
                      child: TextButton(
                        onPressed:
                            item.enabled ? () => onSelected(item.id) : null,
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor:
                              selected ? colors.primary : Colors.transparent,
                          foregroundColor: foreground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(item.icon, size: 19),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.label,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: item.enabled
                                      ? foreground
                                      : theme.disabledColor,
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (footer != null) ...[const SizedBox(height: 14), footer!],
            ],
          ),
        ),
      ),
    );
  }
}
