import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';

class ErrorHandler {
  static Failure handleException(dynamic exception) => handle(exception);

  static Failure handle(dynamic exception) {
    if (exception is DioException) {
      return _handleDioException(exception);
    } else if (exception is FormatException) {
      return Failure(message: 'Invalid data format received.');
    } else if (exception is TypeError) {
      return Failure(message: 'Data parsing error occurred.');
    } else if (exception is Exception) {
      return Failure(message: exception.toString().replaceFirst('Exception: ', ''));
    } else {
      return Failure(message: 'An unexpected error occurred. Please try again.');
    }
  }

  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(message: 'Connection timeout with the server.');
      case DioExceptionType.sendTimeout:
        return Failure(message: 'Send timeout in connection with the server.');
      case DioExceptionType.receiveTimeout:
        return Failure(message: 'Receive timeout in connection with the server.');
      case DioExceptionType.badCertificate:
        return Failure(message: 'Bad SSL certificate.');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return Failure(message: 'Request to the server was cancelled.');
      case DioExceptionType.connectionError:
        return Failure(message: 'No internet connection. Please check your network.');
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return Failure(message: 'No internet connection. Please check your network.');
        }
        return Failure(message: 'An unexpected network error occurred.');
      default:
        return Failure(message: 'An unexpected network error occurred.');
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return Failure(message: 'No response received from the server.');
    }

    final data = response.data;
    if (data is Map) {
      final serverMessage = data['message'] ?? data['error'] ?? data['detail'] ?? data['msg'];
      if (serverMessage is String && serverMessage.trim().isNotEmpty) {
        return Failure(message: serverMessage);
      } else if (serverMessage is List && serverMessage.isNotEmpty) {
        return Failure(message: serverMessage.join(', '));
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return Failure(message: data);
    }

    switch (response.statusCode) {
      case 400:
        return Failure(message: 'Please check your input');
      case 401:
        return Failure(message: ' Please login again');
      case 403:
        return Failure(message: ' You do not have permission');
      case 404:
        return Failure(message: ' resource was not found');
      case 409:
        return Failure(message: ' Please try again');
      case 500:
        return Failure(message: 'Please try again later');
      case 502:
        return Failure(message: 'The server is temporarily unavailable');
      case 503:
        return Failure(message: 'Please try again later');
      default:
        return Failure(
          message: 'Invalid status code: ${response.statusCode}',
        );
    }
  }
}

typedef ErrorHandeling = ErrorHandler;
