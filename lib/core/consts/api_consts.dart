class ApiConsts {
  static const String baseURL = 'https://api.escuelajs.co/';
  static const String loginEndPoint = 'api/v1/auth/login';
  static const String registerEndPoint = 'api/v1/users';
  static const String profileEndPoint = 'api/v1/auth/profile';
  static const String refreshTokenEndPoint = 'api/v1/auth/refresh-token';
  static const String categoriesEndPoint = 'api/v1/categories';
  static const String productsEndPoint = 'api/v1/products';
  static const int categoriesLimit = 100;
  static const int productsLimit = 20;
  static const int allProductsInitialOffset = 1;
}
