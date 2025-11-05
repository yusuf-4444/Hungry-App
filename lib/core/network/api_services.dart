import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_constants.dart';
import 'package:hungry_app/features/auth/login/models/login_model.dart';
import 'package:hungry_app/features/auth/register/models/register_model.dart';
import 'package:hungry_app/features/home/data/models/food_data_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiServices {
  factory ApiServices(Dio dio) = _ApiServices;

  @GET(ApiConstants.product)
  Future<FoodDataModel> getFood();

  @POST(ApiConstants.register)
  Future<RegisterModel> register(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.login)
  Future<LoginModel> login(@Body() Map<String, dynamic> body);
}
