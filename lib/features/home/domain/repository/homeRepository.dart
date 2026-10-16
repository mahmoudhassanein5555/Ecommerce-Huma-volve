import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_products_entity.dart';

abstract class Homerepository {
   Future <Either<Failure , List<HomeCategoryEntity>>> getCategories();

   Future <Either<Failure, List<HomeProductsEntity>>> getProducts(int? categoryId, {required int limit,required int offset});

}
