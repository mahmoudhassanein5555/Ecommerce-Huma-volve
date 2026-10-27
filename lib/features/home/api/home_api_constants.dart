class HomeApiConstants {
  HomeApiConstants._();

  static const String productsEndpoint = 'products';

  static String categoryProductsEndpoint(int categoryId) =>
      'categories/$categoryId/products';
}
