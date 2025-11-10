import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_constants.dart';
import 'package:hungry_app/features/auth/login/models/login_model.dart';
import 'package:hungry_app/features/auth/logout/models/logout_model.dart';
import 'package:hungry_app/features/auth/profile/models/profile_model.dart';
import 'package:hungry_app/features/auth/profile/models/update_profile_model.dart';
import 'package:hungry_app/features/auth/register/models/register_model.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_model.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_response_model.dart';
import 'package:hungry_app/features/cart/data/models/myCart/cart_model.dart';
import 'package:hungry_app/features/home/data/models/food_data_model.dart';
import 'package:hungry_app/features/home/data/models/side_options_model.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';
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

  @GET(ApiConstants.profile)
  Future<ProfileModel> getProfile();

  @POST(ApiConstants.updateProfile)
  Future<UpdateProfileModel> updateProfile(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.logout)
  Future<LogoutModel> logout();

  @GET(ApiConstants.toppings)
  Future<ToppingsModel> toppings();

  @GET(ApiConstants.sideOptions)
  Future<SideOptionsModel> sideOptions();

  @POST(ApiConstants.addToCart)
  Future<AddToCartResponseModel> addToCart(@Body() CartItems cartData);

  @GET(ApiConstants.myCart)
  Future<CartModel> getCart();
}
