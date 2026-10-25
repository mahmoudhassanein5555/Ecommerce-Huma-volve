import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/sign_up_request.dart';
import '../models/sign_up_response.dart';

class SignUpService {
  SignUpService(this._dio);

  final Dio _dio;

  Future<SignUpResponse> signUp({required SignUpRequest body}) async {
    final response = await _dio.post(
      ApiEndpoints.users,
      data: body.toJson(),
    );
    return SignUpResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
