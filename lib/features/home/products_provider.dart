import 'package:flutter/foundation.dart';

import '../../../core/services/api_service.dart';
import 'data/repositories/products_repository_impl.dart';
import 'domain/usecases/get_products_usecase.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider({GetProductsUseCase? getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase ??
            GetProductsUseCase(
              ProductsRepositoryImpl(ApiService()),
            );

  final GetProductsUseCase _getProductsUseCase;

  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _getProductsUseCase();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      debugPrint('FETCH PRODUCTS ERROR: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
