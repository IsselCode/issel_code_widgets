/// Excepción técnica que una integración puede convertir en un fallo de app.
///
/// [message] debe ser una descripción segura para mostrar al usuario. [cause]
/// y [stackTrace] conservan el diagnóstico sin tener que exponerlo en la UI.
class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'AppException${code == null ? '' : ' ($code)'}: $message';
}
