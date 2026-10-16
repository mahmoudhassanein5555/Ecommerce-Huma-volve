
import 'package:ecommerce_app_huma_volve/core/constant/api_andpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network%20services/network_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/datasource/signup_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/data/model/signup_res_model.dart';

class SignupDataSourceImp implements SignupDataSource {
  final NetworkServices networkServices;

  SignupDataSourceImp(this.networkServices);

  @override
  Future<SignupResModel> signup(SignupReqModel signupReqModel) async {
    final response = await networkServices.dio.post(
      ApiAndpoints.register,
      data: {
        'name': signupReqModel.name,
        'email': signupReqModel.email,
        'password': signupReqModel.password,
        "avatar": "https://www.google.com/imgres?q=rabbit%20cartoon&imgurl=https%3A%2F%2Fpng.pngtree.com%2Fpng-vector%2F20240413%2Fourmid%2Fpngtree-cartoon-rabbit-eating-icon-image-png-image_12285856.png&imgrefurl=https%3A%2F%2Fpngtree.com%2Fso%2Frabbit-cartoon-image&docid=-dj1ArcI2b9jbM&tbnid=7ge6RK1evgFGHM&vet=12ahUKEwih3ZH9gL2XAxUN_rsIHYZ_KKkQnPAOegQIORAA..i&w=360&h=360&hcb=2&ved=2ahUKEwih3ZH9gL2XAxUN_rsIHYZ_KKkQnPAOegQIORAA",
      },
    );
    final jsonResponse = response.data;
    final signupResModel = SignupResModel.fromJson(jsonResponse);
    return signupResModel;
  }
}