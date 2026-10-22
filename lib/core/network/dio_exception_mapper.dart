import 'package:dio/dio.dart';

import '../error/app_exception.dart';

AppException mapDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const AppException(
        'The request timed out. Please check your connection and try again.',
      );
    case DioExceptionType.connectionError:
      return const AppException(
        'No internet connection. Please check your network and try again.',
      );
    case DioExceptionType.cancel:
      return const AppException('The request was cancelled.');
    case DioExceptionType.badCertificate:
      return const AppException(
        'A secure connection could not be established.',
      );
    case DioExceptionType.badResponse:
      final statusCode = exception.response?.statusCode;
      return AppException(
        _messageForStatus(statusCode, exception.response?.data),
        statusCode: statusCode,
      );
    case DioExceptionType.unknown:
      return const AppException('Something went wrong. Please try again.');
  }
}

String _messageForStatus(int? statusCode, dynamic data) {
  if (statusCode == 401) {
    return 'Invalid email or password.';
  }
  if (statusCode == 400) {
    return _extractServerMessage(data) ??
        'Invalid request. Please check your input and try again.';
  }
  if (statusCode != null && statusCode >= 500) {
    return 'Server error. Please try again later.';
  }
  return _extractServerMessage(data) ??
      'Something went wrong. Please try again.';
}

String? _extractServerMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
    if (message is List && message.isNotEmpty) {
      return message.map((e) => e.toString()).join('\n');
    }
  }
  return null;
}
