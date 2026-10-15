import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handiling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';
import '../../domain/entity/home_category_entity.dart';
import '../../domain/entity/home_product_entity.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepositoryImp(this.homeRemoteDataSource);

  @override
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      return Right(categories as List<HomeCategoryEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<HomeProductEntity>>> getProducts(
      int? categoryId,
      {
        required int limit,
        required int offset,
      }
      ) async {
    try {
      final products = await homeRemoteDataSource.getProducts(categoryId, limit: limit, offset: offset);
      return Right(products as List<HomeProductEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}