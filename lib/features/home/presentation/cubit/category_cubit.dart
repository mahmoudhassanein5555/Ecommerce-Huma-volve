import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/category_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class CategoryCubit extends Cubit<CategoryState> {
  final GetCategories _getCategories;

  CategoryCubit(this._getCategories) : super(CategoryInitial()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    final result = await _getCategories();
    result.fold(
      (failure) => emit(CategoryError(failure.msg)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}
