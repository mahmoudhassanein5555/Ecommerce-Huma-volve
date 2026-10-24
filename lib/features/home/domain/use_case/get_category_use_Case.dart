import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';

import '../../../../core/failure/failures.dart';

class GetCategoryUseCase {
  final HomeRepository homeRepository;

  GetCategoryUseCase(this.homeRepository);

  Future<Either<Failures, List<HomeCategoryEntity>>> invoke() =>
      homeRepository.getCategoryList();
}
