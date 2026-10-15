import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/consts/cached_keys.dart';
import '../../models/wishlist_product_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistProductModel>> getWishlist();
  Future<void> saveProduct(WishlistProductModel product);
  Future<void> removeProduct(String productId);
  Future<void> clearWishlist();
  Future<bool> isFavorite(String productId);
}

@Singleton(as: WishlistLocalDataSource)
class WishlistHiveDataSource implements WishlistLocalDataSource {
  static const String _boxName = CachedKeys.wishlist;

  Future<Box<Map>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Map>(_boxName);
    }
    return await Hive.openBox<Map>(_boxName);
  }

  @override
  Future<List<WishlistProductModel>> getWishlist() async {
    final box = await _getBox();
    return box.values
        .map((raw) => WishlistProductModel.fromMap(raw))
        .toList();
  }

  @override
  Future<void> saveProduct(WishlistProductModel product) async {
    final box = await _getBox();
    await box.put(product.id, product.toMap());
  }

  @override
  Future<void> removeProduct(String productId) async {
    final box = await _getBox();
    await box.delete(productId);
  }

  @override
  Future<void> clearWishlist() async {
    final box = await _getBox();
    await box.clear();
  }

  @override
  Future<bool> isFavorite(String productId) async {
    final box = await _getBox();
    return box.containsKey(productId);
  }
}
