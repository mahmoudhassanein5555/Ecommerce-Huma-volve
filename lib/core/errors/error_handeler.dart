import 'package:dio/dio.dart';

import '../failure/failures.dart';

class ErrorHandler {
  static Failures handle(dynamic exception) {
    if (exception is DioException) {
      return _handleRemoteError(exception.toString());
    } else {
      return Failures(errorMessage: exception.toString());
    }
  }

  static Failures _handleRemoteError(String message) {
    final errorMessage = message.trim();
    if (errorMessage.contains("401") ||
        errorMessage.contains("Unauthorized") ||
        errorMessage.contains("Unauthenticated")) {
      return Failures(
        errorMessage: "Your session has expired. Please login again.",
      );
    } else if (errorMessage.contains("403") ||
        errorMessage.contains("Forbidden")) {
      return Failures(
        errorMessage: "You don't have permission to perform this action.",
      );
    } else if (errorMessage.contains("404") ||
        errorMessage.contains("Not Found")) {
      return Failures(errorMessage: "The requested resource was not found.");
    } else if (errorMessage.contains("500") ||
        errorMessage.contains("Internal Server Error")) {
      return Failures(
        errorMessage:
            "Our server is having trouble. Please try again in a few minutes.",
      );
    } else if (errorMessage.isNotEmpty &&
        !errorMessage.contains("400") &&
        !errorMessage.contains("Exception")) {
      return Failures(errorMessage: errorMessage);
    } else if (errorMessage.contains("422") ||
        errorMessage.contains("Unprocessable Content")) {
      return Failures(
        errorMessage: "Invalid information provided. Please check your inputs.",
      );
    } else if (errorMessage.contains("SocketException") ||
        errorMessage.contains("Connection failed") ||
        errorMessage.contains("HandshakeException")) {
      return Failures(
        errorMessage: "No internet connection. Please check your network.",
      );
    } else if (errorMessage.contains("Timeout") ||
        errorMessage.contains("Deadline")) {
      return Failures(
        errorMessage: "Connection timed out. The server is not responding.",
      );
    } else if (errorMessage.contains("TypeError") ||
        errorMessage.contains("FormatException")) {
      return Failures(
        errorMessage: "We encountered a technical issue while processing data.",
      );
    } else {
      return Failures(errorMessage: errorMessage);
    }
  }
}
