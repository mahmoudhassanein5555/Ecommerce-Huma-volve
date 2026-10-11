import 'package:injectable/injectable.dart';

@singleton
abstract class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);

}