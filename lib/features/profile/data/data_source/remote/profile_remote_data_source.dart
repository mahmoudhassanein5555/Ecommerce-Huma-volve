import 'package:ecommerce_app_huma_volve/features/profile/data/models/profile_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponse> getProfile(String token);
}
