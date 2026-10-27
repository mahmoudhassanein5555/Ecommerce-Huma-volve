import 'package:ecommerce_app_huma_volve/core/network/api_result.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repos/product_details_repo.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/usecases/get_product_details_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeProductDetailsRepo repository;
  late ProductDetailsCubit cubit;

  setUp(() {
    repository = _FakeProductDetailsRepo();
    cubit = ProductDetailsCubit(GetProductDetailsUseCase(repository));
  });

  tearDown(() async {
    await cubit.close();
  });

  test('loads product details by ID', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<ProductDetailsLoading>(),
        isA<ProductDetailsSuccess>().having(
          (state) => state.product.id,
          'product ID',
          42,
        ),
      ]),
    );

    await cubit.loadProduct(42);
    await expectation;

    expect(repository.requestedProductId, 42);
  });

  test(
    'emits failure and does not request when product ID is unavailable',
    () async {
      final expectation = expectLater(
        cubit.stream,
        emits(isA<ProductDetailsFailure>()),
      );

      await cubit.loadProduct(null);
      await expectation;

      expect(repository.requestedProductId, isNull);
    },
  );

  test('emits API failures', () async {
    repository.result = const ApiResult.failure('Product was not found.');
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<ProductDetailsLoading>(),
        isA<ProductDetailsFailure>().having(
          (state) => state.message,
          'message',
          'Product was not found.',
        ),
      ]),
    );

    await cubit.loadProduct(42);
    await expectation;
  });
}

class _FakeProductDetailsRepo implements ProductDetailsRepo {
  int? requestedProductId;

  ApiResult<ProductDetailsEntity> result = const ApiResult.success(
    ProductDetailsEntity(
      id: 42,
      title: 'Canvas Tote',
      price: 24.5,
      description: 'A sturdy everyday tote.',
      images: ['https://example.com/tote.jpg'],
    ),
  );

  @override
  Future<ApiResult<ProductDetailsEntity>> getProductById(int productId) async {
    requestedProductId = productId;
    return result;
  }
}
