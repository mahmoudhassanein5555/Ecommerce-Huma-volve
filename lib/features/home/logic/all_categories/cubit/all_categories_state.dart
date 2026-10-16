part of 'all_categories_cubit.dart';

@immutable
sealed class AllCategoriesState {}

final class AllCategoriesInitial extends AllCategoriesState {}

final class AllCategoriesLoading extends AllCategoriesState {}

final class AllCategoriesSuccess extends AllCategoriesState {
  final List<Category> categories;

  AllCategoriesSuccess({required this.categories});
}

final class AllCategoriesFail extends AllCategoriesState {
  final String errorMessage;

  AllCategoriesFail({required this.errorMessage});
}
