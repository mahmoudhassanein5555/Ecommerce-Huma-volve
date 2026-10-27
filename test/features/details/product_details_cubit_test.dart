import 'package:ecommerce_app_huma_volve/core/error/app_exception.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_product_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRepository implements HomeRepository {
  ProductEntity? productToReturn;
  Object? errorToThrow;
  int getProductByIdCallCount = 0;
  int? lastRequestedId;

  @override
  Future<ProductEntity> getProductById(int id) async {
    getProductByIdCallCount++;
    lastRequestedId = id;
    if (errorToThrow != null) throw errorToThrow!;
    return productToReturn!;
  }

  @override
  Future<List<ProductEntity>> getProducts({
    required int limit,
    required int offset,
  }) => throw UnimplementedError('not exercised by these tests');

  @override
  Future<List<ProductEntity>> getProductsByCategory({
    required int categoryId,
    required int limit,
    required int offset,
  }) => throw UnimplementedError('not exercised by these tests');
}

ProductEntity _product({int id = 1, String title = 'Sneakers'}) {
  return ProductEntity(
    id: id,
    title: title,
    description: 'desc',
    price: 59.99,
    images: const ['https://example.com/a.jpg'],
    category: const CategoryEntity(id: 4, name: 'Shoes'),
  );
}

void main() {
  late _FakeHomeRepository repository;
  late ProductDetailsCubit cubit;

  setUp(() {
    repository = _FakeHomeRepository();
    cubit = ProductDetailsCubit(
      getProductByIdUseCase: GetProductByIdUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  test('initial state is ProductDetailsInitial', () {
    expect(cubit.state, const ProductDetailsInitial());
  });

  test('emits [Loading, Loaded] with the mapped product on success', () async {
    repository.productToReturn = _product(id: 42, title: 'Sneakers');

    final statesFuture = cubit.stream.take(2).toList();
    await cubit.loadProduct(42);
    final states = await statesFuture;

    expect(states[0], const ProductDetailsLoading());
    final loaded = states[1] as ProductDetailsLoaded;
    expect(loaded.product.id, '42');
    expect(loaded.product.name, 'Sneakers');
    expect(repository.lastRequestedId, 42);
  });

  test('emits [Loading, NotFound] on ProductNotFoundException', () async {
    repository.errorToThrow = const ProductNotFoundException();

    final statesFuture = cubit.stream.take(2).toList();
    await cubit.loadProduct(999999);
    final states = await statesFuture;

    expect(states[1], const ProductDetailsNotFound());
  });

  test(
    'emits [Loading, Error] with the message on a generic AppException',
    () async {
      repository.errorToThrow = const AppException(
        'Server error. Please try again later.',
      );

      final statesFuture = cubit.stream.take(2).toList();
      await cubit.loadProduct(1);
      final states = await statesFuture;

      final error = states[1] as ProductDetailsError;
      expect(error.message, 'Server error. Please try again later.');
    },
  );

  test(
    'emits a generic Error message for an unexpected exception type',
    () async {
      repository.errorToThrow = StateError('boom');

      await cubit.loadProduct(1);

      final error = cubit.state as ProductDetailsError;
      expect(error.message, 'Something went wrong. Please try again.');
    },
  );

  test(
    'ignores a concurrent loadProduct call while one is already in flight',
    () async {
      repository.productToReturn = _product();

      final first = cubit.loadProduct(1);
      final second = cubit.loadProduct(2); // should no-op: a fetch is in flight
      await first;
      await second;

      expect(repository.getProductByIdCallCount, 1);
      expect(repository.lastRequestedId, 1);
    },
  );

  test('a retry after failure fetches again and can succeed', () async {
    repository.errorToThrow = const AppException('boom');
    await cubit.loadProduct(5);
    expect(cubit.state, isA<ProductDetailsError>());

    repository.errorToThrow = null;
    repository.productToReturn = _product(id: 5);
    await cubit.loadProduct(5);

    expect(cubit.state, isA<ProductDetailsLoaded>());
    expect(repository.getProductByIdCallCount, 2);
  });
}
