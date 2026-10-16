import 'package:dio/dio.dart';

import 'failure.dart';

class ErrorHandler {
  static Failure handle(Object exception) {
    if (exception is! DioException) {
      return const Failure(failureMessage: 'Un Expected Error');
    }

    final statusCode = exception.response?.statusCode;
    switch (statusCode) {
      case 401:
        return const Failure(failureMessage: 'Unauthorized');
      case 403:
        return const Failure(failureMessage: 'Forbidden');
      case 404:
        return const Failure(failureMessage: '404 Not Found');
      case 422:
        return const Failure(failureMessage: 'Unprocessable Content');
      case 500:
        return const Failure(failureMessage: 'Internal Server Error');
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return const Failure(failureMessage: 'Deadline');
    }

    final message = '${exception.message ?? ''} ${exception.error ?? ''}';
    if (exception.type == DioExceptionType.connectionError ||
        message.contains('SocketException') ||
        message.contains('HandshakeException') ||
        message.contains('Connection failed')) {
      return const Failure(failureMessage: 'SocketException');
    }

    if (exception.error is FormatException || exception.error is TypeError) {
      return const Failure(failureMessage: 'FormatException');
    }

    if (message.contains('401') ||
        message.contains('Unauthorized') ||
        message.contains('Unauthenticated')) {
      return const Failure(failureMessage: 'Unauthorized');
    }
    if (message.contains('403') || message.contains('Forbidden')) {
      return const Failure(failureMessage: 'Forbidden');
    }
    if (message.contains('404') || message.contains('Not Found')) {
      return const Failure(failureMessage: '404 Not Found');
    }
    if (message.contains('422') || message.contains('Unprocessable Content')) {
      return const Failure(failureMessage: 'Unprocessable Content');
    }
    if (message.contains('500') || message.contains('Internal Server Error')) {
      return const Failure(failureMessage: 'Internal Server Error');
    }
    if (message.contains('Timeout') || message.contains('Deadline')) {
      return const Failure(failureMessage: 'Deadline');
    }

    return const Failure(failureMessage: 'Exception');
  }
}
