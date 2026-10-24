import 'package:dartz/dartz.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/home_repo.dart';
import '../data_sources/home_remote_data_source.dart';

class HomeRepoImp implements HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepoImp(this.homeRemoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      return Right(categories as List<CategoryEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(int? categoryId) async {
    try {
      final products = await homeRemoteDataSource.getProducts(categoryId);
      return Right(products as List<ProductEntity>);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
