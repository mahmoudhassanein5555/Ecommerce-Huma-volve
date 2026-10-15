import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/category_repo.dart';
import 'package:injectable/injectable.dart';

@singleton
class GetCategories {
  final CategoryRepo _categoryRepo;

  GetCategories(this._categoryRepo);

  Future<Either<Failure, List<Category>>> call() {
    return _categoryRepo.getCategories();
  }
}
