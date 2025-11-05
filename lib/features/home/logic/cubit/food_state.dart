import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_state.freezed.dart';

@freezed
class FoodState<T> with _$FoodState {
  const factory FoodState.initial() = _Initial;
  const factory FoodState.loading() = Loading;
  const factory FoodState.success(T data) = Success<T>;
  const factory FoodState.failure(String error) = Failure;
}
