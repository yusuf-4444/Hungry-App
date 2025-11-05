import 'package:bloc/bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/home/data/models/food_data_model.dart';
import 'package:hungry_app/features/home/data/repo/food_repo.dart';
import 'package:hungry_app/features/home/logic/cubit/food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepo foodRepo;
  FoodCubit(this.foodRepo) : super(FoodState.initial());

  List<Data> food = [];

  Future<void> getFood() async {
    emit(FoodState.loading());
    try {
      final response = await foodRepo.getFoods();
      response.when(
        success: (success) {
          food = success.data;
          emit(FoodState.success(success));
        },
        failure: (failure) {
          emit(FoodState.failure(failure));
        },
      );
    } catch (e) {
      emit(FoodState.failure(e.toString()));
    }
  }
}
