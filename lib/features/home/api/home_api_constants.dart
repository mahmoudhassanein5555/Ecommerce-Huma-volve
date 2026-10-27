class HomeApiConstants {
  HomeApiConstants._();

  static const String productsEndpoint = 'products';

  static String productByIdEndpoint(int id) => 'products/$id';

  static String categoryProductsEndpoint(int categoryId) =>
      'categories/$categoryId/products';
}
