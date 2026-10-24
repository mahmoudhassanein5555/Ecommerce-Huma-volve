import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';

import '../models/signup_model.dart';
import '../models/signup_req_model.dart';

class SignupRemoteDataSource {
  final ApiClient apiClient;

  SignupRemoteDataSource(this.apiClient);

  Future<SignupModel> signup({required SignupReqModel signupReqModel}) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        'email': signupReqModel.email,
        'name': signupReqModel.name,
        'password': signupReqModel.password,
        'avatar':
            'https://media.istockphoto.com/id/492460178/photo/fiery-letter-m.jpg?s=612x612&w=0&k=20&c=2V8QA7AHOBo0WYjB-ZVuZ8BqWqVN_3RttCk0wat-oVk=',
      },
    );

    final jsonData = Map<String, dynamic>.from(response.data as Map);

    return SignupModel.fromJson(jsonData);
  }
}
