class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Thrown by a "fetch by id" call when the server reports the entity
/// doesn't exist, so callers can show a dedicated "not found" state instead
/// of a generic error.
class ProductNotFoundException extends AppException {
  const ProductNotFoundException()
    : super('This product could not be found.', statusCode: 404);
}
