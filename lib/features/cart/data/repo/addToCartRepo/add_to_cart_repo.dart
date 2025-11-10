import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_model.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_response_model.dart';

class AddToCartRepo {
  final ApiServices apiServices;

  AddToCartRepo({required this.apiServices});

  Future<ApiResult<AddToCartResponseModel>> addToCart(
    CartItems cartData,
  ) async {
    try {
      final response = await apiServices.addToCart(cartData);
      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.toString());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
