import '../../../../../core/failure/failure.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoryLoading extends HomeState {}

class CategorySuccess extends HomeState {
  final List<CategoryEntity> categories;
  final int selectedIndex;
  CategorySuccess(this.categories, {required this.selectedIndex});
}

class CategoryFailure extends HomeState {
  final Failure failure;
  CategoryFailure(this.failure);
}

class ProductLoading extends HomeState {}

class ProductSuccess extends HomeState {
  final List<ProductEntity> products;
  ProductSuccess(this.products);
}

class ProductFailure extends HomeState {
  final Failure failure;
  ProductFailure(this.failure);
}
