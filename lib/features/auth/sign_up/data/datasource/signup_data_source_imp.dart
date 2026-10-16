
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
        "avatar": "https://www.google.com/imgres?q=photo&imgurl=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fthumbnails%2F055%2F621%2F001%2Fsmall%2Fcloseup-portrait-of-a-young-woman-with-freckles-and-snow-on-her-face-surrounded-by-pine-branches-photo.jpg&imgrefurl=https%3A%2F%2Fwww.vecteezy.com%2Ffree-photos%2Fbeautiful-pic&docid=z4xxRVlB80IVyM&tbnid=Rv6S49eWvBa-nM&vet=12ahUKEwjaj6HE77GXAxW8XEEAHXiXE5cQnPAOegQIRRAA..i&w=465&h=350&hcb=2&ved=2ahUKEwjaj6HE77GXAxW8XEEAHXiXE5cQnPAOegQIRRAA",
      },
    );
    final jsonResponse = response.data;
    final signupResModel = SignupResModel.fromJson(jsonResponse);
    return signupResModel;
  }
}