import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/errorHandling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/dataSource/homeRemoteDataSource.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/homeRepository.dart';

class homeRepositoryImp implements Homerepository
{
  final homeRemoteDataSource HomeRemoteDataSource;
  homeRepositoryImp(this.HomeRemoteDataSource);@override
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories() async {
    try {
      final categories = await HomeRemoteDataSource.getCategories();
      return Right(categories as List<HomeCategoryEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<HomeProductsEntity>>> getProducts(int? categoryId, {required int limit,required int offset})async {
    try {
      final products = await HomeRemoteDataSource.getProducts(categoryId, limit:limit, offset:offset);
      return Right(products as List<HomeProductsEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
  
}