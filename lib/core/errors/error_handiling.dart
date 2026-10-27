import 'package:dio/dio.dart';
import '../constants/failure/failure.dart'; // استخدمي الـ import المباشر الموجود في السطر 3 لديكِ

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
      return Failure(failureMessage: 'Unauthorized');
    }

    if (errorMessage.contains('403') ||
        errorMessage.contains('Forbidden')) {
      return Failure(failureMessage: 'Forbidden');
    }

    if (errorMessage.contains('404') ||
        errorMessage.contains('Not Found')) {
      return Failure(failureMessage: '404 Not Found');
    }

    if (errorMessage.contains('422') ||
        errorMessage.contains('Unprocessable Content')) {
      return Failure(failureMessage: 'Unprocessable Content');
    }
    if (errorMessage.contains('Timeout') || errorMessage.contains('DeadLine')) {
  return const Failure(failureMessage: 'DeadLine');
}

if (errorMessage.contains('TypeError') || errorMessage.contains('FormatException')) {
  return const Failure(failureMessage: 'FormatException');
}

if (errorMessage.isNotEmpty &&
    (errorMessage.contains('Exception') || errorMessage.contains('Error'))) {
  return const Failure(failureMessage: 'Exception');
}

return const Failure(failureMessage: 'Exception');

  }
  
}