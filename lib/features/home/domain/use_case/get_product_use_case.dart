import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/constants/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositry/home_repositry.dart';

class GetProductUseCase {
  final HomeRepository homeRepository;
  
  GetProductUseCase(this.homeRepository);

  Future<Either<Failure, List<HomeProductEntity>>> invoke(int categoryId) {
    return homeRepository.getproducts(categoryId);
  }
}