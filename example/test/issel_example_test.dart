import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:issel_code_widgets/issel_code_widgets.dart';

import 'package:issel_code_widgets_example/main.dart';

void main() {
  testWidgets('action header keeps long title bounded and renders its subtitle',
      (tester) async {
    final theme = IsselThemeController();
    addTearDown(theme.dispose);
    await tester.pumpWidget(MaterialApp(
      theme: theme.lightTheme,
      home: Scaffold(
        body: SizedBox(
          width: 250,
          child: IsselHeaderActionTile(
            title: 'Nombre comercial de cliente muy largo',
            subTitle: 'Plan Pro',
            textButton: 'Abrir',
            onPressed: () {},
          ),
        ),
      ),
    ));
    expect(find.text('Plan Pro'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'example changes theme and adapts desktop menu to a mobile drawer',
      (tester) async {
    tester.view.physicalSize = const Size(1366, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // La galería incluye indicadores animados que nunca quedan en reposo.
    Future<void> advance() async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
    }

    await tester.pumpWidget(const WidgetsExampleApp());
    await advance();
    expect(tester.takeException(), isNull);
    expect(find.byType(IsselDesktopScaffold), findsOneWidget);

    await tester.tap(find.byTooltip('Ocultar menú'));
    await advance();
    expect(find.byTooltip('Abrir menú'), findsOneWidget);
    await tester.tap(find.byTooltip('Abrir menú'));
    await advance();
    await tester.tap(find.text('Apariencia'));
    await advance();
    expect(find.byType(IsselThemeSelector), findsOneWidget);

    await tester.tap(find.text('Oscuro'));
    await advance();
    final context = tester.element(find.byType(IsselThemeSelector));
    expect(Theme.of(context).brightness, Brightness.dark);

    tester.view.physicalSize = const Size(360, 800);
    await advance();
    expect(find.byType(IsselDesktopScaffold), findsNothing);
    expect(find.byType(AppBar), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.menu));
    await advance();
    await tester.tap(find.text('Componentes'));
    await advance();
    expect(find.byType(IsselThemeSelector), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
