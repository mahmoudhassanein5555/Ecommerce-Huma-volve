import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';

class ErrorHandel {
  static Failure handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(message: 'Connection timeout. Please try again.');

      case DioExceptionType.sendTimeout:
        return Failure(message: 'Request timeout. Please try again.');

      case DioExceptionType.receiveTimeout:
        return Failure(message: 'Server response timeout. Please try again.');

      case DioExceptionType.connectionError:
        return Failure(message: 'No internet connection.');

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return Failure(message: 'Request was cancelled.');

      case DioExceptionType.badCertificate:
        return Failure(message: 'Secure connection failed.');

      case DioExceptionType.unknown:
        return Failure(message: 'Something went wrong. Please try again.');
      case DioExceptionType.transformTimeout:
        return Failure(message: 'Request timeout. Please try again.');
    }
  }

  static Failure _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return Failure(message: 'Bad request.');

      case 401:
        return Failure(message: 'Unauthorized. Please login again.');

      case 403:
        return Failure(message: 'You do not have permission.');

      case 404:
        return Failure(message: 'The requested resource was not found.');

      case 422:
        return Failure(message: 'Invalid data.');

      case 500:
        return Failure(message: 'Server error. Please try again later.');

      case 503:
        return Failure(message: 'Service unavailable.');

      default:
        return Failure(message: 'Something went wrong.');
    }
  }
}
