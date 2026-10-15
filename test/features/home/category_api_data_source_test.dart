import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/remote/category_api_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('requests categories and parses the API response', () async {
    final adapter = _CategoryResponseAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..httpClientAdapter = adapter;

    final categories = await CategoryApiDataSource(dio).getCategories();

    expect(adapter.requestedPath, 'api/v1/categories');
    expect(adapter.queryParameters, {'limit': 100});
    expect(categories, hasLength(1));
    expect(categories.single.id, 1);
    expect(categories.single.name, 'Clothes');
    expect(categories.single.image, 'https://img.test/1');
  });
}

class _CategoryResponseAdapter implements HttpClientAdapter {
  String? requestedPath;
  Map<String, dynamic>? queryParameters;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedPath = options.path;
    queryParameters = options.queryParameters;
    return ResponseBody.fromString(
      jsonEncode([
        {'id': 1, 'name': 'Clothes', 'image': 'https://img.test/1'},
      ]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
