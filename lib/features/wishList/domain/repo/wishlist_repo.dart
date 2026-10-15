import 'package:dartz/dartz.dart';
import '../../../../core/errors/failer.dart';
import '../../../home/domain/entities/product.dart';

abstract class WishlistRepo {
  Future<Either<Failure, List<Product>>> getWishlist();
  Future<Either<Failure, void>> addToWishlist(Product product);
  Future<Either<Failure, void>> removeFromWishlist(String productId);
  Future<Either<Failure, void>> clearWishlist();
  Future<Either<Failure, bool>> isFavorite(String productId);
}
