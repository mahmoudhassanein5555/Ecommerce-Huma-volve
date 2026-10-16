import 'dart:math';

import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_products_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/useCase/get_Producats_useCase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/useCase/get_categories_useCase.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/viewModel/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeCubit extends Cubit<HomeStates>{
 final getProductsUseCase GetProductsUseCase;
 final getCategoriesUseCase GetCategoriesUseCase;
 final int _limit=10;
 int _offset=0;
 bool _loadingMore=false;
 bool _hasMore=true;
 int? selectedCategory;
 final List<HomeCategoryEntity> _products=[];
 HomeCubit({ required this.GetProductsUseCase, required this.GetCategoriesUseCase}):super(HomeInitial());


  Future <void> LoadHomeDate()  async{
   int categoryId=0;
   emit(CategoriesIsLoading());

  final categoriesResult=await GetCategoriesUseCase.invoke();
  final categories=categoriesResult.fold(
          (failure){emit(CategoriesError(failure.failureMessage)); return null;},
      (categories){emit(CategoriesSuccess(categories));return categories  ;}
          // (categories){categoryId=categories[0].id;emit(CategoriesSuccess(categories));}
  );
if(categories == null|| categories.isEmpty)return;

await getProductByCategoryId(categories.first.id);
  // final products=await GetProductsUseCase.invoke(categoryId,limit:_limit, offset:_offset);
  //  products.fold(
  //       (failure){emit(ProductsError(failure.failureMessage));},
  //       (products){emit(ProductsSuccess(products));},
  //
  //     );
}


  Future <void> getProductByCategoryId(int id)async{

    _hasMore =true;
    _products.clear;
   emit(ProductsIsLoading());

   final result=await GetProductsUseCase.invoke(id,limit: _limit,offset: _offset);
  result.fold(

         (failure){emit(ProductsError(failure.failureMessage));},
         (products){
          _products.addAll(products as Iterable<HomeCategoryEntity>);
           _offset=products.length;
          if(products.length<_limit){
            _hasMore=false;
             selectedCategory=id;               }

           emit(ProductsSuccess(products));},

   );
 }


 Future <void> loadingMoreProducts ()async {
if(_loadingMore|| !_hasMore){
emit(ProductsisLoadingMore());
final result=await GetProductsUseCase.invoke(selectedCategory, limit: _limit, offset: _offset);
result.fold(
    (failure){
      emit(ProductsisLoadingError(errorMessage:failure.failureMessage));
    }
, (newProducts)
{_products.addAll(newProducts as Iterable<HomeCategoryEntity>);
  _offset += newProducts.length;
  if(newProducts.length<_limit){
    _hasMore =false;
  }
  emit(ProductsSuccess(_products.cast<HomeProductsEntity>()));
}
);
}
 }
}

