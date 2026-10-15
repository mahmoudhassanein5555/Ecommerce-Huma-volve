import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/product_repo.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/product_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/product_states.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'paginates all products and resets offset for a selected category',
    () async {
      final repository = _RecordingProductRepo();
      final cubit = ProductCubit(GetProducts(repository));

      await cubit.loadProducts();
      await cubit.loadMore();
      await cubit.loadProducts(categoryId: 7);
      await cubit.loadMore();

      expect(repository.requests, [
        (categoryId: null, offset: ApiConsts.allProductsInitialOffset),
        (categoryId: null, offset: ApiConsts.allProductsInitialOffset + 20),
        (categoryId: 7, offset: 0),
        (categoryId: 7, offset: 20),
      ]);
      expect(cubit.state, isA<ProductsLoaded>());
      expect((cubit.state as ProductsLoaded).products, hasLength(40));
      await cubit.close();
    },
  );
}

class _RecordingProductRepo implements ProductRepo {
  final requests = <({int? categoryId, int offset})>[];

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int? categoryId,
    required int offset,
  }) async {
    requests.add((categoryId: categoryId, offset: offset));
    return Right(
      List.generate(
        ApiConsts.productsLimit,
        (index) => Product(
          id: '${offset + index}',
          name: 'Product $index',
          description: '',
          price: 1,
          images: const [],
        ),
      ),
    );
  }
}
