import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';

class HomeCategoryUsecase {
  final HomeRepository homeRepository;

  HomeCategoryUsecase(this.homeRepository);

  Future<Either<Failure, List<HomeCategoriesEntity>>> call() async =>
      await homeRepository.getCategories();
}
