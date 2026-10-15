import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failer.dart';
import '../../../home/domain/entities/product.dart';
import '../repo/wishlist_repo.dart';

@singleton
class GetWishlist {
  final WishlistRepo _wishlistRepo;

  GetWishlist(this._wishlistRepo);

  Future<Either<Failure, List<Product>>> call() async {
    return await _wishlistRepo.getWishlist();
  }
}
