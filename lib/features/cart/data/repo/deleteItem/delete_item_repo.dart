import 'package:dio/dio.dart';
import 'package:hungry_app/core/network/api_exceptions.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/cart/data/models/deleteItem/delete_item_model.dart';

class DeleteItemRepo {
  final ApiServices apiServices;

  DeleteItemRepo({required this.apiServices});

  Future<ApiResult<DeleteItemModel>> deleteItem(int id) async {
    try {
      final response = await apiServices.deleteItem(id);
      return ApiResult.success(response);
    } on DioException catch (e) {
      final message = ApiExceptions.fromDioException(e);
      return ApiResult.failure(message.toString());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
