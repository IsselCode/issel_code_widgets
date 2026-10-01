import 'package:flutter/foundation.dart';

/// Base de presentación para observar el ciclo de vida de acciones asíncronas.
///
/// Comprueba [isDisposed] después de esperar una operación y antes de actualizar
/// estado. [notifyIfActive] evita notificaciones tardías; no cancela peticiones.
abstract class IsselController extends ChangeNotifier {
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @protected
  void notifyIfActive() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    super.dispose();
  }
}
