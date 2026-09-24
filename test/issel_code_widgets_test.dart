import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:issel_code_widgets/issel_code_widgets.dart';

void main() {
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
