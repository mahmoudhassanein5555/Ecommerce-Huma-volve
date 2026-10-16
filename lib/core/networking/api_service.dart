import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_constants.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_request_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/sign_up_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_response_model.dart';
import 'package:ecommerce_app_huma_volve/features/profile/data/model/auth_data_response_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @POST(ApiConstants.login)
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequestBody);

  @POST(ApiConstants.signUp)
  Future<SignUpResponseModel> signUp(@Body() SignUpRequestModel loginRequestBody);

  @GET(ApiConstants.auth)
  Future<AuthDataResponseModel> getAuthData();

  @GET(ApiConstants.products)
  Future<List<ProductResponseModel>> getProducts(
    @Query('limit') int limit,
    @Query('offset') int offset,
  );

  @GET(ApiConstants.categories)
  Future<List<CategoryResponseModel>> getCategories();

    @GET(ApiConstants.productsBycategories)
  Future<List<ProductResponseModel>> getCategoriesProducts(
    @Path('id') int categoryId,
    @Query('limit') int limit,
    @Query('offset') int offset,
  );
}
