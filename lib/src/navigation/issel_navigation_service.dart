import 'package:flutter/material.dart';

/// Navegación imperativa con una clave estable, inyectable desde la app.
///
/// Conecta [navigatorKey] al MaterialApp y conserva la misma instancia durante
/// su vida. El servicio no registra rutas ni crea un singleton global.
class IsselNavigationService {
  IsselNavigationService({GlobalKey<NavigatorState>? navigatorKey})
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> navigatorKey;

  bool get isReady => navigatorKey.currentState != null;

  /// Indica si hay otra ruta debajo de la actual, sin evaluar sus PopScope.
  bool get canGoBack => navigatorKey.currentState?.canPop() ?? false;

  NavigatorState get _navigator {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      throw StateError(
        'Conecta IsselNavigationService.navigatorKey al MaterialApp y espera '
        'a que el Navigator esté montado antes de navegar.',
      );
    }
    return navigator;
  }

  Future<T?> navigateTo<T>(
    Widget page, {
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) =>
      _navigator.push<T>(
        _pageRoute<T>(page, settings, fullscreenDialog),
      );

  /// Admite transiciones y tipos de ruta definidos por la aplicación.
  Future<T?> pushRoute<T>(Route<T> route) => _navigator.push<T>(route);

  /// [result] completa la ruta reemplazada; el Future corresponde a la nueva.
  Future<T?> pushReplacement<T, TO>(
    Widget page, {
    TO? result,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) =>
      _navigator.pushReplacement<T, TO>(
        _pageRoute<T>(page, settings, fullscreenDialog),
        result: result,
      );

  /// Por defecto limpia la pila. [predicate] permite conservar rutas previas.
  Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    RoutePredicate? predicate,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) =>
      _navigator.pushAndRemoveUntil<T>(
        _pageRoute<T>(page, settings, fullscreenDialog),
        predicate ?? (_) => false,
      );

  /// Usa el nombre predeterminado derivado del tipo de widget.
  ///
  /// Si se configuró un nombre propio, utiliza [popUntilRoute]. Si no se
  /// encuentra el destino, conserva la primera ruta de la pila.
  void popUntilWidget(Type widgetType) => popUntilRoute(widgetType.toString());

  void popUntilRoute(String name) {
    _navigator.popUntil(
      (route) => route.isFirst || route.settings.name == name,
    );
  }

  /// Solicita volver respetando PopScope y conservando la ruta raíz.
  ///
  /// Devuelve si la petición fue atendida. Un PopScope que impide salir también
  /// atiende la petición; true no implica que la ruta haya sido retirada.
  Future<bool> goBack<T>([T? result]) {
    final navigator = _navigator;
    if (!navigator.canPop()) return Future<bool>.value(false);
    return navigator.maybePop<T>(result);
  }

  MaterialPageRoute<T> _pageRoute<T>(
    Widget page,
    RouteSettings? settings,
    bool fullscreenDialog,
  ) =>
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: RouteSettings(
          name: settings?.name ?? page.runtimeType.toString(),
          arguments: settings?.arguments,
        ),
        fullscreenDialog: fullscreenDialog,
      );
}
