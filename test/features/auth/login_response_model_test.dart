import 'package:ecommerce_app_huma_volve/core/error/app_exception.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponseModel', () {
    test('parses the escuelajs auth/login success schema', () {
      final model = LoginResponseModel.fromJson({
        'access_token': 'access-123',
        'refresh_token': 'refresh-456',
      });

      final entity = model.toEntity();

      expect(entity.accessToken, 'access-123');
      expect(entity.refreshToken, 'refresh-456');
    });

    test('throws AppException when access_token is missing', () {
      final model = LoginResponseModel.fromJson({
        'refresh_token': 'refresh-456',
      });

      expect(() => model.toEntity(), throwsA(isA<AppException>()));
    });

    test('throws AppException when access_token is empty', () {
      final model = LoginResponseModel.fromJson({
        'access_token': '',
        'refresh_token': 'refresh-456',
      });

      expect(() => model.toEntity(), throwsA(isA<AppException>()));
    });

    test('defaults refresh_token to empty string when absent', () {
      final model = LoginResponseModel.fromJson({'access_token': 'access-123'});

      final entity = model.toEntity();

      expect(entity.refreshToken, '');
    });
  });
}
