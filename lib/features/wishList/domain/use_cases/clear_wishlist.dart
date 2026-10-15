import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failer.dart';
import '../repo/wishlist_repo.dart';

@singleton
class ClearWishlist {
  final WishlistRepo _wishlistRepo;

  ClearWishlist(this._wishlistRepo);

  Future<Either<Failure, void>> call() async {
    return await _wishlistRepo.clearWishlist();
  }
}
