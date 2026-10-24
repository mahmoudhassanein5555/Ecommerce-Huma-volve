import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import '../../../../core/failure/failure.dart';
import '../repository/home_repository.dart';

class GetProductsUseCase {
  final HomeRepository homeRepository;
  GetProductsUseCase(this.homeRepository);
  Future<Either<Failure,List<HomeProductEntity>>> invoke(int? categoryID)
  =>homeRepository.getProducts(categoryID);
}
