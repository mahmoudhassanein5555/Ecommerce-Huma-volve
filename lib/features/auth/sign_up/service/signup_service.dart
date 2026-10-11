import 'package:ecommerce_app_huma_volve/core/network_service/network_services.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/Signup_res_model.dart';

import '../../../../core/constant/api_end_point.dart';

class SignupService {
  NetworkServices networkServices;

  SignupService({required this.networkServices});

  Future<SignupResModel> signup(SignupResModel signupReqModel) async {
    final response = await networkServices.dio.post(
      ApiEndPoint.register,
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
