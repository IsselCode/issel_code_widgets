import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:issel_code_widgets/issel_code_widgets.dart';

void main() {
  const items = [
    IsselNavigationItem(id: 'home', label: 'Inicio', icon: Icons.home),
    IsselNavigationItem(
      id: 'products',
      label: 'Productos',
      icon: Icons.inventory_2,
    ),
    IsselNavigationItem(
      id: 'disabled',
      label: 'No disponible',
      icon: Icons.lock,
      enabled: false,
    ),
  ];

  testWidgets('pane selection follows its owner and disabled items do not fire',
      (tester) async {
    String? clicked;
    Future<void> show(String selectedId) => tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: IsselNavigationPane(
              items: items,
              selectedId: selectedId,
              onSelected: (id) => clicked = id,
            ),
          ),
        ));

    await show('home');
    await tester.tap(find.text('Productos'));
    expect(clicked, 'products');
    await show('products');
    final selected = tester.widget<Text>(find.text('Productos'));
    final context = tester.element(find.text('Productos'));
    expect(selected.style?.color, Theme.of(context).colorScheme.onPrimary);
    await tester.tap(find.text('No disponible'));
    expect(clicked, 'products');
  });

  testWidgets('caption actions are accessible from keyboard', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    var pressed = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: IsselCaptionButton(
          tooltip: 'Abrir menú',
          focusNode: focus,
          icon: const Icon(Icons.menu),
          onPressed: () => pressed++,
        ),
      ),
    ));
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(pressed, 1);
    expect(find.byTooltip('Abrir menú'), findsOneWidget);
  });

  testWidgets('desktop frame reserves caption and reclaims closed sidebar',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    const contentKey = ValueKey('content');
    Future<void> show(bool open, {bool edgeToEdge = false}) =>
        tester.pumpWidget(MaterialApp(
          home: IsselDesktopScaffold(
            sidebarOpen: open,
            edgeToEdge: edgeToEdge,
            caption: const IsselDesktopCaption(title: Text('Productos')),
            sidebar: IsselNavigationPane(
              items: items,
              selectedId: 'home',
              onSelected: (_) {},
            ),
            child: const SizedBox.expand(key: contentKey),
          ),
        ));

    await show(true);
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(190, 32));
    expect(tester.getSize(find.byKey(contentKey)), const Size(1010, 768));
    await show(false);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(0, 32));
    expect(tester.getSize(find.byKey(contentKey)).width, 1200);
    await show(true, edgeToEdge: true);
    expect(tester.getTopLeft(find.byKey(contentKey)), Offset.zero);
    expect(tester.getSize(find.byKey(contentKey)), const Size(1200, 800));
  });

  testWidgets('narrow desktop menu overlays content and can be dismissed',
      (tester) async {
    var dismissed = false;
    await tester.pumpWidget(MaterialApp(
      home: IsselDesktopScaffold(
        sidebarOpen: true,
        onSidebarClose: () => dismissed = true,
        caption: const IsselDesktopCaption(title: Text('Productos')),
        sidebar: IsselNavigationPane(
          items: items,
          selectedId: 'products',
          onSelected: (_) {},
        ),
        child: const SizedBox.expand(key: ValueKey('content')),
      ),
    ));
    expect(tester.getTopLeft(find.byKey(const ValueKey('content'))).dx, 0);
    await tester.tapAt(const Offset(700, 300));
    expect(dismissed, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('long caption breadcrumbs remain bounded and copy is distinct',
      (tester) async {
    var copied = 0;
    var opened = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 240,
          child: IsselDesktopCaption(
            title: IsselBreadcrumbs(items: [
              const IsselBreadcrumbItem(label: 'Administración de productos'),
              IsselBreadcrumbItem(
                label: 'Identificador de producto muy largo',
                onTap: () => opened++,
                onCopy: () => copied++,
              ),
            ]),
          ),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Copiar'));
    expect(copied, 1);
    expect(opened, 0);
  });
}
