import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/domain/entities/product.dart';
import '../../../core/failure/error_handler.dart';
import '../domain/entities/home_category.dart';
import '../domain/usecases/get_home_categories.dart';
import '../domain/usecases/get_home_products.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  static const int productsPageSize = 20;

  HomeProvider({
    required this.getHomeProducts,
    required this.getHomeCategories,
  });

  final GetHomeProducts getHomeProducts;
  final GetHomeCategories getHomeCategories;
  final List<HomeCategory> categories = [];
  List<Product> products = [];
  HomeStatus status = HomeStatus.initial;
  String? errorMessage;
  String? paginationErrorMessage;
  int? selectedCategoryId;
  String searchQuery = '';
  bool isLoadingMore = false;
  bool hasMoreProducts = true;

  Timer? _searchDebounce;
  int _requestId = 0;
  int _productsOffset = 0;

  bool get isLoading => status == HomeStatus.loading;

  Future<void> load() async {
    final requestId = ++_requestId;
    _resetPagination();
    status = HomeStatus.loading;
    errorMessage = null;
    notifyListeners();

    final categoriesFuture = getHomeCategories();
    final productsFuture = getHomeProducts(
      categoryId: selectedCategoryId,
      title: searchQuery,
    );

    try {
      await Future.wait<void>([
        categoriesFuture.then<void>((_) {}),
        productsFuture.then<void>((_) {}),
      ]);
      if (requestId != _requestId) return;

      categories
        ..clear()
        ..addAll(await categoriesFuture);
      products = await productsFuture;
      _productsOffset = products.length;
      hasMoreProducts = products.length == productsPageSize;
      status = HomeStatus.loaded;
    } on FormatException catch (error) {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = error.message;
    } on Exception catch (error) {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = ErrorHandler.handle(error).failureMessage;
    }

    notifyListeners();
  }

  Future<void> selectCategory(int? categoryId) async {
    if (selectedCategoryId == categoryId) return;
    _searchDebounce?.cancel();
    selectedCategoryId = categoryId;
    await _fetchProducts();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(_fetchProducts());
    });
  }

  Future<void> _fetchProducts() async {
    final requestId = ++_requestId;
    _resetPagination();
    status = HomeStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await getHomeProducts(
        categoryId: selectedCategoryId,
        title: searchQuery,
        offset: 0,
        limit: productsPageSize,
      );
      if (requestId != _requestId) return;
      products = results;
      _productsOffset = results.length;
      hasMoreProducts = results.length == productsPageSize;
      status = HomeStatus.loaded;
    } on FormatException catch (error) {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = error.message;
    } on Exception catch (error) {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = ErrorHandler.handle(error).failureMessage;
    }

    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (status != HomeStatus.loaded ||
        isLoadingMore ||
        !hasMoreProducts ||
        (_searchDebounce?.isActive ?? false)) {
      return;
    }

    final requestId = _requestId;
    isLoadingMore = true;
    paginationErrorMessage = null;
    notifyListeners();

    try {
      final results = await getHomeProducts(
        categoryId: selectedCategoryId,
        title: searchQuery,
        offset: _productsOffset,
        limit: productsPageSize,
      );
      if (requestId != _requestId) return;
      products.addAll(results);
      _productsOffset += results.length;
      hasMoreProducts = results.length == productsPageSize;
    } on FormatException catch (error) {
      if (requestId != _requestId) return;
      paginationErrorMessage = error.message;
    } on Exception catch (error) {
      if (requestId != _requestId) return;
      paginationErrorMessage = ErrorHandler.handle(error).failureMessage;
    } finally {
      if (requestId == _requestId) {
        isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  void _resetPagination() {
    isLoadingMore = false;
    hasMoreProducts = true;
    paginationErrorMessage = null;
    _productsOffset = 0;
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
