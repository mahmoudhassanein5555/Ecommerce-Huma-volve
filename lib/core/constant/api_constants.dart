abstract class ApiConstants {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1/';
  static const String loginEndpoint = 'auth/login';
  static const String registerEndpoint = 'auth/register';
  static const String productsEndpoint = 'products';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String contentType = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
