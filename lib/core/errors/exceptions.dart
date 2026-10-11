/// Base exception class
class AppException implements Exception {
  final String message;
  final String? code;
  final Map<String, List<String>> fieldErrors;

  AppException(this.message, [this.code, this.fieldErrors = const {}]);

  @override
  String toString() => '$message${code != null ? ' (code: $code)' : ''}';
}

/// Server exception
class ServerException extends AppException {
  ServerException(super.message, [super.code, super.fieldErrors]);
}

/// Network exception
class NetworkException extends AppException {
  NetworkException(super.message, [super.code, super.fieldErrors]);
}

/// Cache exception
class CacheException extends AppException {
  CacheException(super.message, [super.code, super.fieldErrors]);
}

/// Authentication exception
class AuthException extends AppException {
  AuthException(super.message, [super.code, super.fieldErrors]);
}

/// Permission exception
class PermissionException extends AppException {
  PermissionException(super.message, [super.code, super.fieldErrors]);
}

/// Validation exception
class ValidationException extends AppException {
  ValidationException(super.message, [super.code, super.fieldErrors]);
}

/// Location exception
class LocationException extends AppException {
  LocationException(super.message, [super.code, super.fieldErrors]);
}

/// Storage exception
class StorageException extends AppException {
  StorageException(super.message, [super.code, super.fieldErrors]);
}
