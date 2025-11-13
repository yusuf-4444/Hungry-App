import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_order_state.freezed.dart';

@freezed
class SaveOrderState<T> with _$SaveOrderState {
  const factory SaveOrderState.initial() = _Initial;
  const factory SaveOrderState.loading() = Loading;
  const factory SaveOrderState.success(T data) = Success<T>;
  const factory SaveOrderState.failure(String error) = Failure;
}
