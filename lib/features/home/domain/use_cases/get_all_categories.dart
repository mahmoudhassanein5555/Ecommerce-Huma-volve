import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';

class GetAllCategories {
  final HomeRepository repository;

  GetAllCategories(this.repository);

  Future<Either<Failure, List<Category>>> call() {
    return repository.getAllCategories();
  }
}
