import 'package:bloc/bloc.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_all_categories.dart';
import 'package:meta/meta.dart';

part 'all_categories_state.dart';

class AllCategoriesCubit extends Cubit<AllCategoriesState> {
  AllCategoriesCubit(this.getAllCategories) : super(AllCategoriesInitial());

  final GetAllCategories getAllCategories;
  
  Future<void> getAllCategoriesMethod() async {
    emit(AllCategoriesLoading());
    final response = await getAllCategories();
    response.fold(
      (failure) {
        emit(AllCategoriesFail(errorMessage: failure.displayMessage));
      },
      (result) async {
        emit(AllCategoriesSuccess(categories: result));
      },
    );
  }
}
