import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/error_handeler.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failures.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  late final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({required this.homeRemoteDataSource});

  @override
  Future<Either<Failures, List<HomeCategoryEntity>>> getCategoryList() async {
    try {
      final categories = await homeRemoteDataSource.getCategoryList();
      return Right(categories as List<HomeCategoryEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failures, List<HomeProductEntity>>> getProductByCategoryId(
    int? categoryId,
  ) async {
    try {
      final products = await homeRemoteDataSource.getProductByCategoryId(
        categoryId,
      );
      return Right(products as List<HomeProductEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
