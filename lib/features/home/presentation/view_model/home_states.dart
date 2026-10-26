import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/home_product_entity.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}
//* Categories States
class CategoriesLoadingState extends HomeStates {}

class CategoriesSuccessState extends HomeStates {
  final List<HomeCategoryEntity> categories;
  CategoriesSuccessState(this.categories);
}

class CategoriesFailureState extends HomeStates {
  final String errorMessage;
  CategoriesFailureState(this.errorMessage);
}

//* Products States
class ProductsLoadingState extends HomeStates {}

class ProductsSuccessState extends HomeStates {
  final List<HomeProductEntity> products;
  ProductsSuccessState(this.products);
}

class ProductsFailureState extends HomeStates {
  final String errorMessage;
  ProductsFailureState(this.errorMessage);
}


class ProductsLoadingMore extends HomeStates {}
class ProductsLoadingError extends HomeStates {
  final String errorMessage;
  ProductsLoadingError({required this.errorMessage});
}
