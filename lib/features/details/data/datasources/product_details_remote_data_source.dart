import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/models/product_details_model.dart';

class ProductDetailsRemoteDataSource {
  final ApiClient apiClient;

  ProductDetailsRemoteDataSource(this.apiClient);

  Future<ProductDetailsModel> getProductById(int productId) async {
    final response = await apiClient.get('${ApiEndpoints.products}/$productId');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('The product response is invalid.');
    }
    return ProductDetailsModel.fromJson(data);
  }
}
