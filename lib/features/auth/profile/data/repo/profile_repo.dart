import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/auth/profile/models/profile_model.dart';

class ProfileRepo {
  final ApiServices apiServices;

  ProfileRepo({required this.apiServices});

  Future<ApiResult<ProfileModel>> getProfile() async {
    try {
      final response = await apiServices.getProfile();
      return ApiResult.success(response);
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
