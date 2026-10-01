import 'app_exception.dart';

/// Fallo esperado que puede devolverse desde un contrato de repositorio.
///
/// La app define sus códigos y decide cómo presentarlos o registrarlos.
class AppFailure {
  const AppFailure({
    required this.message,
    this.code,
    this.cause,
    this.stackTrace,
  });

  factory AppFailure.fromException(AppException exception) => AppFailure(
        message: exception.message,
        code: exception.code,
        cause: exception.cause,
        stackTrace: exception.stackTrace,
      );

  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppFailure${code == null ? '' : ' ($code)'}: $message';
}
