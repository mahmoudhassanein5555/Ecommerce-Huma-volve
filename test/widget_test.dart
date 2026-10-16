// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app_huma_volve/core/models/product.dart';
import 'package:ecommerce_app_huma_volve/core/services/product_api_service.dart';
import 'package:ecommerce_app_huma_volve/features/home/screens/home_screen.dart';
import 'package:ecommerce_app_huma_volve/main.dart';

final testProducts = [
  const Product(
    id: '1',
    name: 'Demo Sneakers',
    description: 'A demo shoe',
    categoryId: '4',
    category: 'Shoes',
    price: 45,
    imageUrl: '',
  ),
  const Product(
    id: '2',
    name: 'Demo Jacket',
    description: 'A demo jacket',
    categoryId: '1',
    category: 'Clothing',
    price: 65,
    imageUrl: '',
  ),
];

class _FakeProductApiService extends ProductApiService {
  _FakeProductApiService() : super();

  @override
  Future<List<Product>> fetchProducts() async => testProducts;

  @override
  Future<Product> fetchProductById(String id) async =>
      testProducts.firstWhere((product) => product.id == id);
}

void main() {
  test('maps product fields returned by the API', () {
    final product = Product.fromJson({
      'id': 12,
      'title': 'API T-shirt',
      'description': 'A product from the API',
      'price': 44,
      'category': {'id': 3, 'name': 'Clothing'},
      'images': ['https://example.com/product.jpg'],
    });

    expect(product.id, '12');
    expect(product.name, 'API T-shirt');
    expect(product.categoryId, '3');
    expect(product.category, 'Clothing');
    expect(product.imageUrl, 'https://example.com/product.jpg');
    expect(product.colors, isEmpty);
    expect(product.sizes, isEmpty);
  });

  testWidgets('opens product details from a deep link', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        initialRoute: 'ecommerce://product/1',
        apiService: _FakeProductApiService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Demo Sneakers'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
  });

  testWidgets('shows not found for an unknown product deep link', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(initialRoute: 'ecommerce://invalid/unknown'),
    );
    await tester.pump();

    expect(find.text('Product not found'), findsOneWidget);
  });

  testWidgets('selecting a category filters the product grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(apiService: _FakeProductApiService())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Demo Sneakers'), findsOneWidget);
    expect(find.text('Demo Jacket'), findsOneWidget);

    await tester.tap(find.text('Clothing'));
    await tester.pumpAndSettle();

    expect(find.text('Demo Jacket'), findsOneWidget);
    expect(find.text('Demo Sneakers'), findsNothing);
  });
}
