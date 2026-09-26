import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:issel_code_widgets/issel_code_widgets.dart';

void main() {
  test('IsselThemeController exposes configurable semantic colors', () {
    final controller = IsselThemeController(
      lightColors: const IsselThemeColors.light(
        primary: Color(0xff7B1FA2),
        surfaceContainer: Color(0xffE0D4E8),
      ),
    );

    expect(controller.lightTheme.colorScheme.primary, const Color(0xff7B1FA2));
    expect(
      controller.lightTheme.colorScheme.surfaceContainer,
      const Color(0xffE0D4E8),
    );

    controller.updateLightColors(
      const IsselThemeColors.light(primary: Color(0xff00695C)),
    );

    expect(controller.lightTheme.colorScheme.primary, const Color(0xff00695C));

    controller.updateText(
      const IsselTextThemeConfig(bodyMediumHeight: 1.2),
    );
    expect(controller.lightTheme.textTheme.bodyMedium?.height, 1.2);
    expect(controller.darkTheme.textTheme.bodyMedium?.height, 1.2);

    controller.dispose();
  });

  testWidgets('IsselThemeSelector adapts its cards to mobile content', (
    tester,
  ) async {
    final controller = IsselThemeController(themeMode: ThemeMode.system);
    ThemeMode? changedMode;

    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      controller.dispose();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IsselThemeSelector(
            controller: controller,
            onChanged: (mode) => changedMode = mode,
          ),
        ),
      ),
    );

    final systemCard = find.ancestor(
      of: find.text('Sistema'),
      matching: find.byType(AnimatedContainer),
    );
    expect(tester.getSize(systemCard.first).height, lessThan(250));

    await tester.tap(find.text('Claro'));
    await tester.pumpAndSettle();

    expect(controller.themeMode, ThemeMode.light);
    expect(changedMode, ThemeMode.light);
  });

  test('IsselTextThemeConfig starts every text height at 1.0', () {
    const config = IsselTextThemeConfig();
    final textTheme = config.build(outline: Colors.grey);

    expect(textTheme.displayLarge?.height, 1.0);
    expect(textTheme.titleMedium?.height, 1.0);
    expect(textTheme.bodyMedium?.height, 1.0);
    expect(textTheme.labelSmall?.height, 1.0);
  });

  testWidgets('IsselFilterBar changes the selected value', (tester) async {
    String selected = 'all';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IsselFilterBar<String>(
            value: selected,
            options: const [
              IsselFilterOption(value: 'all', label: 'Todos'),
              IsselFilterOption(value: 'active', label: 'Activos'),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('Activos'), findsOneWidget);

    await tester.tap(find.text('Activos'));

    expect(selected, 'active');
  });

  testWidgets('IsselSearchDropdown can render its menu as an overlay', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 240,
            child: IsselSearchDropdown<String>(
              value: selected,
              hintText: 'Selecciona una opción',
              overlay: true,
              items: const [
                DropdownMenuItem(value: 'one', child: Text('Opción uno')),
                DropdownMenuItem(value: 'two', child: Text('Opción dos')),
              ],
              onChanged: (value) => selected = value,
            ),
          ),
        ),
      ),
    );

    final dropdown = find.byType(IsselSearchDropdown<String>);
    final initialSize = tester.getSize(dropdown);

    await tester.tap(find.text('Selecciona una opción'));
    await tester.pumpAndSettle();

    expect(find.text('Opción uno'), findsOneWidget);
    expect(tester.getSize(dropdown), initialSize);

    await tester.tap(find.text('Opción dos'));
    await tester.pumpAndSettle();

    expect(selected, 'two');
    expect(find.text('Selecciona una opción'), findsOneWidget);
  });

  testWidgets(
    'IsselSearchDropdown keeps the selected label when options are reloaded',
    (tester) async {
      String? selected;
      var items = const [
        DropdownMenuItem(value: 'one', child: Text('OpciÃ³n uno')),
        DropdownMenuItem(value: 'two', child: Text('OpciÃ³n dos')),
      ];

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 240,
                child: IsselSearchDropdown<String>(
                  value: selected,
                  hintText: 'Selecciona una opciÃ³n',
                  overlay: true,
                  items: items,
                  onChanged: (value) => setState(() {
                    selected = value;
                    items = const [
                      DropdownMenuItem(
                        value: 'one',
                        child: Text('OpciÃ³n uno'),
                      ),
                    ];
                  }),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Selecciona una opciÃ³n'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OpciÃ³n dos'));
      await tester.pumpAndSettle();

      expect(selected, 'two');
      expect(find.text('OpciÃ³n dos'), findsOneWidget);
    },
  );

  testWidgets(
    'IsselSearchDropdown refreshes overlay items after search updates',
    (tester) async {
      var query = '';
      var items = <String>['Alpha', 'Beta', 'Gamma'];

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: IsselSearchDropdown<String>(
                overlay: true,
                hintText: 'Proyecto',
                items: [
                  for (final item in items)
                    DropdownMenuItem(value: item, child: Text(item)),
                ],
                onChanged: (_) {},
                onSearchChanged: (value) => setState(() {
                  query = value;
                  items = items
                      .where(
                        (item) =>
                            item.toLowerCase().contains(value.toLowerCase()),
                      )
                      .toList();
                }),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Proyecto'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'al');
      await tester.pumpAndSettle();

      expect(query, 'al');
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsNothing);
      expect(find.text('Gamma'), findsNothing);
    },
  );

  testWidgets('IsselImagePicker invokes its callback', (tester) async {
    var tapped = false;
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: IsselImagePicker(
              onTap: () => tapped = true,
              pickImage: () async => null,
              validator: (bytes) =>
                  bytes == null ? 'Selecciona una imagen' : null,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Seleccionar imagen'), findsOneWidget);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Selecciona una imagen'), findsOneWidget);
    await tester.tap(find.text('Seleccionar imagen'));

    expect(tapped, isTrue);
  });

  testWidgets('IsselImagePicker clears the selected image', (tester) async {
    Uint8List? selected = base64Decode(
      'R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IsselImagePicker(
            bytes: selected,
            onChanged: (value) => selected = value,
            pickImage: () async => null,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.close_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_outlined));
    await tester.pump();

    expect(selected, isNull);
    expect(find.byIcon(Icons.close_outlined), findsNothing);
  });
}
