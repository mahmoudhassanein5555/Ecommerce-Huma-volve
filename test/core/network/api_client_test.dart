import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts Dio failures from requests into shared API errors', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );
    final apiClient = ApiClient(dio: dio);

    await expectLater(
      apiClient.get('/products'),
      throwsA(
        isA<DioExceptionMessage>().having(
          (error) => error.message,
          'message',
          'No internet connection. Please check your network settings and try again.',
        ),
      ),
    );
  });
}
