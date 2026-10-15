import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/use_cases/clear_wishlist.dart';
import '../../domain/use_cases/get_wishlist.dart';
import '../../domain/use_cases/remove_from_wishlist.dart';
import '../../domain/use_cases/toggle_wishlist.dart';
import 'wishlist_state.dart';

@singleton
class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlist _getWishlist;
  final ToggleWishlist _toggleWishlist;
  final RemoveFromWishlist _removeFromWishlist;
  final ClearWishlist _clearWishlist;

  List<Product> wishlistProducts = [];

  WishlistCubit(
    this._getWishlist,
    this._toggleWishlist,
    this._removeFromWishlist,
    this._clearWishlist,
  ) : super(WishlistInitial()) {
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    emit(WishlistLoading());
    final result = await _getWishlist();
    result.fold(
      (failure) => emit(WishlistError(failure.msg)),
      (items) {
        wishlistProducts = List.from(items);
        emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));
      },
    );
  }

  Future<void> toggleWishlist(Product product) async {
    final currentlyFavorite = isFavorite(product.id);

    if (currentlyFavorite) {
      wishlistProducts.removeWhere((p) => p.id == product.id);
      emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));

      final result = await _toggleWishlist(
        product: product,
        isCurrentlyFavorite: true,
      );

      result.fold(
        (failure) {
          wishlistProducts.add(product);
          emit(WishlistError(failure.msg));
          emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));
        },
        (_) {},
      );
    } else {
      wishlistProducts.add(product);
      emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));

      final result = await _toggleWishlist(
        product: product,
        isCurrentlyFavorite: false,
      );

      result.fold(
        (failure) {
          wishlistProducts.removeWhere((p) => p.id == product.id);
          emit(WishlistError(failure.msg));
          emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));
        },
        (_) {},
      );
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final index = wishlistProducts.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final removedItem = wishlistProducts[index];
    wishlistProducts.removeAt(index);
    emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));

    final result = await _removeFromWishlist(productId);
    result.fold(
      (failure) {
        wishlistProducts.insert(index, removedItem);
        emit(WishlistError(failure.msg));
        emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));
      },
      (_) {},
    );
  }

  Future<void> clearWishlist() async {
    final previous = List<Product>.from(wishlistProducts);
    wishlistProducts.clear();
    emit(WishlistLoaded(const []));

    final result = await _clearWishlist();
    result.fold(
      (failure) {
        wishlistProducts = previous;
        emit(WishlistError(failure.msg));
        emit(WishlistLoaded(List.unmodifiable(wishlistProducts)));
      },
      (_) {},
    );
  }

  bool isFavorite(String productId) =>
      wishlistProducts.any((p) => p.id == productId);
}
