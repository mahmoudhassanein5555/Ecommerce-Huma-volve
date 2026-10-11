import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/errors/error_model.dart';
import 'package:ecommerce_app_huma_volve/core/errors/exceptions.dart';

class DioExceptions implements Exception {
  final ErrorModel errModel;

  DioExceptions({required this.errModel});

  String get message => errModel.message;
  String? get code => errModel.code;
  int get statusCode => errModel.statusCode;
  Map<String, List<String>> get fieldErrors => errModel.fieldErrors;

  @override
  String toString() => errModel.message;
}

/// Helper function to parse error response (handles both String and Map responses)
ErrorModel parseErrorResponse(dynamic data, int statusCode) {
  // If data is null or empty
  if (data == null) {
    return ErrorModel(
      statusCode: statusCode,
      message: getDefaultErrorMessage(statusCode),
      generalErrors: [getDefaultErrorMessage(statusCode)],
    );
  }

  // If data is a String
  if (data is String) {
    return ErrorModel(
      statusCode: statusCode,
      message: data.isEmpty ? getDefaultErrorMessage(statusCode) : data,
      generalErrors: [data.isEmpty ? getDefaultErrorMessage(statusCode) : data],
    );
  }

  // If data is a Map
  if (data is Map<String, dynamic>) {
    return ErrorModel.fromJson(data);
  }

  // Fallback for unexpected types
  return ErrorModel(
    statusCode: statusCode,
    message: getDefaultErrorMessage(statusCode),
    generalErrors: [getDefaultErrorMessage(statusCode)],
  );
}

/// Get default error message based on status code
String getDefaultErrorMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request. Please check your input.';
    case 401:
      return 'Unauthorized. Please login again.';
    case 403:
      return 'Access forbidden.';
    case 404:
      return 'Resource not found.';
    case 409:
      return 'Conflict occurred.';
    case 429:
      return 'Too many attempts. Please wait and try again.';
    case 422:
      return 'Unprocessable entity.';
    case 500:
      return 'Internal server error.';
    case 504:
      return 'Server timeout.';
    default:
      return 'An error occurred. Please try again.';
  }
}

void handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw NetworkException(
        'Connection timeout. Please check your internet connection.',
      );

    case DioExceptionType.sendTimeout:
      throw NetworkException('Send timeout. Please try again.');

    case DioExceptionType.receiveTimeout:
      throw NetworkException('Receive timeout. Please try again.');

    case DioExceptionType.badCertificate:
      throw ServerException('Bad certificate. Connection is not secure.');

    case DioExceptionType.cancel:
      throw ServerException('Request cancelled.');

    case DioExceptionType.connectionError:
      throw NetworkException(
        'Connection error. Please check your internet connection.',
      );

    case DioExceptionType.unknown:
      final errorModel = parseErrorResponse(
        e.response?.data,
        e.response?.statusCode ?? 0,
      );
      throw ServerException(
        errorModel.errorMessage,
        errorModel.code,
        errorModel.fieldErrors,
      );

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          final errorModel = parseErrorResponse(e.response?.data, 400);
          throw ServerException(
            errorModel.errorMessage,
            errorModel.code ?? '400',
            errorModel.fieldErrors,
          );

        case 401:
          final errorModel = parseErrorResponse(e.response?.data, 401);
          throw AuthException(
            errorModel.errorMessage,
            errorModel.code ?? '401',
            errorModel.fieldErrors,
          );

        case 403:
          final errorModel = parseErrorResponse(e.response?.data, 403);
          throw PermissionException(
            errorModel.errorMessage,
            errorModel.code ?? '403',
            errorModel.fieldErrors,
          );

        case 404:
          final errorModel = parseErrorResponse(e.response?.data, 404);
          throw ServerException(
            errorModel.errorMessage,
            errorModel.code ?? '404',
            errorModel.fieldErrors,
          );

        case 409:
          final errorModel = parseErrorResponse(e.response?.data, 409);
          throw ServerException(
            errorModel.errorMessage,
            errorModel.code ?? '409',
            errorModel.fieldErrors,
          );

        case 422:
          final errorModel = parseErrorResponse(e.response?.data, 422);
          throw ServerException(
            errorModel.errorMessage,
            errorModel.code ?? '422',
            errorModel.fieldErrors,
          );

        case 500:
          final errorModel = parseErrorResponse(e.response?.data, 500);
          throw ServerException(
            errorModel.errorMessage,
            errorModel.code ?? '500',
            errorModel.fieldErrors,
          );

        case 504:
          final errorModel = parseErrorResponse(e.response?.data, 504);
          throw ServerException(
            errorModel.errorMessage,
            errorModel.code ?? '504',
            errorModel.fieldErrors,
          );

        default:
          final errorModel = parseErrorResponse(
            e.response?.data,
            e.response?.statusCode ?? 0,
          );
          throw ServerException(
            errorModel.errorMessage,
            errorModel.code ?? e.response?.statusCode.toString(),
            errorModel.fieldErrors,
          );
      }
    case DioExceptionType.transformTimeout:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}
