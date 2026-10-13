import '../services/models/category_model.dart';
import '../services/models/product_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoryLoading extends HomeState {}

class CategorySuccess extends HomeState {
  final List<CategoryModel> categories;
  final int selectedIndex;
  CategorySuccess(this.categories, {required this.selectedIndex});
}

class CategoryFailure extends HomeState {
  final String failureMessage;

  CategoryFailure(this.failureMessage);
}

class ProductLoading extends HomeState {}

class ProductSuccess extends HomeState {
  final List<ProductModel> products;
  ProductSuccess(this.products);
}

class ProductFailure extends HomeState {
  final String failureMessage;

  ProductFailure(this.failureMessage);
}
