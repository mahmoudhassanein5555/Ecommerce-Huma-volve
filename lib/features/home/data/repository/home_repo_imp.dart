import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_catagory_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repositry.dart';

class HomeRepoImp implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepoImp(this.homeRemoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      return Right(categories);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts([int? categoryId]) async {
    try {
      final products = await homeRemoteDataSource.getProducts(categoryId);
      return Right(products);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}