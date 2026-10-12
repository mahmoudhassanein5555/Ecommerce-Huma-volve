import 'dart:developer';
import 'package:dio/dio.dart';

class Failure {
  final String? serverMessage; // رسالة السيرفر الجاهزة (لو موجودة)
  final String? localizedKey;  // مفتاح fallback للترجمة

  Failure({this.serverMessage, this.localizedKey});

  // ✅ رسالة العرض لليوزر
  String get displayMessage {
    assert(() {
      if (serverMessage != null) {
        // في debug mode بس
        log("🔍 Server raw error: $serverMessage");
      }
      return true;
    }());
    return serverMessage ?? localizedKey ?? "unexpected_error";
  }
}

class ServerFailure extends Failure {
  ServerFailure({super.serverMessage, super.localizedKey});

  factory ServerFailure.fromDioError(DioException dioError) {
    final response = dioError.response;

    if (response != null) {
      return ServerFailure.fromResponse(response.statusCode, response.data);
    }

    // مفيش response = غالبًا مشكلة إنترنت أو unknown
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(localizedKey: "connection_timeout");
      case DioExceptionType.sendTimeout:
        return ServerFailure(localizedKey: "send_timeout");
      case DioExceptionType.receiveTimeout:
        return ServerFailure(localizedKey: "receive_timeout");
      case DioExceptionType.badCertificate:
        return ServerFailure(localizedKey: "bad_certificate");
      case DioExceptionType.cancel:
        return ServerFailure(localizedKey: "request_cancelled");
      case DioExceptionType.connectionError:
        return ServerFailure(localizedKey: "no_internet");
      case DioExceptionType.unknown:
      default:
        return ServerFailure(localizedKey: "unexpected_error");
    }
  }

factory ServerFailure.fromResponse(
  int? statusCode,
  dynamic response,
) {
  String? serverMessage;

  if (response is Map) {
    final message = response['message'];

    if (message != null) {
      serverMessage = message.toString();
    }
  }

  if (serverMessage != null && serverMessage.isNotEmpty) {
    final lowerMsg = serverMessage.toLowerCase();

    final looksLikeInternalError =
        lowerMsg.contains("sql") ||
        lowerMsg.contains("sqlstate") ||
        lowerMsg.contains("exception") ||
        lowerMsg.contains("stacktrace") ||
        lowerMsg.contains("unknown column") ||
        serverMessage.length > 150;

    if (!looksLikeInternalError) {
      return ServerFailure(
        serverMessage: serverMessage,
      );
    }
  }

  switch (statusCode) {
    case 400:
    case 401:
    case 403:
      return ServerFailure(
        localizedKey: "unauthorized",
      );

    case 404:
      return ServerFailure(
        localizedKey: "not_found",
      );

    case 422:
      return ServerFailure(
        localizedKey: "invalid_data",
      );

    case 500:
      return ServerFailure(
        localizedKey: "server_error",
      );

    default:
      return ServerFailure(
        localizedKey: "unexpected_error",
      );
  }
}

}
