
class ApiEndpoints {
  static const String baseUrl =
      'https://api.escuelajs.co/api/v1';

  static const String categories = '$baseUrl/categories';

  static const String products = '$baseUrl/products';

  static String productDetails(int id) => '$products/$id';
}
