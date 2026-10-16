import 'package:dart_either/dart_either.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repo.dart';

class ProductsUseCase {
  final HomeRepo homeRepo;

  ProductsUseCase(this.homeRepo);

  Future<Either<Failure, List<ProductsEntity>>> call(num? categoryId) async {
    return await homeRepo.getProducts(categoryId);
  }
}
