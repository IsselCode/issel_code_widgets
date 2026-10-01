import 'app_failure.dart';

/// Resultado de una operación: contiene un valor o un fallo esperado.
///
/// Permite manejar ambos estados con [fold] o con un switch exhaustivo.
sealed class AppResult<T> {
  const AppResult();

  const factory AppResult.success(T value) = AppSuccess<T>;
  const factory AppResult.error(AppFailure failure) = AppError<T>;

  bool get isSuccess => this is AppSuccess<T>;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppFailure failure) onError,
  }) =>
      switch (this) {
        AppSuccess<T>(:final value) => onSuccess(value),
        AppError<T>(:final failure) => onError(failure),
      };
}

final class AppSuccess<T> extends AppResult<T> {
  const AppSuccess(this.value);

  final T value;
}

final class AppError<T> extends AppResult<T> {
  const AppError(this.failure);

  final AppFailure failure;
}
