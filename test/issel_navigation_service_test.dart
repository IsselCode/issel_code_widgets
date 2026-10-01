import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:issel_code_widgets/issel_code_widgets.dart';

void main() {
  test('navigation reports an unattached key rather than losing the action',
      () {
    final navigation = IsselNavigationService();

    expect(navigation.isReady, isFalse);
    expect(navigation.canGoBack, isFalse);
    expect(
      () => navigation.navigateTo<void>(const _Page('Detalle')),
      throwsStateError,
    );
  });

  testWidgets('a typed result returns to the caller and root back is safe',
      (tester) async {
    final navigation = IsselNavigationService();
    await _mount(tester, navigation);

    expect(navigation.isReady, isTrue);
    expect(await navigation.goBack<void>(), isFalse);
    final result = navigation.navigateTo<String>(const _Page('Detalle'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle'), findsOneWidget);
    expect(navigation.canGoBack, isTrue);
    expect(await navigation.goBack('guardado'), isTrue);
    await tester.pumpAndSettle();

    expect(await result, 'guardado');
    expect(find.text('Inicio'), findsOneWidget);
    expect(navigation.canGoBack, isFalse);
  });

  testWidgets('route settings reach the page with their arguments',
      (tester) async {
    final key = GlobalKey<NavigatorState>();
    final navigation = IsselNavigationService(navigatorKey: key);
    await _mount(tester, navigation);
    final arguments = {'id': 42};
    RouteSettings? received;

    navigation.navigateTo<void>(
      Builder(builder: (context) {
        received = ModalRoute.of(context)!.settings;
        return const _Page('Cliente');
      }),
      settings: RouteSettings(name: '/clients/42', arguments: arguments),
    );
    await tester.pumpAndSettle();

    expect(navigation.navigatorKey, same(key));
    expect(received?.name, '/clients/42');
    expect(received?.arguments, same(arguments));
  });

  testWidgets('replacement completes the old route with its own result type',
      (tester) async {
    final navigation = IsselNavigationService();
    await _mount(tester, navigation);
    final oldResult = navigation.navigateTo<int>(const _Page('Anterior'));
    await tester.pumpAndSettle();

    final newResult = navigation.pushReplacement<String, int>(
      const _Page('Nueva'),
      result: 42,
    );
    await tester.pumpAndSettle();

    expect(await oldResult, 42);
    expect(find.text('Anterior'), findsNothing);
    expect(find.text('Nueva'), findsOneWidget);
    await navigation.goBack('terminado');
    await tester.pumpAndSettle();
    expect(await newResult, 'terminado');
    expect(find.text('Inicio'), findsOneWidget);
  });

  testWidgets('resetting navigation prevents returning to previous screens',
      (tester) async {
    final navigation = IsselNavigationService();
    await _mount(tester, navigation);
    navigation.navigateTo<void>(const _Page('Área privada'));
    await tester.pumpAndSettle();

    navigation.pushAndRemoveUntil<void>(const _Page('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Área privada', skipOffstage: false), findsNothing);
    expect(find.text('Inicio', skipOffstage: false), findsNothing);
    expect(await navigation.goBack<void>(), isFalse);
  });

  testWidgets('a reset predicate preserves the selected part of the stack',
      (tester) async {
    final navigation = IsselNavigationService();
    await _mount(tester, navigation);
    navigation.navigateTo<void>(
      const _Page('Sección'),
      settings: const RouteSettings(name: '/section'),
    );
    await tester.pumpAndSettle();
    navigation.navigateTo<void>(const _Page('Detalle anterior'));
    await tester.pumpAndSettle();

    navigation.pushAndRemoveUntil<void>(
      const _Page('Nuevo detalle'),
      predicate: (route) => route.settings.name == '/section',
    );
    await tester.pumpAndSettle();
    await navigation.goBack<void>();
    await tester.pumpAndSettle();

    expect(find.text('Sección'), findsOneWidget);
    expect(find.text('Detalle anterior', skipOffstage: false), findsNothing);
    await navigation.goBack<void>();
    await tester.pumpAndSettle();
    expect(find.text('Inicio'), findsOneWidget);
  });

  testWidgets(
      'returning by widget type preserves root if the target is missing',
      (tester) async {
    final navigation = IsselNavigationService();
    await _mount(tester, navigation);
    navigation.navigateTo<void>(const _Page('Sección'));
    await tester.pumpAndSettle();
    navigation.navigateTo<void>(const _OtherPage());
    await tester.pumpAndSettle();

    navigation.popUntilWidget(_Page);
    await tester.pumpAndSettle();
    expect(find.text('Sección'), findsOneWidget);

    navigation.popUntilRoute('/missing');
    await tester.pumpAndSettle();
    expect(find.text('Inicio'), findsOneWidget);
    expect(navigation.canGoBack, isFalse);
  });

  testWidgets('back respects a page that blocks leaving through PopScope',
      (tester) async {
    final navigation = IsselNavigationService();
    await _mount(tester, navigation);
    navigation.navigateTo<void>(
      const PopScope<void>(canPop: false, child: _Page('Sin guardar')),
    );
    await tester.pumpAndSettle();

    expect(navigation.canGoBack, isTrue);
    expect(await navigation.goBack<void>(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Sin guardar'), findsOneWidget);
  });

  testWidgets('custom routes keep their transitions and typed results',
      (tester) async {
    final navigation = IsselNavigationService();
    await _mount(tester, navigation);
    final route = PageRouteBuilder<int>(
      settings: const RouteSettings(name: '/custom'),
      pageBuilder: (_, __, ___) => const _Page('Personalizada'),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
    final result = navigation.pushRoute(route);
    await tester.pumpAndSettle();

    expect(route.isCurrent, isTrue);
    await navigation.goBack(7);
    await tester.pumpAndSettle();
    expect(await result, 7);
  });
}

Future<void> _mount(WidgetTester tester, IsselNavigationService navigation) {
  return tester.pumpWidget(
    MaterialApp(
        navigatorKey: navigation.navigatorKey, home: const _Page('Inicio')),
  );
}

class _Page extends StatelessWidget {
  const _Page(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Scaffold(body: Text(label));
}

class _OtherPage extends StatelessWidget {
  const _OtherPage();

  @override
  Widget build(BuildContext context) => const _Page('Otra pantalla');
}
