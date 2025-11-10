import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_to_cart_state.freezed.dart';

@freezed
class AddToCartState<T> with _$AddToCartState {
  const factory AddToCartState.initial() = _Initial;
  const factory AddToCartState.loading() = Loading;
  const factory AddToCartState.success(T data) = Success<T>;
  const factory AddToCartState.failure(String error) = Failure;
}
