import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_constants.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/auth/profile/models/update_profile_model.dart';

class UpdateProfileRepo {
  final ApiServices apiServices;
  final Dio dio;

  UpdateProfileRepo({required this.apiServices, required this.dio});

  Future<ApiResult<UpdateProfileModel>> updateProfile({
    required String name,
    required String email,
    required String delivaryAddress,
    required String visa,
    File? image,
  }) async {
    try {
      if (image != null) {
        FormData formData = FormData.fromMap({
          "name": name,
          "email": email,
          "address": delivaryAddress,
          "Visa": visa,
          "image": await MultipartFile.fromFile(image.path),
        });

        final response = await dio.post(
          "${ApiConstants.baseUrl}${ApiConstants.updateProfile}",
          data: formData,
        );

        final updateProfileModel = UpdateProfileModel.fromJson(response.data);

        return ApiResult.success(updateProfileModel);
      } else {
        final response = await apiServices.updateProfile({
          "name": name,
          "email": email,
          "address": delivaryAddress,
          "Visa": visa,
        });
        return ApiResult.success(response);
      }
    } on DioException catch (e) {
      final error = ApiExceptions.fromDioException(e);
      return ApiResult.failure(error.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
