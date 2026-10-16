import 'package:ecommerce_app_huma_volve/core/constant/api_andpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network%20services/network_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/data_source/login_datasource.dart';
import 'package:ecommerce_app_huma_volve/features/auth/login/data/model/login_model.dart';

class LoginDataSourceImp implements LoginDatasource {
  final NetworkServices networkServices;

  LoginDataSourceImp(this.networkServices);

  @override
  Future<LoginModel> login(String email, String password) async {
    final response = await networkServices.dio.post(
      ApiAndpoints.login,
      data: {'email': email, 'password': password},
    );
    final jsonResponse = response.data;
    final loginModel = LoginModel.fromJson(jsonResponse);
    return loginModel;
  }
}
