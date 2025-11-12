import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_cart_state.freezed.dart';

@freezed
class GetCartState<T> with _$GetCartState {
  const factory GetCartState.initial() = _Initial;
  const factory GetCartState.loading() = Loading;
  const factory GetCartState.success(T data) = Success<T>;
  const factory GetCartState.failure(String error) = Failure;
}
