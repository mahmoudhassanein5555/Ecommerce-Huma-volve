import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/homeRepository.dart';

import '../../../../core/failure/failure.dart';
import '../entity/home_category_entity.dart';
// here in use cases i can make filtration to the data
class getCategoriesUseCase{
  final Homerepository homerepository;
  getCategoriesUseCase(this.homerepository);

  Future <Either<Failure , List<HomeCategoryEntity>>> invoke()=>homerepository.getCategories();
}