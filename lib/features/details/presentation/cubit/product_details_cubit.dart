import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../../home/domain/usecases/get_product_by_id_use_case.dart';
import '../../../home/presentation/mappers/product_display_mapper.dart';
import 'product_details_state.dart';

/// Loads a single product by id - the entry point used by deep links, which
/// only carry an id and need to fetch the product themselves rather than
/// receiving one already-loaded from Home's product grid.
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({required GetProductByIdUseCase getProductByIdUseCase})
    : _getProductByIdUseCase = getProductByIdUseCase,
      super(const ProductDetailsInitial());

  final GetProductByIdUseCase _getProductByIdUseCase;
  bool _isFetching = false;

  Future<void> loadProduct(int productId) async {
    if (_isFetching) return;
    _isFetching = true;
    emit(const ProductDetailsLoading());
    try {
      final entity = await _getProductByIdUseCase(productId);
      emit(ProductDetailsLoaded(entity.toDisplayProduct()));
    } on ProductNotFoundException {
      emit(const ProductDetailsNotFound());
    } on AppException catch (e) {
      emit(ProductDetailsError(e.message));
    } catch (_) {
      emit(
        const ProductDetailsError('Something went wrong. Please try again.'),
      );
    } finally {
      _isFetching = false;
    }
  }
}
