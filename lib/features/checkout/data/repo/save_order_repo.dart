import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/checkout/data/models/save_order.dart';
import 'package:hungry_app/features/checkout/data/models/save_order_response.dart';

class SaveOrderRepo {
  final ApiServices apiServices;

  SaveOrderRepo({required this.apiServices});

  Future<ApiResult<SaveOrderResponse>> saveOrder(SaveOrder saveOrder) async {
    try {
      final response = await apiServices.saveOrder(saveOrder);
      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.toString());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
