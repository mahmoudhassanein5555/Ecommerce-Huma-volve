// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_app_huma_volve/core/models/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/home_category.dart';
import 'package:ecommerce_app_huma_volve/features/home/providers/home_provider.dart';
import 'package:ecommerce_app_huma_volve/features/home/screens/home_screen.dart';

void main() {
  test('home provider loads products and filters by category', () async {
    final repository = FakeHomeRepository();
    final home = HomeProvider(repository);

    await home.load();

    expect(home.products, hasLength(2));
    expect(home.categories, hasLength(1));

    await home.selectCategory(2);

    expect(repository.requestedCategoryIds.last, 2);
    expect(home.products, hasLength(1));
    expect(home.products.single.name, 'Canvas Shoes');
    home.dispose();
  });

  testWidgets('home screen displays API products and categories', (
    tester,
  ) async {
    final home = HomeProvider(FakeHomeRepository());
    await home.load();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: home,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Canvas Shoes'), findsOneWidget);
    expect(find.text('Clothing'), findsOneWidget);

    await tester.tap(find.text('Clothing'));
    await tester.pumpAndSettle();
    expect(home.selectedCategoryId, 2);

    await tester.ensureVisible(find.text('Canvas Shoes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Canvas Shoes'));
    await tester.pumpAndSettle();
    expect(find.text('Everyday shoes'), findsOneWidget);
    expect(find.text('Select Color'), findsNothing);
    expect(find.text('Select Size'), findsNothing);

    home.dispose();
  });
}

class FakeHomeRepository extends HomeRepository {
  FakeHomeRepository() : super(dio: Dio());

  final requestedCategoryIds = <int?>[];
  final _products = [
    Product(
      id: '1',
      name: 'Canvas Shoes',
      description: 'Everyday shoes',
      price: 45,
      imageUrl: 'https://example.com/shoes.jpg',
      colors: const [],
      sizes: const [],
      categoryId: 2,
      categoryName: 'Clothing',
    ),
    Product(
      id: '2',
      name: 'Leather Bag',
      description: 'A small bag',
      price: 60,
      imageUrl: 'https://example.com/bag.jpg',
      colors: const [],
      sizes: const [],
      categoryId: 3,
      categoryName: 'Accessories',
    ),
  ];

  @override
  Future<List<Product>> fetchProducts({int? categoryId, String? title}) async {
    requestedCategoryIds.add(categoryId);
    return _products
        .where(
          (product) => categoryId == null || product.categoryId == categoryId,
        )
        .toList();
  }

  @override
  Future<List<HomeCategory>> fetchCategories() async {
    return const [HomeCategory(id: 2, name: 'Clothing')];
  }
}
