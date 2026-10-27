import 'dart:async';
import 'dart:io';

import 'package:ecommerce_app_huma_volve/core/error/app_exception.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/details/screens/product_details_loader_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_product_by_id_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// A 1x1 transparent PNG, served by [_FakeHttpOverrides] for any request so
// the real Product Details screen's `Image.network` resolves instead of
// hitting the network (TestWidgetsFlutterBinding blocks real HTTP anyway).
final List<int> _onePixelPng = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

class _FakeHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();

  @override
  bool autoUncompress = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();

  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _onePixelPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_onePixelPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHomeRepository implements HomeRepository {
  ProductEntity? productToReturn;
  Object? errorToThrow;

  @override
  Future<ProductEntity> getProductById(int id) async {
    if (errorToThrow != null) throw errorToThrow!;
    return productToReturn!;
  }

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int offset,
  }) => throw UnimplementedError();

  @override
  Future<List<ProductEntity>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) => throw UnimplementedError();
}

ProductEntity _product() => const ProductEntity(
  id: 7,
  title: 'Sneakers',
  description: 'desc',
  price: 59.99,
  images: ['https://example.com/a.jpg'],
  category: CategoryEntity(id: 4, name: 'Shoes'),
);

void main() {
  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  testWidgets(
    'navigating to a product deep link shows the real Product Details screen',
    (tester) async {
      final repository = _FakeHomeRepository()..productToReturn = _product();

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailsLoaderScreen(
            productId: 7,
            cubitBuilder: () => ProductDetailsCubit(
              getProductByIdUseCase: GetProductByIdUseCase(repository),
            ),
          ),
        ),
      );

      // Loading first.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Resolved into the existing Product Details screen with the right data.
      expect(find.text('Sneakers'), findsOneWidget);
      expect(find.text('\$59.99'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets('a missing product shows a not-found message, not a crash', (
    tester,
  ) async {
    final repository = _FakeHomeRepository()
      ..errorToThrow = const ProductNotFoundException();

    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailsLoaderScreen(
          productId: 99999999,
          cubitBuilder: () => ProductDetailsCubit(
            getProductByIdUseCase: GetProductByIdUseCase(repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('This product could not be found.'), findsOneWidget);
  });

  testWidgets('a failed fetch shows an error with a working retry button', (
    tester,
  ) async {
    final repository = _FakeHomeRepository()
      ..errorToThrow = const AppException(
        'Server error. Please try again later.',
      );

    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailsLoaderScreen(
          productId: 7,
          cubitBuilder: () => ProductDetailsCubit(
            getProductByIdUseCase: GetProductByIdUseCase(repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Server error. Please try again later.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    repository
      ..errorToThrow = null
      ..productToReturn = _product();
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Sneakers'), findsOneWidget);
  });
}
