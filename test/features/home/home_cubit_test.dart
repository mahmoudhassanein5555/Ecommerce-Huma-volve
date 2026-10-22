import 'package:ecommerce_app_huma_volve/core/error/app_exception.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRepository implements HomeRepository {
  List<ProductEntity> allProducts = const [];
  Map<int, List<ProductEntity>> productsByCategoryId = const {};
  Object? errorToThrow;

  int getProductsCallCount = 0;
  int getProductsByCategoryCallCount = 0;

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int offset,
  }) async {
    getProductsCallCount++;
    if (errorToThrow != null) throw errorToThrow!;
    return allProducts;
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) async {
    getProductsByCategoryCallCount++;
    if (errorToThrow != null) throw errorToThrow!;
    return productsByCategoryId[categoryId] ?? const [];
  }
}

ProductEntity _product({
  required int id,
  String title = 'Product',
  int categoryId = 1,
  String categoryName = 'Shoes',
  List<String> images = const ['https://example.com/a.jpg'],
}) {
  return ProductEntity(
    id: id,
    title: title,
    description: 'desc',
    price: 10.0,
    images: images,
    category: CategoryEntity(id: categoryId, name: categoryName),
  );
}

void main() {
  late _FakeHomeRepository repository;
  late HomeCubit cubit;

  setUp(() {
    repository = _FakeHomeRepository();
    cubit = HomeCubit(
      getProductsUseCase: GetProductsUseCase(repository),
      getProductsByCategoryUseCase: GetProductsByCategoryUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  test('initial state is HomeInitial', () {
    expect(cubit.state, const HomeInitial());
  });

  group('loadHome', () {
    test(
      'emits [Loading, Loaded] with mapped products and derived categories',
      () async {
        repository.allProducts = [
          _product(
            id: 1,
            title: 'Sneakers',
            categoryId: 4,
            categoryName: 'Shoes',
          ),
          _product(
            id: 2,
            title: 'Hoodie',
            categoryId: 1,
            categoryName: 'Clothes',
          ),
        ];

        final statesFuture = cubit.stream.take(2).toList();
        await cubit.loadHome();
        final states = await statesFuture;

        expect(states, hasLength(2));
        expect(states[0], const HomeLoading());
        final loaded = states[1] as HomeLoaded;
        expect(loaded.products.map((p) => p.name), ['Sneakers', 'Hoodie']);
        expect(loaded.categories, ['All', 'Shoes', 'Clothes']);
        expect(loaded.selectedCategory, 'All');
      },
    );

    test('emits [Loading, Empty] when the API returns no products', () async {
      repository.allProducts = const [];

      final statesFuture = cubit.stream.take(2).toList();
      await cubit.loadHome();
      final states = await statesFuture;

      expect(states[1], isA<HomeEmpty>());
    });

    test(
      'emits [Loading, Error] with the AppException message on failure',
      () async {
        repository.errorToThrow = const AppException(
          'Server error. Please try again later.',
        );

        final statesFuture = cubit.stream.take(2).toList();
        await cubit.loadHome();
        final states = await statesFuture;

        final error = states[1] as HomeError;
        expect(error.message, 'Server error. Please try again later.');
      },
    );

    test(
      'a product with no images falls back to a placeholder image',
      () async {
        repository.allProducts = [_product(id: 1, images: const [])];

        await cubit.loadHome();

        final loaded = cubit.state as HomeLoaded;
        expect(loaded.products.single.imageUrl, isNotEmpty);
        expect(loaded.products.single.colors, isNotEmpty);
        expect(loaded.products.single.sizes, isNotEmpty);
      },
    );
  });

  group('selectCategory', () {
    test('filters by the category id learned from the initial load', () async {
      repository.allProducts = [
        _product(
          id: 1,
          title: 'Sneakers',
          categoryId: 4,
          categoryName: 'Shoes',
        ),
      ];
      repository.productsByCategoryId = {
        4: [
          _product(
            id: 1,
            title: 'Sneakers',
            categoryId: 4,
            categoryName: 'Shoes',
          ),
        ],
      };
      await cubit.loadHome();

      await cubit.selectCategory('Shoes');

      final loaded = cubit.state as HomeLoaded;
      expect(loaded.selectedCategory, 'Shoes');
      expect(repository.getProductsByCategoryCallCount, 1);
    });

    test(
      'does nothing when the already-selected category is tapped again',
      () async {
        repository.allProducts = [_product(id: 1)];
        await cubit.loadHome();
        final callsBefore = repository.getProductsCallCount;

        await cubit.selectCategory('All');

        expect(repository.getProductsCallCount, callsBefore);
      },
    );

    test(
      're-selecting "All" reuses the cached list instead of refetching',
      () async {
        repository.allProducts = [
          _product(id: 1, categoryId: 4, categoryName: 'Shoes'),
        ];
        repository.productsByCategoryId = {4: []};
        await cubit.loadHome();
        await cubit.selectCategory('Shoes');
        final callsAfterFilter = repository.getProductsCallCount;

        await cubit.selectCategory('All');

        expect(repository.getProductsCallCount, callsAfterFilter);
        expect(cubit.state, isA<HomeLoaded>());
      },
    );
  });

  group('refresh', () {
    test(
      'bypasses the cache and re-fetches the currently selected category',
      () async {
        repository.allProducts = [_product(id: 1)];
        await cubit.loadHome();
        expect(repository.getProductsCallCount, 1);

        await cubit.refresh();

        expect(repository.getProductsCallCount, 2);
      },
    );
  });
}
