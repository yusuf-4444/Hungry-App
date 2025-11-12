import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_item_state.freezed.dart';

@freezed
class DeleteItemState<T> with _$DeleteItemState {
  const factory DeleteItemState.initial() = _Initial;
  const factory DeleteItemState.loading() = Loading;
  const factory DeleteItemState.success(T data) = Success<T>;
  const factory DeleteItemState.failure(String error) = Failure;
}
