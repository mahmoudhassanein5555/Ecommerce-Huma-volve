import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error/app_exception.dart';
import 'package:ecommerce_app_huma_volve/core/network/dio_exception_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestOptions = RequestOptions(path: 'auth/login');

  group('mapDioException', () {
    test('maps 401 to an invalid credentials message', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
          data: {'message': 'Unauthorized', 'statusCode': 401},
        ),
      );

      final result = mapDioException(exception);

      expect(result.statusCode, 401);
      expect(result.message, 'Invalid email or password.');
    });

    test('maps a 400 with a server message by surfacing it', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 400,
          data: {
            'message': ['email must be an email'],
            'statusCode': 400,
          },
        ),
      );

      final result = mapDioException(exception);

      expect(result.statusCode, 400);
      expect(result.message, 'email must be an email');
    });

    test('maps a 400 whose body is a TypeORM EntityNotFoundError to ProductNotFoundException', () {
      // escuelajs reports a missing entity as a 400, not a 404.
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 400,
          data: {
            'path': '/api/v1/products/99999999',
            'name': 'EntityNotFoundError',
            'message':
                'Could not find any entity of type "Product" matching: {...}',
          },
        ),
      );

      final result = mapDioException(exception);

      expect(result, isA<ProductNotFoundException>());
    });

    test('recognizes EntityNotFoundError purely from the message when "name" is absent', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 400,
          data: {'message': 'Could not find any entity of type "Product"'},
        ),
      );

      final result = mapDioException(exception);

      expect(result, isA<ProductNotFoundException>());
    });

    test('maps a 500 to a generic server error', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: requestOptions, statusCode: 500),
      );

      final result = mapDioException(exception);

      expect(result.statusCode, 500);
      expect(result.message, 'Server error. Please try again later.');
    });

    test('maps connection errors to a no-internet message', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      );

      final result = mapDioException(exception);

      expect(
        result.message,
        'No internet connection. Please check your network and try again.',
      );
    });

    test('maps timeouts to a timeout message', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      final result = mapDioException(exception);

      expect(
        result.message,
        'The request timed out. Please check your connection and try again.',
      );
    });
  });
}
