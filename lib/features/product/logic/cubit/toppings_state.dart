import 'package:freezed_annotation/freezed_annotation.dart';

part 'toppings_state.freezed.dart';

@freezed
class ToppingsState<T> with _$ToppingsState {
  const factory ToppingsState.initial() = _Initial;
  const factory ToppingsState.loading() = Loading;
  const factory ToppingsState.success(T data) = Success<T>;
  const factory ToppingsState.failure(String error) = Failure;
}
