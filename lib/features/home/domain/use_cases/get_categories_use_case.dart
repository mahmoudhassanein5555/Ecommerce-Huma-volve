import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';

import '../entities/category_entity.dart';
import '../repositories/home_repo.dart';

class GetCategoriesUseCase {
  final HomeRepo homeRepository;
  GetCategoriesUseCase(this.homeRepository);

  Future<Either<Failure, List<CategoryEntity>>> invoke() =>
      homeRepository.getCategories();
}
