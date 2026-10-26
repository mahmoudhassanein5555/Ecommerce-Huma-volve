import 'package:ecommerce_app_huma_volve/features/home/service/models/category_model%20.dart';
import 'package:ecommerce_app_huma_volve/features/home/service/models/prodduct_model.dart';

abstract class HomeStates {

}

class Homeinitile extends HomeStates{

}
class CategoriesLoading extends HomeStates{}

class CategoriesSuccess extends HomeStates{
  final List<CategoryModel> Categories;
  CategoriesSuccess(this.Categories);
}
class categoriesError extends HomeStates{
  final String errorMasage;
  categoriesError(this.errorMasage);
}
class productLoading extends HomeStates{}
class productsuccess extends HomeStates{
  final List <ProductModel> products;
  productsuccess(this.products);
}
class productError extends HomeStates{
    final String errorMasage;
    productError(this.errorMasage);

}