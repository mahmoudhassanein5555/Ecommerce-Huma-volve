class ApiEndpoints {
  static const String login = '/auth/login';
  static const String users = '/users';
  static const String categories = '/categories';
  static const String products = '/products';

  static String categoryProducts(int id) => '/categories/$id/products';
}