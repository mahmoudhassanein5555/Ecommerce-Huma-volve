import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/dummy_data.dart';
import '../data/home_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._repository);

  final HomeRepository _repository;

  List<Product> products = [];
  List<HomeCategory> categories = [];
  String selectedCategory = 'all';
  String searchQuery = '';
  String? errorMessage;
  bool isLoading = false;

  List<Product> get visibleProducts {
    final query = searchQuery.trim().toLowerCase();
    return products
        .where((product) {
          final matchesCategory =
              selectedCategory == 'all' ||
              product.categorySlug == selectedCategory;
          final matchesQuery =
              query.isEmpty ||
              product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query);
          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);
  }

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.loadHome();
      products = result.products;
      categories = result.categories;
    } on DioException catch (error) {
      errorMessage = error.response == null
          ? 'Unable to connect. Check your internet connection and try again.'
          : 'Products could not be loaded. Please try again.';
    } on FormatException catch (error) {
      errorMessage = error.message;
    } catch (_) {
      errorMessage = 'Products could not be loaded. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String slug) {
    selectedCategory = slug;
    notifyListeners();
  }

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }
}
