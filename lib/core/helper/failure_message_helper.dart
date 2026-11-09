import '../constants/failure_messages.dart';
import '../failure/failure.dart';

String failureMessage(Failure f) => switch (f) {
  NoInternetFailure() => FailureMessages.noInternet,
  TimeoutFailure() => FailureMessages.timeout,
  UnauthorizedFailure() => FailureMessages.unauthorized,
  NotFoundFailure() => FailureMessages.notFound,
  ServerFailure() => FailureMessages.server,
  UnknownFailure() => FailureMessages.unknown,
};
