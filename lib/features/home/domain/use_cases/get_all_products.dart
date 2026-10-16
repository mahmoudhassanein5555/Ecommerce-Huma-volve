import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handler.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';

class GetAllProducts {
  final HomeRepository repository;

  GetAllProducts(this.repository);

  Future<Either<Failure, List<Product>>> call({
    required int limit,
    required int offset,
  }) {
    return repository.getAllProducts(limit: limit, offset: offset);
  }
}
