import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/auth_service.dart';
import 'package:ecommerce_app_huma_volve/features/auth/models/auth_tokens.dart';

void main() {
  group('AuthService', () {
    test(
      'sends login credentials and loads profile with bearer token',
      () async {
        final requests = <RequestOptions>[];
        final storage = MemoryAuthTokenStorage();
        final dio = createDio((options) async {
          requests.add(options);
          if (options.path == '/auth/login') {
            expect(options.data, {
              'email': 'user@example.com',
              'password': 'secret',
            });
            return jsonResponse({
              'access_token': 'access-value',
              'refresh_token': 'refresh-value',
            });
          }
          if (options.path == '/auth/profile') {
            expect(options.headers['Authorization'], 'Bearer access-value');
            return jsonResponse({
              'id': 12,
              'email': 'user@example.com',
              'name': 'Test User',
              'avatar': 'https://example.com/avatar.png',
            });
          }
          throw StateError('Unexpected request: ${options.path}');
        });

        final user = await AuthService(
          dio: dio,
          tokenStorage: storage,
        ).login(email: ' user@example.com ', password: 'secret');

        expect(user.id, 12);
        expect(user.email, 'user@example.com');
        expect(storage.tokens?.accessToken, 'access-value');
        expect(requests.map((request) => request.path), [
          '/auth/login',
          '/auth/profile',
        ]);
      },
    );

    test('refreshes once after profile rejects the access token', () async {
      final storage = MemoryAuthTokenStorage(
        tokens: const AuthTokens(
          accessToken: 'expired-access',
          refreshToken: 'valid-refresh',
        ),
      );
      var profileRequests = 0;
      final dio = createDio((options) async {
        if (options.path == '/auth/profile') {
          profileRequests++;
          if (profileRequests == 1) {
            expect(options.headers['Authorization'], 'Bearer expired-access');
            return jsonResponse({'message': 'Unauthorized'}, statusCode: 401);
          }
          expect(options.headers['Authorization'], 'Bearer new-access');
          return jsonResponse({
            'id': 12,
            'email': 'user@example.com',
            'name': 'Test User',
          });
        }
        if (options.path == '/auth/refresh-token') {
          expect(options.data, {'refreshToken': 'valid-refresh'});
          return jsonResponse({
            'access_token': 'new-access',
            'refresh_token': 'new-refresh',
          });
        }
        throw StateError('Unexpected request: ${options.path}');
      });

      final user = await AuthService(
        dio: dio,
        tokenStorage: storage,
      ).getProfile();

      expect(user.email, 'user@example.com');
      expect(profileRequests, 2);
      expect(storage.tokens?.refreshToken, 'new-refresh');
    });

    test('clears stored tokens when the refresh token is rejected', () async {
      final storage = MemoryAuthTokenStorage(
        tokens: const AuthTokens(
          accessToken: 'expired-access',
          refreshToken: 'expired-refresh',
        ),
      );
      final dio = createDio((options) async {
        if (options.path == '/auth/profile') {
          return jsonResponse({'message': 'Unauthorized'}, statusCode: 401);
        }
        if (options.path == '/auth/refresh-token') {
          return jsonResponse({'message': 'Unauthorized'}, statusCode: 401);
        }
        throw StateError('Unexpected request: ${options.path}');
      });

      await expectLater(
        AuthService(dio: dio, tokenStorage: storage).getProfile(),
        throwsA(isA<AuthException>()),
      );

      expect(storage.tokens, isNull);
    });
  });
}

Dio createDio(Future<ResponseBody> Function(RequestOptions) respond) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
  dio.httpClientAdapter = TestHttpClientAdapter(respond);
  return dio;
}

ResponseBody jsonResponse(Map<String, dynamic> body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
}

class TestHttpClientAdapter implements HttpClientAdapter {
  TestHttpClientAdapter(this.respond);

  final Future<ResponseBody> Function(RequestOptions) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

class MemoryAuthTokenStorage implements AuthTokenStorage {
  MemoryAuthTokenStorage({this.tokens});

  AuthTokens? tokens;

  @override
  Future<String?> readAccessToken() async => tokens?.accessToken;

  @override
  Future<String?> readRefreshToken() async => tokens?.refreshToken;

  @override
  Future<void> save(AuthTokens value) async => tokens = value;

  @override
  Future<void> clear() async => tokens = null;
}
