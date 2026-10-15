import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failer.dart';
import '../repo/wishlist_repo.dart';

@singleton
class RemoveFromWishlist {
  final WishlistRepo _wishlistRepo;

  RemoveFromWishlist(this._wishlistRepo);

  Future<Either<Failure, void>> call(String productId) async {
    return await _wishlistRepo.removeFromWishlist(productId);
  }
}
