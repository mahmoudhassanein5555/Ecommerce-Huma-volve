import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code]);
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, [super.code]);
}

/// Validation failure
class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure(
    String message, {
    String? code,
    this.fieldErrors = const {},
  }) : super(message, code);

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

/// Location failure
class LocationFailure extends Failure {
  const LocationFailure(super.message, [super.code]);
}

/// Storage failure
class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.code]);
}