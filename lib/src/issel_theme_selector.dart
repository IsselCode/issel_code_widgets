import 'package:flutter/material.dart';

import 'theme/issel_theme.dart';

/// Selector visual para el modo claro, oscuro o del sistema.
///
/// El controlador mantiene el estado del tema. [onChanged] permite que la
/// aplicación persista la selección o ejecute otra acción después de cambiar
/// el modo.
class IsselThemeSelector extends StatelessWidget {
  const IsselThemeSelector({
    super.key,
    required this.controller,
    this.onChanged,
    this.labels = const <ThemeMode, String>{},
    this.descriptions = const <ThemeMode, String>{},
    this.wideBreakpoint = 760,
    this.cardSpacing = 12,
    this.previewHeight = 126,
  });

  /// Controlador que proporciona el modo actual y las paletas de preview.
  final IsselThemeController controller;

  /// Se invoca después de actualizar el modo del controlador.
  final ValueChanged<ThemeMode>? onChanged;

  /// Textos opcionales para reemplazar las etiquetas predeterminadas.
  final Map<ThemeMode, String> labels;

  /// Textos opcionales para reemplazar las descripciones predeterminadas.
  final Map<ThemeMode, String> descriptions;

  /// Ancho mínimo para presentar las opciones en una fila.
  final double wideBreakpoint;

  /// Espacio entre tarjetas.
  final double cardSpacing;

  /// Alto de la miniatura de cada tema.
  final double previewHeight;

  static const _defaultLabels = <ThemeMode, String>{
    ThemeMode.system: 'Sistema',
    ThemeMode.light: 'Claro',
    ThemeMode.dark: 'Oscuro',
  };

  static const _defaultDescriptions = <ThemeMode, String>{
    ThemeMode.system: 'Sigue la preferencia del sistema.',
    ThemeMode.light: 'Una interfaz luminosa y abierta.',
    ThemeMode.dark: 'Reduce el brillo en ambientes oscuros.',
  };

  static const _modes = <ThemeMode>[
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              for (final mode in _modes) _buildOptionCard(context, mode),
            ];

            if (constraints.maxWidth < wideBreakpoint) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < cards.length; index++) ...[
                    if (index > 0) SizedBox(height: cardSpacing),
                    cards[index],
                  ],
                ],
              );
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < cards.length; index++) ...[
                    if (index > 0) SizedBox(width: cardSpacing),
                    Expanded(child: cards[index]),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptionCard(BuildContext context, ThemeMode mode) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selected = controller.themeMode == mode;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: selected ? null : () => _select(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? colors.surfaceContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? colors.primary : colors.outline.withAlpha(90),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(_iconFor(mode), color: colors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      labels[mode] ?? _defaultLabels[mode]!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: selected ? colors.primary : colors.outline,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildPreview(context, mode),
              const SizedBox(height: 12),
              Text(
                descriptions[mode] ?? _defaultDescriptions[mode]!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _select(ThemeMode mode) {
    controller.setThemeMode(mode);
    onChanged?.call(mode);
  }

  Widget _buildPreview(BuildContext context, ThemeMode mode) {
    final preview = switch (mode) {
      ThemeMode.light => _buildMiniature(controller.lightConfig.colors),
      ThemeMode.dark => _buildMiniature(controller.darkConfig.colors),
      ThemeMode.system => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildMiniature(controller.lightConfig.colors)),
            Container(
              width: 2,
              color: Theme.of(context).colorScheme.surface,
            ),
            Expanded(child: _buildMiniature(controller.darkConfig.colors)),
          ],
        ),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(height: previewHeight, child: preview),
    );
  }

  Widget _buildMiniature(IsselThemeColors palette) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: palette.scaffoldBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 8,
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.58,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: palette.onSurface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: palette.surfaceContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: palette.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: palette.surfaceContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.dark => Icons.dark_mode_outlined,
      ThemeMode.system => Icons.brightness_auto_outlined,
    };
  }
}
