import 'package:flutter/material.dart';

import 'issel_caption_button.dart';
import 'issel_desktop_config.dart';

/// Shell de escritorio: menú lateral, barra global y área de contenido.
///
/// En rutas normales reserva la altura de la barra una sola vez. En
/// [edgeToEdge] la barra se superpone y el contenido ocupa toda la ventana.
/// Cuando falta ancho, el menú se presenta sobre el contenido.
class IsselDesktopScaffold extends StatelessWidget {
  const IsselDesktopScaffold({
    super.key,
    required this.caption,
    required this.child,
    this.sidebar,
    this.sidebarOpen = false,
    this.onSidebarClose,
    this.edgeToEdge = false,
    this.config = const IsselDesktopConfig(),
  });

  final Widget caption;
  final Widget child;
  final Widget? sidebar;
  final bool sidebarOpen;
  final VoidCallback? onSidebarClose;
  final bool edgeToEdge;
  final IsselDesktopConfig config;

  Widget get _content => Column(
        children: [
          SizedBox(height: config.captionHeight, child: caption),
          Expanded(child: child),
        ],
      );

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (edgeToEdge) {
              return Stack(
                children: [
                  Positioned.fill(child: child),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: config.captionHeight,
                    child: caption,
                  ),
                ],
              );
            }

            final showSidebar = sidebar != null && sidebarOpen;
            if (constraints.maxWidth < config.sidebarBreakpoint) {
              return Stack(
                children: [
                  Positioned.fill(child: _content),
                  if (showSidebar) ...[
                    Positioned(
                      top: config.captionHeight,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ModalBarrier(
                        color: Theme.of(context)
                            .colorScheme
                            .scrim
                            .withValues(alpha: 0.25),
                        dismissible: onSidebarClose != null,
                        onDismiss: onSidebarClose,
                      ),
                    ),
                    Positioned(
                      top: config.captionHeight,
                      bottom: 0,
                      left: 0,
                      width: config.sidebarWidth.clamp(0, constraints.maxWidth),
                      child: sidebar!,
                    ),
                  ],
                ],
              );
            }

            return Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (sidebar != null)
                        ClipRect(
                          child: AnimatedAlign(
                            alignment: Alignment.centerLeft,
                            duration: config.animationDuration,
                            curve: Curves.easeOutCubic,
                            widthFactor: showSidebar ? 1 : 0,
                            child: SizedBox(
                              width: config.sidebarWidth,
                              child: sidebar!,
                            ),
                          ),
                        ),
                      Expanded(child: _content),
                    ],
                  ),
                ),
                if (showSidebar && onSidebarClose != null)
                  AnimatedPositioned(
                    duration: config.animationDuration,
                    curve: Curves.easeOutCubic,
                    left: config.sidebarWidth - 14,
                    top: 0,
                    bottom: 0,
                    width: 28,
                    child: Center(
                      child: Material(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        child: IsselCaptionButton(
                          tooltip: 'Ocultar menú',
                          icon: const Icon(Icons.chevron_left),
                          onPressed: onSidebarClose,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
}
