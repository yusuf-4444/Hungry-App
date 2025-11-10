import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:hungry_app/features/auth/login/models/login_model.dart';

class LoginRepo {
  final ApiServices apiServices;

  LoginRepo({required this.apiServices});

  Future<ApiResult<LoginModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiServices.login({
        "email": email,
        "password": password,
      });

      await PrefHelper.saveToken(response.data.token);
      await PrefHelper.setLoggedIn(true);
      await PrefHelper.setGuestMode(false);

      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<bool>> checkAutoLogin() async {
    try {
      final isLoggedIn = await PrefHelper.isLoggedIn();
      final token = await PrefHelper.getToken();
      final isGuest = await PrefHelper.isGuest();

      if (isLoggedIn && token != null && !isGuest) {
        return ApiResult.success(true);
      }

      return ApiResult.success(false);
    } catch (e) {
      return ApiResult.failure("auto login failed: $e");
    }
  }
}
