import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';

class ErrorHandling {
  static Failure handleError(dynamic error) {
    // Handle different types of exceptions and return appropriate error messages
    if (error is DioException) {
      return _handleRemoteError(error.toString());
    }
    return Failure('An unexpected error occurred');
  }

  static Failure _handleRemoteError(String message) {
    final errorMessage = message.trim().toLowerCase();
    if (errorMessage.contains('401') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('unauthenticated'))
      return Failure('Unauthorized access. Please check your credentials.');
    else if (errorMessage.contains('404') || errorMessage.contains('not found'))
      return Failure(
        'Resource not found. Please check the URL or resource availability.',
      );
    else if (errorMessage.contains('500') ||
        errorMessage.contains('internal server error'))
      // ignore: curly_braces_in_flow_control_structures
      return Failure('Internal server error. Please try again later.');
    else if (errorMessage.contains('timeout') ||
        errorMessage.contains('timed out'))
      return Failure(
        'Request timed out. Please check your internet connection and try again.',
      );
    else if (errorMessage.contains('network') ||
        errorMessage.contains('socket'))
      return Failure(
        'Network error. Please check your internet connection and try again.',
      );

    return Failure(message);
  }
}
