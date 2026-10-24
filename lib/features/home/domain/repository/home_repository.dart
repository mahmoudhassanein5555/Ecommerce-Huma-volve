import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failures.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failures, List<HomeCategoryEntity>>> getCategoryList();

  Future<Either<Failures, List<HomeProductEntity>>> getProductByCategoryId(
    int? categoryId,
  );
}
