import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Product>>> getAllProducts({
    required int limit,
    required int offset,
  });
  Future<Either<Failure, List<Product>>> getCategoriesProducts({
    required int categoryId,
    required int limit,
    required int offset,
  });
  Future<Either<Failure, List<Category>>> getAllCategories();
}
