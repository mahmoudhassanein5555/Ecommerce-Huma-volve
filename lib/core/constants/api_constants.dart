/// Backend configuration — Platzi Fake Store API.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1/';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// The API requires an avatar URL on sign up; used until the user picks one.
  static const String defaultAvatar = 'https://i.imgur.com/LDOO4Qs.jpg';
}

class ApiEndpoints {
  ApiEndpoints._();

  static const String login = 'auth/login';
  static const String profile = 'auth/profile';
  static const String signUp = 'users';
}
