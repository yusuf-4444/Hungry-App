import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
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
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
