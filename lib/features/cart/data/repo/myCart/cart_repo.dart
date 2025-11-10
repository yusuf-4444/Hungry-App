import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/cart/data/models/myCart/cart_model.dart';

class CartRepo {
  final ApiServices apiServices;

  CartRepo({required this.apiServices});

  Future<ApiResult<CartModel>> myCart() async {
    try {
      final response = await apiServices.getCart();
      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.toString());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
