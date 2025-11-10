import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/home/data/models/side_options_model.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';

class ToppingsSideOptionsRepo {
  final ApiServices apiServices;

  ToppingsSideOptionsRepo({required this.apiServices});

  Future<ApiResult<ToppingsModel>> getToppings() async {
    try {
      final response = await apiServices.toppings();
      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.toString());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<SideOptionsModel>> getSideOptions() async {
    try {
      final response = await apiServices.sideOptions();
      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.toString());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
