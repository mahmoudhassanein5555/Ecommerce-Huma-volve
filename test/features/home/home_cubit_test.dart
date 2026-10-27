import 'dart:async';

import 'package:ecommerce_app_huma_volve/core/error/app_exception.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_products_by_category_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Slices [allProducts] / [productsByCategoryId] by offset/limit the same
/// way the real escuelajs endpoints do, so tests exercise real pagination
/// behavior instead of a repository that just hands back a flat list.
class _FakeHomeRepository implements HomeRepository {
  List<ProductEntity> allProducts = const [];
  Map<int, List<ProductEntity>> productsByCategoryId = const {};
  Object? errorToThrow;

  int getProductsCallCount = 0;
  int getProductsByCategoryCallCount = 0;
  final List<int> requestedOffsets = [];

  /// When set, a `getProducts` call for this exact offset awaits
  /// [_gate] before returning - used to simulate a slow/in-flight
  /// request that resolves after some other state change happened.
  int? gateOffset;
  Completer<void>? _gate;

  void armGate(int offset) {
    gateOffset = offset;
    _gate = Completer<void>();
  }

  void releaseGate() {
    _gate?.complete();
    gateOffset = null;
    _gate = null;
  }

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int offset,
  }) async {
    getProductsCallCount++;
    requestedOffsets.add(offset);
    if (gateOffset == offset) await _gate!.future;
    if (errorToThrow != null) throw errorToThrow!;
    return _slice(allProducts, offset, limit);
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) async {
    getProductsByCategoryCallCount++;
    if (errorToThrow != null) throw errorToThrow!;
    return _slice(productsByCategoryId[categoryId] ?? const [], offset, limit);
  }

  @override
  Future<ProductEntity> getProductById(int id) {
    throw UnimplementedError('not exercised by HomeCubit tests');
  }

  List<ProductEntity> _slice(
    List<ProductEntity> source,
    int offset,
    int limit,
  ) {
    if (offset >= source.length) return const [];
    final end = (offset + limit) > source.length
        ? source.length
        : offset + limit;
    return source.sublist(offset, end);
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

List<ProductEntity> _generateProducts(
  int count, {
  int startId = 1,
  int categoryId = 1,
  String categoryName = 'Shoes',
}) {
  return List.generate(
    count,
    (i) => _product(
      id: startId + i,
      title: 'Product ${startId + i}',
      categoryId: categoryId,
      categoryName: categoryName,
    ),
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

  group('loadHome (initial page)', () {
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

    test('hasMore is true when a full page is returned', () async {
      repository.allProducts = _generateProducts(kHomePageSize + 5);

      await cubit.loadHome();

      final loaded = cubit.state as HomeLoaded;
      expect(loaded.products, hasLength(kHomePageSize));
      expect(loaded.hasMore, isTrue);
    });

    test('hasMore is false when fewer than a full page is returned', () async {
      repository.allProducts = _generateProducts(kHomePageSize - 5);

      await cubit.loadHome();

      final loaded = cubit.state as HomeLoaded;
      expect(loaded.products, hasLength(kHomePageSize - 5));
      expect(loaded.hasMore, isFalse);
    });
  });

  group('loadNextPage', () {
    test('appends the next page onto the already-loaded items', () async {
      repository.allProducts = _generateProducts(kHomePageSize + 5);
      await cubit.loadHome();

      await cubit.loadNextPage();

      final loaded = cubit.state as HomeLoaded;
      expect(loaded.products, hasLength(kHomePageSize + 5));
      expect(loaded.hasMore, isFalse);
      expect(loaded.isLoadingMore, isFalse);
      expect(loaded.paginationError, isNull);
      // The first page's items must still be present, in order.
      expect(loaded.products.first.name, 'Product 1');
      expect(loaded.products.last.name, 'Product ${kHomePageSize + 5}');
    });

    test('does nothing once hasMore is false (end of list)', () async {
      repository.allProducts = _generateProducts(5);
      await cubit.loadHome();
      final callsBefore = repository.getProductsCallCount;

      await cubit.loadNextPage();

      expect(repository.getProductsCallCount, callsBefore);
      expect((cubit.state as HomeLoaded).products, hasLength(5));
    });

    test(
      'a second concurrent call is ignored while the first is in flight',
      () async {
        repository.allProducts = _generateProducts(kHomePageSize * 3);
        await cubit.loadHome();
        final callsBefore = repository.getProductsCallCount;

        final first = cubit.loadNextPage();
        final second = cubit
            .loadNextPage(); // should see isLoadingMore=true and no-op
        await first;
        await second;

        expect(repository.getProductsCallCount, callsBefore + 1);
        expect(
          (cubit.state as HomeLoaded).products,
          hasLength(kHomePageSize * 2),
        );
      },
    );

    test(
      'a failed page request keeps existing products and sets paginationError',
      () async {
        repository.allProducts = _generateProducts(kHomePageSize + 5);
        await cubit.loadHome();
        repository.errorToThrow = const AppException(
          'Could not reach the server.',
        );

        await cubit.loadNextPage();

        final loaded = cubit.state as HomeLoaded;
        expect(loaded.products, hasLength(kHomePageSize));
        expect(loaded.paginationError, 'Could not reach the server.');
        expect(loaded.isLoadingMore, isFalse);
      },
    );

    test(
      'a retry after a pagination failure succeeds and clears the error',
      () async {
        repository.allProducts = _generateProducts(kHomePageSize + 5);
        await cubit.loadHome();
        repository.errorToThrow = const AppException('boom');
        await cubit.loadNextPage();
        repository.errorToThrow = null;

        await cubit.loadNextPage();

        final loaded = cubit.state as HomeLoaded;
        expect(loaded.products, hasLength(kHomePageSize + 5));
        expect(loaded.paginationError, isNull);
      },
    );

    test('does not duplicate items when a page overlaps the previous one', () async {
      // Simulates the live (mutable) test backend shifting between calls.
      final page1 = _generateProducts(kHomePageSize);
      final overlappingPage2 = _generateProducts(
        10,
        startId: kHomePageSize - 4,
      );
      repository.allProducts = page1;
      await cubit.loadHome();
      // Force hasMore so loadNextPage proceeds, then swap in overlapping data.
      repository.allProducts = [...page1, ...overlappingPage2];

      await cubit.loadNextPage();

      final loaded = cubit.state as HomeLoaded;
      final ids = loaded.products.map((p) => p.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test(
      'a stale response from before a refresh does not corrupt the list',
      () async {
        repository.allProducts = _generateProducts(kHomePageSize + 5);
        await cubit.loadHome();

        repository.armGate(kHomePageSize); // hang the upcoming offset=20 call
        final stale = cubit.loadNextPage();

        repository.allProducts = _generateProducts(3); // backend "changes"
        await cubit.refresh();

        repository.releaseGate();
        await stale;

        final loaded = cubit.state as HomeLoaded;
        expect(loaded.products, hasLength(3));
        expect(loaded.isLoadingMore, isFalse);
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

    test('re-selecting a category restores its cached accumulated pages instead of refetching', () async {
      repository.allProducts = [
        _product(id: 1, categoryId: 4, categoryName: 'Shoes'),
      ];
      repository.productsByCategoryId = {
        4: _generateProducts(kHomePageSize + 3),
      };
      await cubit.loadHome();
      await cubit.selectCategory('Shoes');
      await cubit.loadNextPage(); // Shoes now has 2 pages cached
      final callsAfterPaginating = repository.getProductsByCategoryCallCount;

      await cubit.selectCategory('All');
      await cubit.selectCategory('Shoes');

      expect(repository.getProductsByCategoryCallCount, callsAfterPaginating);
      final loaded = cubit.state as HomeLoaded;
      expect(loaded.products, hasLength(kHomePageSize + 3));
    });

    test('switching category resets the pagination footer state', () async {
      repository.allProducts = _generateProducts(
        kHomePageSize + 3,
        categoryId: 4,
      );
      repository.productsByCategoryId = {
        4: _generateProducts(2, categoryId: 4),
      };
      await cubit.loadHome();
      expect((cubit.state as HomeLoaded).hasMore, isTrue);

      await cubit.selectCategory('Shoes');

      final loaded = cubit.state as HomeLoaded;
      expect(loaded.hasMore, isFalse);
      expect(loaded.isLoadingMore, isFalse);
      expect(loaded.paginationError, isNull);
    });
  });

  group('refresh', () {
    test('re-fetches page 1 of the currently selected category', () async {
      repository.allProducts = [_product(id: 1)];
      await cubit.loadHome();
      expect(repository.getProductsCallCount, 1);

      await cubit.refresh();

      expect(repository.getProductsCallCount, 2);
    });

    test(
      'discards previously paginated extra pages and resets offset',
      () async {
        repository.allProducts = _generateProducts(kHomePageSize * 2);
        await cubit.loadHome();
        await cubit.loadNextPage();
        expect(
          (cubit.state as HomeLoaded).products,
          hasLength(kHomePageSize * 2),
        );
        repository.requestedOffsets.clear();

        await cubit.refresh();

        final loaded = cubit.state as HomeLoaded;
        expect(loaded.products, hasLength(kHomePageSize));
        expect(loaded.hasMore, isTrue);
        // The refresh must have asked for offset 0, not continued from 40.
        expect(repository.requestedOffsets, [0]);

        await cubit.loadNextPage();
        expect(repository.requestedOffsets, [0, kHomePageSize]);
      },
    );
  });
}
