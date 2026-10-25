import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProductsUseCase getProductsUseCase;

  HomeCubit({required this.getProductsUseCase}) : super(HomeInitial());

  int _offset = 0;
  final int _limit = 10; // عدد المنتجات في كل طلب
  List<ProductEntity> _products = [];
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  // جلب المنتجات لأول مرة أو عند إعادة التحميل (Refresh)
  Future<void> getProducts() async {
    if (state is HomeLoading) return;

    emit(HomeLoading());
    _offset = 0;
    _hasMore = true;

    try {
      final newProducts = await getProductsUseCase(
        offset: _offset,
        limit: _limit,
      );
      _products = newProducts;

      if (newProducts.length < _limit) {
        _hasMore = false;
      }

      emit(HomeSuccess(products: List.from(_products), hasMore: _hasMore));
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }

  // جلب المزيد من المنتجات عند النزول لنهاية القائمة
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    try {
      _offset += _limit;
      final moreProducts = await getProductsUseCase(
        offset: _offset,
        limit: _limit,
      );

      if (moreProducts.isEmpty || moreProducts.length < _limit) {
        _hasMore = false;
      }

      _products.addAll(moreProducts);
      _isLoadingMore = false;

      emit(HomeSuccess(products: List.from(_products), hasMore: _hasMore));
    } catch (e) {
      _isLoadingMore = false;
      _offset -= _limit; // التراجع في حالة حدوث خطأ
      emit(HomeSuccess(products: List.from(_products), hasMore: _hasMore));
    }
  }
}
