import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/entities/product_details_entity.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/usecases/get_product_details_use_case.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsCubit(this.getProductDetailsUseCase)
    : super(ProductDetailsInitial());

  Future<void> loadProduct(int? productId) async {
    if (productId == null) {
      emit(const ProductDetailsFailure('Product ID is unavailable.'));
      return;
    }

    emit(ProductDetailsLoading());
    final result = await getProductDetailsUseCase(productId);
    if (isClosed) return;

    result.when(
      success: (product) => emit(ProductDetailsSuccess(product)),
      failure: (message) => emit(ProductDetailsFailure(message)),
    );
  }
}
