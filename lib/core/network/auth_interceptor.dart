import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secureStorageService.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // قراءة الـ Token المحفوظ بأمان
    final token = await SecureStorageService.readSecureData(
      key: SecureStorageService.userTokenKey,
    );

    // إذا كان الـ Token موجوداً، نرفقه في الـ Authorization Header
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix}$token';
    }

    options.headers['Content-Type'] = ApiConstants.contentType;

    super.onRequest(options, handler);
  }
}
