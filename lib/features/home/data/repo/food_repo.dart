import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/api_services.dart';
import 'package:hungry_app/features/home/data/models/food_data_model.dart';

class FoodRepo {
  final ApiServices apiServices;

  FoodRepo({required this.apiServices});

  Future<ApiResult<FoodDataModel>> getFoods() async {
    try {
      final response = await apiServices.getFood();
      return ApiResult.success(response);
    } catch (e) {
      print("error in foods $e");
      return ApiResult.failure(e.toString());
    }
  }
}
