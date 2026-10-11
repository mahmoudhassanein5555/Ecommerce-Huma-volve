import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/api_client/api_client.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@module
abstract class RegisterModuls {
  @singleton
  Dio get dio => ApiClient.createDio;

  @singleton
  FlutterSecureStorage get secureStorage => FlutterSecureStorage();
}
