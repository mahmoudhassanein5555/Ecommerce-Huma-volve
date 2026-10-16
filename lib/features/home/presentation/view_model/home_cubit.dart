import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/home_product_entity.dart';
import '../../domain/use_cases/get_categories_use_case.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  static const int _limit = 10;
  int _offset = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int? _selectedCategoryId;
  int _requestId = 0;
  final List<HomeProductEntity> _products = [];

  HomeCubit({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLodaing());

    final categoriesResult = await getCategoriesUseCase.invoke();
    if (isClosed) return;

    final categories = categoriesResult.fold((failure) {
      emit(CategoriesError(failure.failureMessage));
      return null;
    }, (categories) {
      emit(CategoriesSuccess(categories));
      return categories;
    });

    if (categories == null || categories.isEmpty) return;

    await getProductsByCategoryId(categories.first.id);
  }

  Future<void> getProductsByCategoryId(int id) async {
    final requestId = ++_requestId;
    _selectedCategoryId = id;
    _offset = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _products.clear();
    emit(ProductsLoading());

    final result = await getProductsUseCase.invoke(
      id,
      limit: _limit,
      offset: _offset,
    );
    if (isClosed || requestId != _requestId) return;

    result.fold(
          (failure) => emit(ProductsError(failure.failureMessage)),
          (products) {
        _products.addAll(products);
        _offset = products.length;
        _hasMore = products.length >= _limit;
        emit(ProductsSuccess(List.of(_products)));
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore ||
        !_hasMore ||
        _selectedCategoryId == null ||
        _products.isEmpty) {
      return;
    }

    final requestId = _requestId;
    _isLoadingMore = true;
    emit(ProductsLoadingMore(List.of(_products)));

    final result = await getProductsUseCase.invoke(
      _selectedCategoryId,
      limit: _limit,
      offset: _offset,
    );
    if (isClosed || requestId != _requestId) return;

    _isLoadingMore = false;
    result.fold(
          (failure) => emit(
        ProductsLoadingError(
          products: List.of(_products),
          errorMessage: failure.failureMessage,
        ),
      ),
          (newProducts) {
        _products.addAll(newProducts);
        _offset += newProducts.length;
        _hasMore = newProducts.length >= _limit;
        emit(ProductsSuccess(List.of(_products)));
      },
    );
  }
}