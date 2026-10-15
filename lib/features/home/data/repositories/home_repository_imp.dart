import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDatasource homeRemoteDatasource;

  HomeRepositoryImp(this.homeRemoteDatasource);
  @override
  Future<Either<Failure, List<HomeCategoriesEntity>>> getCategories() async {
    try {
      final categories = await homeRemoteDatasource.getCategories();
      return Right(categories as List<HomeCategoriesEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<HomeProductsEntity>>> getProducts(
    int? categoryId, {
    required int limit,
    required int offset,
  }) async {
    try {
      final products = await homeRemoteDatasource.getProducts(
        categoryId,
        limit: limit,
        offset: offset,
      );
      return Right(products as List<HomeProductsEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
