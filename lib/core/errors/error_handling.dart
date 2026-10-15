import 'package:dio/dio.dart';

import '../errors/failure.dart';

class ErrorHandler {
  static Failure handle(dynamic exception) {
    if (exception is DioException) {
      return _handleRemoteError(exception.toString());
    }

    return Failure('Un Expected Error');
  }

  static Failure _handleRemoteError(String message) {
    final errorMessage = message.trim();

    if (errorMessage.contains('401') ||
        errorMessage.contains('Unauthorized') ||
        errorMessage.contains('Unauthenticated')) {
      return Failure("Unauthorized");
    }

    if (errorMessage.contains('403') || errorMessage.contains('Forbidden')) {
      return Failure('Forbidden');
    }

    if (errorMessage.contains('404') || errorMessage.contains('Not Found')) {
      return Failure('404 Not Found');
    }

    if (errorMessage.contains('422') ||
        errorMessage.contains('Unprocessable Content')) {
      return Failure('Unprocessable Content');
    }

    if (errorMessage.contains('500') ||
        errorMessage.contains('Internal Server Error')) {
      return Failure('Internal Server Error');
    }

    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('Connection failed') ||
        errorMessage.contains('HandshakeException')) {
      return Failure('SocketException');
    }

    if (errorMessage.contains('Timeout') || errorMessage.contains('Deadline')) {
      return Failure("Deadline");
    }

    if (errorMessage.contains('TypeError') ||
        errorMessage.contains('FormatException')) {
      return Failure('FormatException');
    }

    if (errorMessage.isNotEmpty &&
        !errorMessage.contains('Exception') &&
        !errorMessage.contains('Error')) {
      return Failure('Exception');
    }

    return Failure('Exception');
  }
}
