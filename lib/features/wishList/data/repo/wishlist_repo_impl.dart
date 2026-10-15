import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failer.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/repo/wishlist_repo.dart';
import '../data_source/local/wishlist_local_data_source.dart';
import '../models/wishlist_product_model.dart';

@Singleton(as: WishlistRepo)
class WishlistRepoImpl implements WishlistRepo {
  final WishlistLocalDataSource _localDataSource;

  WishlistRepoImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<Product>>> getWishlist() async {
    try {
      final items = await _localDataSource.getWishlist();
      return Right(items);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(Product product) async {
    try {
      await _localDataSource.saveProduct(WishlistProductModel.fromEntity(product));
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      await _localDataSource.removeProduct(productId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearWishlist() async {
    try {
      await _localDataSource.clearWishlist();
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String productId) async {
    try {
      final isFav = await _localDataSource.isFavorite(productId);
      return Right(isFav);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
