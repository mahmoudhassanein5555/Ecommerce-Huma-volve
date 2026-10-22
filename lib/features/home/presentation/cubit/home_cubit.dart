import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dummy_data.dart' show Product;
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_by_category_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import 'home_state.dart';

const String kAllCategoryLabel = 'All';


const List<String> _defaultSizes = ['One Size'];

const String _fallbackImageUrl =
    'https://via.placeholder.com/300x300.png?text=No+Image';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetProductsUseCase getProductsUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
       super(const HomeInitial());

  final GetProductsUseCase _getProductsUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  /// category name -> id, learned from whatever products have been fetched.
  Map<String, int> _categoryIds = {};
  List<ProductEntity> _cachedAllProducts = [];
  bool _isFetching = false;

  String get _currentSelectedCategory => switch (state) {
    HomeLoaded(:final selectedCategory) => selectedCategory,
    HomeEmpty(:final selectedCategory) => selectedCategory,
    HomeError(:final selectedCategory) => selectedCategory,
    _ => kAllCategoryLabel,
  };

  Future<void> loadHome() => _fetchAndEmit(kAllCategoryLabel);

  Future<void> selectCategory(String category) {
    if (_currentSelectedCategory == category) return Future.value();
    return _fetchAndEmit(category);
  }


  Future<void> refresh() =>
      _fetchAndEmit(_currentSelectedCategory, forceRefresh: true);

  Future<void> _fetchAndEmit(
    String category, {
    bool forceRefresh = false,
  }) async {
    if (_isFetching) return;
    _isFetching = true;
    emit(const HomeLoading());
    try {
      final products = await _fetchProducts(
        category,
        forceRefresh: forceRefresh,
      );
      _emitResult(products, category);
    } on AppException catch (e) {
      emit(
        HomeError(
          message: e.message,
          categories: _categoriesWithAll(),
          selectedCategory: category,
        ),
      );
    } catch (_) {
      emit(
        HomeError(
          message: 'Something went wrong. Please try again.',
          categories: _categoriesWithAll(),
          selectedCategory: category,
        ),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<List<ProductEntity>> _fetchProducts(
    String category, {
    required bool forceRefresh,
  }) async {
    if (category == kAllCategoryLabel) {
      if (!forceRefresh && _cachedAllProducts.isNotEmpty) {
        return _cachedAllProducts;
      }
      final products = await _getProductsUseCase();
      _cachedAllProducts = products;
      _categoryIds = _buildCategoryIds(products);
      return products;
    }

    final categoryId = _categoryIds[category];
    if (categoryId == null) return const [];
    return _getProductsByCategoryUseCase(categoryId: categoryId);
  }

  void _emitResult(List<ProductEntity> products, String category) {
    final categories = _categoriesWithAll();
    if (products.isEmpty) {
      emit(HomeEmpty(categories: categories, selectedCategory: category));
    } else {
      emit(
        HomeLoaded(
          products: products.map(_toDisplayProduct).toList(),
          categories: categories,
          selectedCategory: category,
        ),
      );
    }
  }

  List<String> _categoriesWithAll() => [
    kAllCategoryLabel,
    ..._categoryIds.keys,
  ];

  Map<String, int> _buildCategoryIds(List<ProductEntity> products) {
    final map = <String, int>{};
    for (final product in products) {
      map.putIfAbsent(product.category.name, () => product.category.id);
    }
    return map;
  }

  Product _toDisplayProduct(ProductEntity entity) => Product(
    id: entity.id.toString(),
    name: entity.title,
    description: entity.description,
    price: entity.price,
    imageUrl: entity.images.isNotEmpty
        ? entity.images.first
        : _fallbackImageUrl,
    colors: const [AppTheme.primary],
    sizes: _defaultSizes,
  );
}
