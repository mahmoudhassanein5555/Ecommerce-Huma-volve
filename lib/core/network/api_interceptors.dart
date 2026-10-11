import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/network/secure_storage_helper.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageHelper.instance.getAccessToken();
    final isPublicEndpoint =
        options.path.endsWith('auth/login') || options.path.endsWith('users');

    if (!isPublicEndpoint && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
