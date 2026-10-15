import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';
import 'package:ecommerce_app_huma_volve/core/errors/remote_exption.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/models/profile_response.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProfileRemoteDataSource)
class ProfileApiDataSource implements ProfileRemoteDataSource {
  final Dio _dio;
  ProfileApiDataSource(this._dio);

  @override
  Future<ProfileResponse> getProfile(String token) async {
    try {
      final response = await _dio.get(
        ApiConsts.profileEndPoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return ProfileResponse.fromJson(response.data);
    } catch (e) {
      throw RemoteExptions(e.toString());
    }
  }
}
