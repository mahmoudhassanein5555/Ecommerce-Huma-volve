import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Product> items;

  WishlistLoaded(this.items);
}

class WishlistError extends WishlistState {
  final String message;

  WishlistError(this.message);
}
