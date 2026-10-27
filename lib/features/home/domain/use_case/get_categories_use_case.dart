import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/constants/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositry/home_repositry.dart';

class GetCategoriesUseCase {
  final HomeRepository homeRepository;
  
  GetCategoriesUseCase(this.homeRepository);

  Future<Either<Failure, List<HomeCategoryEntity>>> invoke() => homeRepository.getCategories();
}