import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:issel_code_widgets/issel_code_widgets.dart';

void main() {
  test('app configuration applies theme and desktop overrides', () {
    final app = IsselAppController(
      config: const IsselAppConfig(
        title: 'Inventario',
        lightTheme: IsselThemeConfig(
          colors: IsselThemeColors.light(primary: Colors.purple),
          text: IsselTextThemeConfig(fontFamily: 'MiFuente'),
        ),
        desktop: IsselDesktopConfig(sidebarWidth: 220),
      ),
    );
    addTearDown(app.dispose);

    expect(app.config.title, 'Inventario');
    expect(app.config.desktop.sidebarWidth, 220);
    expect(app.theme.lightTheme.colorScheme.primary, Colors.purple);
    expect(app.theme.lightTheme.textTheme.bodyMedium?.fontFamily, 'MiFuente');
  });

  test('theme changes propagate and config updates preserve stable instances',
      () {
    final app = IsselAppController();
    addTearDown(app.dispose);
    final theme = app.theme;
    final navigation = app.navigation;
    final key = navigation.navigatorKey;
    var notifications = 0;
    app.addListener(() => notifications++);

    theme.setThemeMode(ThemeMode.dark);
    expect(app.config.themeMode, ThemeMode.dark);
    expect(notifications, 1);

    app.updateConfig(app.config.copyWith(
      title: 'Productos',
      lightTheme: app.config.lightTheme.copyWith(
        colors: const IsselThemeColors.light(primary: Colors.green),
      ),
    ));
    expect(notifications, 2);
    expect(app.theme, same(theme));
    expect(app.navigation, same(navigation));
    expect(app.navigation.navigatorKey, same(key));
    expect(app.theme.lightTheme.colorScheme.primary, Colors.green);
    expect(app.theme.themeMode, ThemeMode.dark);
  });

  test('async completion after disposal does not mutate or notify', () async {
    final pending = Completer<int>();
    final controller = _PendingController();
    var notifications = 0;
    controller.addListener(() => notifications++);

    final operation = controller.load(pending.future);
    controller.dispose();
    pending.complete(42);
    await operation;

    expect(controller.isDisposed, isTrue);
    expect(controller.value, isNull);
    expect(notifications, 0);
    controller.signal();
    expect(notifications, 0);
  });

  test('active async completion updates state and notifies', () async {
    final controller = _PendingController();
    addTearDown(controller.dispose);
    var notifications = 0;
    controller.addListener(() => notifications++);

    await controller.load(Future.value(42));
    expect(controller.value, 42);
    expect(notifications, 1);
  });
}

class _PendingController extends IsselController {
  int? value;

  Future<void> load(Future<int> future) async {
    final result = await future;
    if (isDisposed) return;
    value = result;
    notifyIfActive();
  }

  void signal() => notifyIfActive();
}
