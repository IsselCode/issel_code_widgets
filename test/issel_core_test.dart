import 'package:flutter_test/flutter_test.dart';
import 'package:issel_code_widgets/issel_core.dart';

void main() {
  test('a repository boundary preserves an integration failure diagnostic',
      () async {
    final cause = StateError('internal connection detail');
    final trace = StackTrace.current;
    final result = await _loadName(() async {
      throw AppException(
        message: 'No fue posible cargar el cliente',
        code: 'connection',
        cause: cause,
        stackTrace: trace,
      );
    });

    expect(result.isSuccess, isFalse);
    final failure = (result as AppError<String>).failure;
    expect(failure.code, 'connection');
    expect(failure.cause, same(cause));
    expect(failure.stackTrace, same(trace));
    expect(
      result.fold(
        onSuccess: (_) => fail('The operation must fail'),
        onError: (failure) => failure.message,
      ),
      'No fue posible cargar el cliente',
    );
    expect(failure.toString(), isNot(contains('internal connection detail')));
  });

  test('successful and nullable values are independent from failure state',
      () async {
    final result = await _loadName(() async => 'Cliente A');
    final nullable = AppResult<String?>.success(null);

    expect(result.isSuccess, isTrue);
    expect(
      result.fold(onSuccess: (name) => name, onError: (_) => 'Error'),
      'Cliente A',
    );
    expect(nullable.isSuccess, isTrue);
    expect(
      nullable.fold(onSuccess: (value) => value, onError: (_) => 'Error'),
      isNull,
    );
  });

  test('unexpected programming errors still propagate to the caller', () async {
    await expectLater(
      _loadName(() async => throw StateError('programming error')),
      throwsStateError,
    );
  });
}

Future<AppResult<String>> _loadName(Future<String> Function() load) async {
  try {
    return AppResult.success(await load());
  } on AppException catch (exception) {
    return AppResult.error(AppFailure.fromException(exception));
  }
}
