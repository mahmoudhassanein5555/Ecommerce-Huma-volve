import 'package:dio/dio.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  final int id;
  final String name;
  final String email;
  final String avatar;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.escuelajs.co/api/v1'));

  String? _accessToken;
  AuthUser? _currentUser;

  String? get accessToken => _accessToken;

  AuthUser? get currentUser => _currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data?['access_token'] as String?;
      if (token == null || token.isEmpty) {
        throw const AuthException('The server did not return an access token.');
      }

      final profileResponse = await _dio.get<Map<String, dynamic>>(
        '/auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final profile = profileResponse.data;
      if (profile == null) {
        throw const AuthException('Could not load your account profile.');
      }

      _accessToken = token;
      _currentUser = AuthUser.fromJson(profile);
      return _currentUser!;
    } on DioException catch (error) {
      throw AuthException(_messageFrom(error));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/users',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': 'customer',
          'avatar':
              'https://api.dicebear.com/9.x/initials/png?seed=${Uri.encodeComponent(name)}',
        },
      );
    } on DioException catch (error) {
      throw AuthException(_messageFrom(error));
    }
  }

  void logout() {
    _accessToken = null;
    _currentUser = null;
  }

  String _messageFrom(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
      if (message is List && message.isNotEmpty) return message.join('\n');
    }
    if (error.response == null) {
      return 'Unable to connect. Check your internet connection and try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
