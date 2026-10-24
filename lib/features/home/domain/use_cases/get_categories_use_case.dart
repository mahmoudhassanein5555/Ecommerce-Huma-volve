import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_catagory_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repositry.dart';

class GetCategoriesUseCase {
  final HomeRepository homeRepository;

  GetCategoriesUseCase(this.homeRepository);

  Future<Either<Failure, List<CategoryEntity>>> invoke() =>
      homeRepository.getCategories();
}