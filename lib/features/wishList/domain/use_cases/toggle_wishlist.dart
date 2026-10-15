import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failer.dart';
import '../../../home/domain/entities/product.dart';
import '../repo/wishlist_repo.dart';

@singleton
class ToggleWishlist {
  final WishlistRepo _wishlistRepo;

  ToggleWishlist(this._wishlistRepo);

  Future<Either<Failure, bool>> call({
    required Product product,
    required bool isCurrentlyFavorite,
  }) async {
    if (isCurrentlyFavorite) {
      final result = await _wishlistRepo.removeFromWishlist(product.id);
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(false),
      );
    } else {
      final result = await _wishlistRepo.addToWishlist(product);
      return result.fold(
        (failure) => Left(failure),
        (_) => const Right(true),
      );
    }
  }
}
