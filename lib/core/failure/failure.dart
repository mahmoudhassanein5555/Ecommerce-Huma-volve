sealed class Failure {}

class TimeoutFailure extends Failure {}

class NoInternetFailure extends Failure {}

class UnauthorizedFailure extends Failure {}

class NotFoundFailure extends Failure {}

class UnknownFailure extends Failure {}

class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({this.statusCode});
}
