import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Single place that turns any thrown error into an [AppException] with a
/// message that is safe to show to the user.
class ErrorHandler {
  ErrorHandler._();

  static AppException handle(Object error) {
    if (error is AppException) return error;
    if (error is DioException) return _fromDio(error);
    return const AppException('Something went wrong. Please try again.');
  }

  static AppException _fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException('Request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const AppException(
            'No internet connection. Please check your network.');
      default:
        break;
    }

    final status = e.response?.statusCode;
    if (status == 401) {
      return const AppException('Incorrect email or password.',
          statusCode: 401);
    }
    if (status != null && status >= 500) {
      return AppException('Server error. Please try again later.',
          statusCode: status);
    }
    return AppException(
      _backendMessage(e.response?.data) ??
          'Something went wrong. Please try again.',
      statusCode: status,
    );
  }

  /// The API returns `message` as a String or a List of validation errors.
  static String? _backendMessage(dynamic data) {
    if (data is! Map) return null;
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
    if (message is List && message.isNotEmpty) {
      return message.map((m) => '• ${_capitalize(m.toString())}').join('\n');
    }
    return null;
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
