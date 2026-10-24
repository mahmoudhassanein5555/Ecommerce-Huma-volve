import 'package:dio/dio.dart';

import '../../failure/failure.dart';

class ErrorHandler {
  static Failure handle(dynamic exception) {
    if (exception is DioException) {
      return _handleRemoteError(exception.toString());
    }

    return Failure(failureMessage: 'Un Expected Error');
  }

  static Failure _handleRemoteError(String message) {
    final errorMessage = message.trim();

    if (errorMessage.contains('401') ||
        errorMessage.contains('Unauthorized') ||
        errorMessage.contains('Unauthenticated')) {
      return const Failure(failureMessage: 'Unauthenticated');
    }

    if (errorMessage.contains('403') || errorMessage.contains('Forbidden')) {
      return const Failure(failureMessage: '');
    }

    if (errorMessage.contains('404') || errorMessage.contains('Not Found')) {}

    if (errorMessage.contains('Unprocessable Content')) {
      return const Failure(failureMessage: 'Unprocessable Content');
    }

    if (errorMessage.contains('500') ||
        errorMessage.contains('Internal Server Error')) {
      return const Failure(failureMessage: 'Internal Server Error');
    }

    if (errorMessage.contains('SocketException') ||
        errorMessage.contains('Connection failed') ||
        errorMessage.contains('HandshakeException')) {
      return const Failure(failureMessage: 'SocketException');
    }

    if (errorMessage.contains('Timeout') || errorMessage.contains('Deadline')) {
      return const Failure(failureMessage: 'Deadline');
    }

    if (errorMessage.contains('TypeError') ||
        errorMessage.contains('FormatException')) {
      return const Failure(failureMessage: 'FormatException');
    }

    if (errorMessage.isNotEmpty &&
        !errorMessage.contains('Exception') &&
        !errorMessage.contains('Error')) {
      return Failure(failureMessage: 'Exception');
    }
    return const Failure(failureMessage: 'Exception');
  }
}
