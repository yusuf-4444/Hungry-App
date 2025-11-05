import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState<T> with _$RegisterState {
  const factory RegisterState.initial() = _Initial;
  const factory RegisterState.loading() = Loading;
  const factory RegisterState.success(T data) = Success<T>;
  const factory RegisterState.failure(String error) = Failure;
}
