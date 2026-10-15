import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/Failure/Failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/Domian/repository/home_repository.dart';

class GetCatergoryUseCase {
  final HomeRepository homeRepository;

  GetCatergoryUseCase(this.homeRepository);

  Future<Either<Failure, List<HomeCategoryEntity>>> execute() {
    return homeRepository.getCategories();
  }
}
