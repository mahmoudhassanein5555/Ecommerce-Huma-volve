import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/sign_up_request.dart';
import '../models/sign_up_response.dart';

class SignUpService {
  Future<SignUpResponse> signUp({required SignUpRequest body}) async {
    final response = await ApiClient.instance.post(
      ApiEndpoints.users,
      data: body.toJson(),
    );
    return SignUpResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
