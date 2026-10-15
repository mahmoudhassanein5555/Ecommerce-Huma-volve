import 'package:ecommerce_app_huma_volve/core/constant/api_EndPoint.dart';
import 'package:ecommerce_app_huma_volve/core/netWork/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/data_source/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/model/login_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/Data/model/sign_up_model.dart';

class AuthRemoteDataSourceIm extends AuthRemoteDataSource {
  ApiClient apiClient;
  AuthRemoteDataSourceIm({required this.apiClient});
  @override
  Future<LoginModel> Login(String email, String password) async {
    final response = await apiClient.dio.post(
      ApiEndPoints.Login,
      data: {"email": email, "password": password},
    );
    Map<String, dynamic> data = response.data;
    LoginModel loginModel = LoginModel.fromJson(data);
    return loginModel;
  }

  @override
  Future<SignUpModel> SingUp(String email, String password, String name) async {
    final Response = await apiClient.dio.post(
      ApiEndPoints.signUp,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'avatar': 'https://reqres.in/img/faces/1-image.jpg',
      },
    );
    Map<String, dynamic> Data = Response.data;
    SignUpModel signUpModel = SignUpModel.fromJson(Data);
    return signUpModel;
  }
}
