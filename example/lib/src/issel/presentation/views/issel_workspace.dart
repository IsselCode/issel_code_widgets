import 'package:flutter/material.dart';
import 'package:issel_code_widgets/issel_code_widgets.dart';

import '../../../gallery/presentation/views/widgets_gallery_view.dart';

class IsselWorkspace extends StatefulWidget {
  const IsselWorkspace({super.key, required this.app});

  final IsselAppController app;

  @override
  State<IsselWorkspace> createState() => _IsselWorkspaceState();
}

class _IsselWorkspaceState extends State<IsselWorkspace> {
  String _section = 'gallery';
  bool _sidebarOpen = true;

  static const _items = [
    IsselNavigationItem(
      id: 'gallery',
      label: 'Componentes',
      icon: Icons.widgets_outlined,
    ),
    IsselNavigationItem(
      id: 'theme',
      label: 'Apariencia',
      icon: Icons.palette_outlined,
    ),
  ];

  String get _title => _items.firstWhere((item) => item.id == _section).label;

  Widget _pane({required double width, VoidCallback? afterSelection}) =>
      IsselNavigationPane(
        width: width,
        items: _items,
        selectedId: _section,
        header: Text(
          widget.app.config.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        onSelected: (id) {
          setState(() => _section = id);
          afterSelection?.call();
        },
      );

  void _toggleTheme() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    widget.app.theme.setThemeMode(dark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.app.config.desktop;
    final content = _section == 'gallery'
        ? const WidgetsGalleryPage()
        : _AppearanceView(controller: widget.app.theme);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < config.sidebarBreakpoint) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_title),
              actions: [
                IsselCaptionButton(
                  tooltip: 'Cambiar tema',
                  size: 44,
                  icon: const Icon(Icons.brightness_6_outlined),
                  onPressed: _toggleTheme,
                ),
              ],
            ),
            drawer: Drawer(
              width: 260,
              child: Builder(
                builder: (context) => _pane(
                  width: 260,
                  afterSelection: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            body: content,
          );
        }

        return IsselDesktopScaffold(
          config: config,
          sidebarOpen: _sidebarOpen,
          onSidebarClose: () => setState(() => _sidebarOpen = false),
          sidebar: _pane(width: config.sidebarWidth),
          caption: IsselDesktopCaption(
            height: config.captionHeight,
            leading: _sidebarOpen
                ? null
                : IsselCaptionButton(
                    tooltip: 'Abrir menú',
                    icon: const Icon(Icons.menu),
                    onPressed: () => setState(() => _sidebarOpen = true),
                  ),
            title: IsselBreadcrumbs(items: [
              IsselBreadcrumbItem(label: widget.app.config.title),
              IsselBreadcrumbItem(label: _title),
            ]),
            actions: [
              IsselCaptionButton(
                tooltip: 'Cambiar tema',
                icon: const Icon(Icons.brightness_6_outlined),
                onPressed: _toggleTheme,
              ),
            ],
          ),
          child: content,
        );
      },
    );
  }
}

class _AppearanceView extends StatelessWidget {
  const _AppearanceView({required this.controller});

  final IsselThemeController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: IsselThemeSelector(controller: controller),
            ),
          ),
        ),
      );
}
