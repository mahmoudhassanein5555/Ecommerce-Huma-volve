import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/constants/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/core/errors/error_handiling.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositry/home_repositry.dart';

class HomeRepositoryImp implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepositoryImp({required this.homeRemoteDataSource});
  @override
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories() async{
    try {
      final Category = await homeRemoteDataSource.getCategories();
      return Right(Category as List<HomeCategoryEntity>);
      
    } catch (e) {
      return Left(ErrorHandler.handle(e));
      
    }
    
  }

  @override
  Future<Either<Failure, List<HomeProductEntity>>> getproducts(int? categoryid) async{
    try {
      final products = await homeRemoteDataSource.getproducts(categoryid);
      return Right(products as List<HomeProductEntity>);

      
    } catch (e) {
      return Left(ErrorHandler.handle(e));
      
    }
  }
}
  