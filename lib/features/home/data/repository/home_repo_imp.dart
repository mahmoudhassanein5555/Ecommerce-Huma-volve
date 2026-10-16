import 'package:dart_either/dart_either.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handel.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/datasource/home_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/categories_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repo.dart';

class HomeRepoImp implements HomeRepo {
  final HomeDataSource homeDataSource;

  HomeRepoImp(this.homeDataSource);

  @override
  Future<Either<Failure, List<CategoriesEntity>>> getCategories() async {
    try {
      final categories = await homeDataSource.getCategories();
      return Right(categories);
    } on DioException catch (e) {
      return Left(ErrorHandel.handleError(e));
    } catch (e) {
      return Left(
        Failure(message: "An unexpected error occurred: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductsEntity>>> getProducts(
    num? categoryId, {
    required int limit,
    required int offset,
  }) async {
    try {
      final products = await homeDataSource.getProducts(
        categoryId,
        limit: limit,
        offset: offset,
      );
      return Right(products);
    } on DioException catch (e) {
      return Left(ErrorHandel.handleError(e));
    } catch (e) {
      return Left(
        Failure(message: "An unexpected error occurred: ${e.toString()}"),
      );
    }
  }
}
