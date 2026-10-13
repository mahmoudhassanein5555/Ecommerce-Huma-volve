import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows loading followed by products from the API', (
    tester,
  ) async {
    final products = Completer<ResponseBody>();
    final categories = Completer<ResponseBody>();
    final repository = HomeRepository(
      dio: createDio((options) {
        return options.path == '/products'
            ? products.future
            : categories.future;
      }),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    products.complete(
      jsonResponse([
        {
          'id': 4,
          'title': 'Canvas Shoes',
          'description': 'Everyday shoes',
          'price': 49.5,
          'images': ['https://example.com/shoes.png'],
          'category': {'name': 'Shoes'},
        },
      ]),
    );
    categories.complete(jsonResponse([{'name': 'Shoes'}]));
    await tester.pumpAndSettle();

    expect(find.text('Canvas Shoes'), findsOneWidget);
    expect(find.text('Shoes'), findsOneWidget);
  });

  testWidgets('shows an empty state when the API has no products', (
    tester,
  ) async {
    final repository = HomeRepository(
      dio: createDio((options) async => jsonResponse([])),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('No products are available right now.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows an error and retries the API request', (tester) async {
    var shouldFail = true;
    final repository = HomeRepository(
      dio: createDio((options) async {
        if (options.path == '/products' && shouldFail) {
          return jsonResponse({'message': 'Unavailable'}, statusCode: 503);
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
        return jsonResponse([{'name': 'Shoes'}]);
      }),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(find.text('The server is temporarily unavailable.'), findsOneWidget);
    shouldFail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Canvas Shoes'), findsOneWidget);
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
