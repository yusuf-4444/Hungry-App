import 'package:bloc/bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/home/data/models/food_data_model.dart';
import 'package:hungry_app/features/home/data/repo/food_repo.dart';
import 'package:hungry_app/features/home/logic/cubit/food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  final FoodRepo foodRepo;
  FoodCubit(this.foodRepo) : super(const FoodState.initial());

  List<Data> food = [];
  List<Data> filteredFood = [];
  bool _hasLoadedData = false;

  String currentSearchQuery = '';
  String currentCategory = 'All';

  Future<void> getFood({bool forceRefresh = false}) async {
    if (_hasLoadedData && !forceRefresh && food.isNotEmpty) {
      _applyFilters();
      return;
    }

    emit(const FoodState.loading());
    try {
      final response = await foodRepo.getFoods();
      response.when(
        success: (success) {
          food = success.data;
          filteredFood = List.from(food);
          _hasLoadedData = true;
          emit(FoodState.success(FoodDataModel(data: filteredFood)));
        },
        failure: (failure) {
          emit(FoodState.failure(failure));
        },
      );
    } catch (e) {
      emit(FoodState.failure(e.toString()));
    }
  }

  void searchFood(String query) {
    currentSearchQuery = query.toLowerCase();
    _applyFilters();
  }

  void filterByCategory(String category) {
    currentCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    filteredFood = food.where((item) {
      final matchesSearch =
          currentSearchQuery.isEmpty ||
          item.name.toLowerCase().contains(currentSearchQuery) ||
          item.description.toLowerCase().contains(currentSearchQuery);

      final matchesCategory =
          currentCategory == 'All' ||
          item.name.toLowerCase().contains(currentCategory.toLowerCase());

      return matchesSearch && matchesCategory;
    }).toList();

    emit(FoodState.success(FoodDataModel(data: filteredFood)));
  }

  Future<void> refreshFood() async {
    await getFood(forceRefresh: true);
  }

  void clearCache() {
    food = [];
    filteredFood = [];
    _hasLoadedData = false;
    currentSearchQuery = '';
    currentCategory = 'All';
  }
}
