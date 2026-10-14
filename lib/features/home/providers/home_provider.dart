import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../data/home_repository.dart';
import '../models/home_category.dart';
import '../../../core/models/product.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._repository);

  final HomeRepository _repository;
  final List<HomeCategory> categories = [];
  List<Product> products = [];
  HomeStatus status = HomeStatus.initial;
  String? errorMessage;
  int? selectedCategoryId;
  String searchQuery = '';

  Timer? _searchDebounce;
  int _requestId = 0;

  bool get isLoading => status == HomeStatus.loading;

  Future<void> load() async {
    final requestId = ++_requestId;
    status = HomeStatus.loading;
    errorMessage = null;
    notifyListeners();

    final categoriesFuture = _repository.fetchCategories();
    final productsFuture = _repository.fetchProducts(
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
      status = HomeStatus.loaded;
    } on DioException {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = 'Could not connect to the store. Check your connection.';
    } on FormatException catch (error) {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = error.message;
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
    status = HomeStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.fetchProducts(
        categoryId: selectedCategoryId,
        title: searchQuery,
      );
      if (requestId != _requestId) return;
      products = results;
      status = HomeStatus.loaded;
    } on DioException {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = 'Could not connect to the store. Check your connection.';
    } on FormatException catch (error) {
      if (requestId != _requestId) return;
      status = HomeStatus.error;
      errorMessage = error.message;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
