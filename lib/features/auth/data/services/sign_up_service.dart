import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/sign_up_request.dart';
import '../models/sign_up_response.dart';

class SignUpService {
  SignUpService(this._apiClient);

  final ApiClient _apiClient;

  Future<SignUpResponse> signUp({required SignUpRequest body}) async {
    final response = await _apiClient.post(
      ApiEndpoints.users,
      data: body.toJson(),
    );
    return SignUpResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
