import 'dart:io';

import 'package:dio/dio.dart';

import '../failure/failure.dart';

class ErrorHandler {
  static Failure handle(Object e) {
    if (e is DioException) return _handleRemoteException(e);

    return UnknownFailure();
  }

  static Failure _handleRemoteException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return NoInternetFailure();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutFailure();
      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response);
      case DioExceptionType.unknown:
        if (e.error is SocketException) return NoInternetFailure();
        return UnknownFailure();
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return UnknownFailure();
    }
  }

  static Failure _handleStatusCode(Response? response) {
    final code = response?.statusCode;

    switch (code) {
      case 401:
      case 403:
        return UnauthorizedFailure();
      case 404:
        return NotFoundFailure();
      default:
        return ServerFailure(statusCode: code);
    }
  }
}
