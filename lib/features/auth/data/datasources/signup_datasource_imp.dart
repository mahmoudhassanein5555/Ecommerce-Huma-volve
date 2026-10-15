import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/datasources/signup_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_res_model.dart';

class SignupDatasourceImp implements SignupDatasource {
  final ApiClient apiClient;

  SignupDatasourceImp(this.apiClient);
  @override
  Future<SignupResModel> signup(SignupReqModel signupReqModel) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signup,
      data: {
        "name": signupReqModel.name,
        "email": signupReqModel.email,
        "password": signupReqModel.password,
        "avatar": "https://api.lorem.space/image/face?w=640&h=480",
      },
    );
    return SignupResModel.fromJson(response.data);
  }
}
