import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/repository/home_repository.dart';

class GetProductUseCase {
  final HomeRepository homeRepository;
  GetProductUseCase(this.homeRepository);

  Future<Either<Failure, List<HomeProductEntity>>> execute(
    int categoryId,
    int offSet,
  ) {
    return homeRepository.getProducts(categoryId, offSet);
  }
}
