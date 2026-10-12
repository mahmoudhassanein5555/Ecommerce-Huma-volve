import 'package:dio/dio.dart';

class ServerFailure {
  final String errorMessage;

  ServerFailure(this.errorMessage);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('انتهت مهلة الاتصال بالسيرفر');
      case DioExceptionType.sendTimeout:
        return ServerFailure('انتهت مهلة إرسال البيانات');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('انتهت مهلة استقبال البيانات من السيرفر');
      case DioExceptionType.badCertificate:
        return ServerFailure('شهادة الأمان غير صالحة');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure('تم إلغاء الطلب');
      case DioExceptionType.connectionError:
        return ServerFailure('لا يوجد اتصال بالإنترنت، تحقق من الشبكة');
      case DioExceptionType.transformTimeout:
        return ServerFailure(
          'استغرق تحويل واستلام البيانات وقتاً أطول من المتوقع',
        );
      case DioExceptionType.unknown:
      default:
        return ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      if (response is Map<String, dynamic> && response.containsKey('message')) {
        return ServerFailure(response['message'].toString());
      }
      return ServerFailure('طلب غير صالح أو غير مصرح به ($statusCode)');
    } else if (statusCode == 404) {
      return ServerFailure('الصفحة أو العنصر المطلوب غير موجود');
    } else if (statusCode == 500) {
      return ServerFailure('حدث خطأ داخلي في السيرفر، حاول لاحقاً');
    } else {
      return ServerFailure('حدث خطأ ما، رمز الخطأ: $statusCode');
    }
  }
}
