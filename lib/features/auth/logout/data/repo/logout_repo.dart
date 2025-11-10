import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/auth/logout/models/logout_model.dart';

class LogoutRepo {
  final ApiServices apiServices;

  LogoutRepo({required this.apiServices});

  Future<ApiResult<LogoutModel>> logout() async {
    try {
      final response = await apiServices.logout();
      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
