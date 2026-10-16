import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repositories/home_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows loading followed by products from the API', (
    tester,
  ) async {
    final products = Completer<ResponseBody>();
    final categories = Completer<ResponseBody>();
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
        dio: createDio((options) {
          return options.path == '/products'
              ? products.future
              : categories.future;
        }),
      ),
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
    categories.complete(
      jsonResponse([
        {'id': 1, 'name': 'Shoes'},
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Canvas Shoes'), findsOneWidget);
    expect(find.text('Shoes'), findsOneWidget);
  });

  testWidgets('shows an empty state when the API has no products', (
    tester,
  ) async {
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
        dio: createDio((options) async => jsonResponse([])),
      ),
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
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
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
          return jsonResponse([
            {'id': 1, 'name': 'Shoes'},
          ]);
        }),
      ),
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

  testWidgets('appends the next batch and stops after the final batch', (
    tester,
  ) async {
    final requestedOffsets = <int>[];
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
        dio: createDio((options) async {
          if (options.path == '/products') {
            final offset = options.queryParameters['offset'] as int;
            requestedOffsets.add(offset);
            return jsonResponse(
              offset == 0
                  ? List.generate(20, (index) => productJson(index + 1))
                  : [productJson(21)],
            );
          }
          return jsonResponse([
            {'id': 1, 'name': 'Shoes'},
          ]);
        }),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Product 20'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Product 20'), findsOneWidget);
    expect(find.text('Product 21'), findsOneWidget);
    expect(requestedOffsets, [0, 20]);
  });

  testWidgets('preserves products and retries a failed next batch', (
    tester,
  ) async {
    var failNextBatch = true;
    final requestedOffsets = <int>[];
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
        dio: createDio((options) async {
          if (options.path == '/products') {
            final offset = options.queryParameters['offset'] as int;
            requestedOffsets.add(offset);
            if (offset == 0) {
              return jsonResponse(
                List.generate(20, (index) => productJson(index + 1)),
              );
            }
            if (failNextBatch) {
              return jsonResponse({'message': 'Unavailable'}, statusCode: 503);
            }
            return jsonResponse([productJson(21)]);
          }
          return jsonResponse([
            {'id': 1, 'name': 'Shoes'},
          ]);
        }),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Product 20'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Product 20'), findsOneWidget);
    expect(find.text('The server is temporarily unavailable.'), findsOneWidget);
    failNextBatch = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Product 20'), findsOneWidget);
    expect(find.text('Product 21'), findsOneWidget);
    expect(requestedOffsets, [0, 20, 20]);
  });

  testWidgets('resets for category changes and ignores stale page requests', (
    tester,
  ) async {
    final stalePage = Completer<ResponseBody>();
    final productRequests = <RequestOptions>[];
    final repository = HomeRepositoryImpl(
      DioHomeRemoteDataSource(
        dio: createDio((options) {
          if (options.path == '/products') {
            productRequests.add(options);
            final offset = options.queryParameters['offset'] as int;
            if (options.queryParameters['categoryId'] == '1') {
              return Future.value(
                jsonResponse([productJson(100, 'Filtered Product')]),
              );
            }
            if (offset == 0) {
              return Future.value(
                jsonResponse(
                  List.generate(20, (index) => productJson(index + 1)),
                ),
              );
            }
            return stalePage.future;
          }
          return Future.value(
            jsonResponse([
              {'id': 1, 'name': 'Shoes'},
            ]),
          );
        }),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(repository: repository)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Product 20'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
    await tester.pump();

    expect(
      productRequests.where(
        (request) => request.queryParameters['offset'] == 20,
      ),
      hasLength(1),
    );

    tester
        .widget<CustomScrollView>(find.byType(CustomScrollView))
        .controller!
        .jumpTo(0);
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Shoes'));
    await tester.pumpAndSettle();
    stalePage.complete(jsonResponse([productJson(101, 'Stale Product')]));
    await tester.pumpAndSettle();

    expect(find.text('Filtered Product'), findsOneWidget);
    expect(find.text('Stale Product'), findsNothing);
    expect(productRequests.last.queryParameters, {
      'limit': 20,
      'offset': 0,
      'categoryId': '1',
    });
  });
}

Map<String, dynamic> productJson(int id, [String? title]) => {
  'id': id,
  'title': title ?? 'Product $id',
  'description': 'Test product',
  'price': 10,
  'images': ['https://example.com/$id.png'],
  'category': {'name': 'Shoes'},
};

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
