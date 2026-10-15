import 'package:ecommerce_app_huma_volve/core/dummy_data.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/data/data_source/local/wishlist_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/data/models/wishlist_product_model.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/data/repo/wishlist_repo_impl.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/domain/use_cases/clear_wishlist.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/domain/use_cases/get_wishlist.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/domain/use_cases/remove_from_wishlist.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/domain/use_cases/toggle_wishlist.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/presentation/cubit/wishlist_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/wishList/presentation/cubit/wishlist_state.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWishlistLocalDataSource implements WishlistLocalDataSource {
  final Map<String, WishlistProductModel> _storage = {};
  bool shouldThrow = false;

  FakeWishlistLocalDataSource([List<Product>? initial]) {
    if (initial != null) {
      for (final p in initial) {
        _storage[p.id] = WishlistProductModel.fromEntity(p);
      }
    }
  }

  @override
  Future<List<WishlistProductModel>> getWishlist() async {
    if (shouldThrow) throw Exception('Storage error');
    return _storage.values.toList();
  }

  @override
  Future<void> saveProduct(WishlistProductModel product) async {
    if (shouldThrow) throw Exception('Storage error');
    _storage[product.id] = product;
  }

  @override
  Future<void> removeProduct(String productId) async {
    if (shouldThrow) throw Exception('Storage error');
    _storage.remove(productId);
  }

  @override
  Future<void> clearWishlist() async {
    if (shouldThrow) throw Exception('Storage error');
    _storage.clear();
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return _storage.containsKey(productId);
  }
}

void main() {
  late FakeWishlistLocalDataSource fakeDataSource;
  late WishlistRepoImpl wishlistRepo;
  late GetWishlist getWishlist;
  late ToggleWishlist toggleWishlist;
  late RemoveFromWishlist removeFromWishlist;
  late ClearWishlist clearWishlist;
  late WishlistCubit wishlistCubit;

  final testProduct = Product(
    id: '99',
    name: 'Test Shoes',
    description: 'Test description',
    price: 49.99,
    images: ['https://example.com/test.jpg'],
  );

  setUp(() {
    fakeDataSource = FakeWishlistLocalDataSource([dummyProducts[1]]);
    wishlistRepo = WishlistRepoImpl(fakeDataSource);
    getWishlist = GetWishlist(wishlistRepo);
    toggleWishlist = ToggleWishlist(wishlistRepo);
    removeFromWishlist = RemoveFromWishlist(wishlistRepo);
    clearWishlist = ClearWishlist(wishlistRepo);

    wishlistCubit = WishlistCubit(
      getWishlist,
      toggleWishlist,
      removeFromWishlist,
      clearWishlist,
    );
  });

  tearDown(() {
    wishlistCubit.close();
  });

  test('loads existing persisted items and emits WishlistLoaded', () async {
    await Future.delayed(Duration.zero);
    expect(wishlistCubit.state is WishlistLoaded, true);
    expect(wishlistCubit.wishlistProducts.isNotEmpty, true);
    expect(wishlistCubit.isFavorite(dummyProducts[1].id), true);
  });

  test('toggleWishlist adds product and emits WishlistLoaded', () async {
    await wishlistCubit.toggleWishlist(testProduct);
    expect(wishlistCubit.state is WishlistLoaded, true);
    expect(wishlistCubit.isFavorite(testProduct.id), true);
    expect(await fakeDataSource.isFavorite(testProduct.id), true);
  });

  test('toggleWishlist removes product and emits WishlistLoaded', () async {
    await wishlistCubit.toggleWishlist(testProduct);
    expect(wishlistCubit.isFavorite(testProduct.id), true);

    await wishlistCubit.toggleWishlist(testProduct);
    expect(wishlistCubit.state is WishlistLoaded, true);
    expect(wishlistCubit.isFavorite(testProduct.id), false);
    expect(await fakeDataSource.isFavorite(testProduct.id), false);
  });

  test('removeFromWishlist removes product from state and storage', () async {
    await wishlistCubit.toggleWishlist(testProduct);
    expect(wishlistCubit.isFavorite(testProduct.id), true);

    await wishlistCubit.removeFromWishlist(testProduct.id);
    expect(wishlistCubit.state is WishlistLoaded, true);
    expect(wishlistCubit.isFavorite(testProduct.id), false);
    expect(await fakeDataSource.isFavorite(testProduct.id), false);
  });

  test('clearWishlist empties state and storage and emits WishlistLoaded',
      () async {
    await wishlistCubit.clearWishlist();
    expect(wishlistCubit.state is WishlistLoaded, true);
    expect(wishlistCubit.wishlistProducts.isEmpty, true);
    expect((wishlistCubit.state as WishlistLoaded).items.isEmpty, true);
    expect((await fakeDataSource.getWishlist()).isEmpty, true);
  });

  test('loadWishlist emits WishlistLoading then WishlistError on failure',
      () async {
    fakeDataSource.shouldThrow = true;
    final errorCubit = WishlistCubit(
      getWishlist,
      toggleWishlist,
      removeFromWishlist,
      clearWishlist,
    );

    await Future.delayed(Duration.zero);
    expect(errorCubit.state is WishlistError, true);
    await errorCubit.close();
  });
}
