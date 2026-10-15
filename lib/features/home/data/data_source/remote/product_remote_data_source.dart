import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int? categoryId,
    required int offset,
  });
}
