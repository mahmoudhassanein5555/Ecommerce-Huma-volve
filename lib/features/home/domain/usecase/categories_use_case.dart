import 'package:dart_either/src/dart_either.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repo.dart';



class CategoriesUseCase {
  final HomeRepo homeRepo;
  CategoriesUseCase( this.homeRepo);

  Future<Either<Failure, List<CategoriesEntity>>> call() async {
    return await homeRepo.getCategories();
  }
}