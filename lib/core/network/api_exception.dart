import 'package:dio/dio.dart';

class DioExceptionMessage implements Exception {
  final String message;

  const DioExceptionMessage(this.message);

  factory DioExceptionMessage.from(Object error) {
    if (error is DioExceptionMessage) {
      return error;
    }
    if (error is DioException) {
      final msg = switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout =>
        'Connection timed out. Please check your internet connection and try again.',
        DioExceptionType.connectionError =>
        'No internet connection. Please check your network settings and try again.',
        DioExceptionType.cancel => 'The request was cancelled.',
        DioExceptionType.badResponse => _badResponse(error.response),
        DioExceptionType.badCertificate =>
        'Security certificate validation failed. Please try again later.',
        DioExceptionType.unknown =>
        error.message?.isNotEmpty == true
            ? error.message!
            : 'An unexpected error occurred. Please try again.',
      };
      return DioExceptionMessage(msg);
    } else if (error is Exception) {
      final msg = error.toString();
      if (msg.startsWith('Exception: ')) {
        return DioExceptionMessage(msg.substring('Exception: '.length));
      }
      return DioExceptionMessage(msg);
    } else {
      return DioExceptionMessage(error.toString());
    }
  }

  @override
  String toString() => message;

  static String _badResponse(Response<dynamic>? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      if (data['status_message'] is String && (data['status_message'] as String).isNotEmpty) {
        return data['status_message'] as String;
      }
      if (data['message'] is String && (data['message'] as String).isNotEmpty) {
        return data['message'] as String;
      }
      if (data['error'] is String && (data['error'] as String).isNotEmpty) {
        return data['error'] as String;
      }
    }

    final statusCode = response?.statusCode;
    if (statusCode == null) {
      return 'Received an invalid response from the server.';
    }

    return switch (statusCode) {
      400 => 'Bad request. Please try again.',
      401 => 'Unauthorized. Please log in again.',
      403 => 'Access denied.',
      404 => 'The requested content was not found.',
      408 => 'Request timed out. Please try again.',
      429 => 'Too many requests. Please try again later.',
      500 || 502 || 503 || 504 => 'Server is temporarily unavailable. Please try again later.',
      _ when statusCode >= 500 => 'Server error ($statusCode). Please try again later.',
      _ when statusCode >= 400 => 'Request error ($statusCode). Please try again.',
      _ => 'An unexpected error ($statusCode) occurred.',
    };
  }
}
