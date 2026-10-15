import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/remote/product_api_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('requests all products with the required initial offset', () async {
    final adapter = _ProductResponseAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..httpClientAdapter = adapter;

    final products = await ProductApiDataSource(dio).getProducts(offset: 1);

    expect(adapter.requestedPath, 'api/v1/products');
    expect(adapter.queryParameters, {'limit': 20, 'offset': 1});
    _expectProduct(products.single);
  });

  test('requests products for the selected category and offset', () async {
    final adapter = _ProductResponseAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/'))
      ..httpClientAdapter = adapter;

    final products = await ProductApiDataSource(
      dio,
    ).getProducts(categoryId: 7, offset: 20);

    expect(adapter.requestedPath, 'api/v1/categories/7/products');
    expect(adapter.queryParameters, {'limit': 20, 'offset': 20});
    _expectProduct(products.single);
  });
}

void _expectProduct(Product product) {
  expect(product.id, '12');
  expect(product.name, 'Everyday Shoes');
  expect(product.description, 'Comfortable shoes.');
  expect(product.price, 49.5);
  expect(product.imageUrl, 'https://img.test/product.png');
  expect(
    product.images,
    [
      'https://img.test/product.png',
      'https://img.test/product-back.png',
      'https://img.test/product-detail.png',
    ],
  );
}

class _ProductResponseAdapter implements HttpClientAdapter {
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
        {
          'id': 12,
          'title': 'Everyday Shoes',
          'price': 49.5,
          'description': 'Comfortable shoes.',
          'images': [
            'https://img.test/product.png',
            'https://img.test/product-back.png',
            'https://img.test/product-detail.png',
          ],
          'creationAt': '2026-01-01T00:00:00.000Z',
          'updatedAt': '2026-01-01T00:00:00.000Z',
          'category': {
            'id': 7,
            'name': 'Shoes',
            'image': 'https://img.test/category.png',
          },
        },
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
