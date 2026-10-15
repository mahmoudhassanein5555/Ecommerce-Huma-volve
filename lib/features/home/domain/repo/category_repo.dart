import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';

abstract class CategoryRepo {
  Future<Either<Failure, List<Category>>> getCategories();
}
