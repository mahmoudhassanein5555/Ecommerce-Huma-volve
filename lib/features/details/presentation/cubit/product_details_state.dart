import 'package:equatable/equatable.dart';

import '../../../../core/dummy_data.dart' show Product;

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {
  const ProductDetailsInitial();
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsLoaded extends ProductDetailsState {
  const ProductDetailsLoaded(this.product);

  final Product product;

  @override
  List<Object?> get props => [product];
}

/// The server confirmed no product exists for the requested id.
class ProductDetailsNotFound extends ProductDetailsState {
  const ProductDetailsNotFound();
}

class ProductDetailsError extends ProductDetailsState {
  const ProductDetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
