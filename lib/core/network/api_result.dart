sealed class ApiResult<T> {
  const ApiResult();
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(String errorMessage) = Failure<T>;
  /// create when method handle exceptions
  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Failure<T>(:final errorMessage) => failure(errorMessage),
    };
  }
}
final class Success<T> extends ApiResult<T>{
  final T data;

  const Success(this.data);

}
final class Failure<T> extends ApiResult<T>{
  final String errorMessage;

  const  Failure(this.errorMessage);

}