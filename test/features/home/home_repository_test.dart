import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repositories/home_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/failures/home_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads and parses products and categories from the API', () async {
    final requestedPaths = <String>[];
    final requestedQueryParameters = <String, dynamic>{};
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
        dio: createDio((options) async {
          requestedPaths.add(options.path);
          if (options.path == '/products') {
            requestedQueryParameters.addAll(options.queryParameters);
          }
          if (options.path == '/products') {
            return jsonResponse([
              {
                'id': 4,
                'title': 'Canvas Shoes',
                'description': 'Everyday shoes',
                'price': 49.5,
                'images': ['https://example.com/shoes.png'],
                'category': {'name': 'Shoes'},
              },
            ]);
          }
          if (options.path == '/categories') {
            return jsonResponse([
              {'id': 1, 'name': 'Shoes'},
            ]);
          }
          throw StateError('Unexpected request: ${options.path}');
        }),
      ),
    );

    final data = await repository.fetchHomeData(limit: 2, offset: 3);

    expect(requestedPaths, containsAll(['/products', '/categories']));
    expect(requestedQueryParameters, {'limit': 2, 'offset': 3});
    expect(data.products.single.name, 'Canvas Shoes');
    expect(data.products.single.category, 'Shoes');
    expect(data.products.single.price, 49.5);
    expect(data.categories.map((category) => category.name), ['Shoes']);
  });

  test('reports invalid API response shapes explicitly', () async {
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
        dio: createDio((options) async {
          if (options.path == '/products') {
            return jsonResponse({'products': []});
          }
          return jsonResponse([]);
        }),
      ),
    );

    await expectLater(
      repository.fetchHomeData(limit: 20, offset: 0),
      throwsA(
        isA<HomeFailure>().having(
          (error) => error.message,
          'message',
          contains('invalid product or category data'),
        ),
      ),
    );
  });
}

Dio createDio(Future<ResponseBody> Function(RequestOptions) respond) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
  dio.httpClientAdapter = TestHttpClientAdapter(respond);
  return dio;
}

ResponseBody jsonResponse(dynamic body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
}

class TestHttpClientAdapter implements HttpClientAdapter {
  TestHttpClientAdapter(this.respond);

  final Future<ResponseBody> Function(RequestOptions) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}
