import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/home_category_entity.dart';
import '../../domain/entities/home_product_entity.dart';
import '../../domain/repository/home_repository.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepositoryImp(this.homeRemoteDataSource);
  @override
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      return Right(categories as List<HomeCategoryEntity>);
    } catch (e) {
      return Left(Failure(failureMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HomeProductEntity>>> getProducts(
    int? categoryId,
  ) async {
    try {
      final productes = await homeRemoteDataSource.getProducts(categoryId);
      return Right(productes as List<HomeProductEntity>);
    } catch (e) {
      return Left(Failure(failureMessage: e.toString()));
    }
  }
}
