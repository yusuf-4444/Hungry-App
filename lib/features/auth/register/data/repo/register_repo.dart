import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/auth/register/models/register_model.dart';

class RegisterRepo {
  final ApiServices apiServices;

  RegisterRepo({required this.apiServices});

  Future<ApiResult<RegisterModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiServices.register({
        "name": name,
        "email": email,
        "password": password,
      });
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure("Error in Register.. Try Again \n$e");
    }
  }
}
