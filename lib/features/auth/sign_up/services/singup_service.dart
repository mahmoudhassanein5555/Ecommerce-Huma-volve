import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/networks/api_clints.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/singup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/singup_res_model.dart';

class SingupService {
  ApiClints apiClints;
  SingupService(this.apiClints);
  Future<SingupResModel> signup(SingupReqModel signup) async {
    final response = await apiClints.dio.post(
      ApiEndpoints.singupEndpoint,
      data: {
        'name': signup.name,
        'email': signup.email,
        'password': signup.password,
        'avatar': 'https://picsum.photos/640/480',
      },
    );
    final Map<String, dynamic> jsonDate = response.data;
    final modelData = SingupResModel.fromJson(jsonDate);
    return modelData;
  }
}
