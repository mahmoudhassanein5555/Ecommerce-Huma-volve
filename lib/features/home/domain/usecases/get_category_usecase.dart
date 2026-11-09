import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/category_entity.dart';
import '../repository/home_repository.dart';

class GetCategoryUsecase {
  final HomeRepository _repository;
  GetCategoryUsecase({required this._repository});

  Future<Either<Failure, List<CategoryEntity>>> invoke() {
    return _repository.getCategories();
  }
}
