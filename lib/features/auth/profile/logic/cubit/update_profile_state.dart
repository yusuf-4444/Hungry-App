import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_state.freezed.dart';

@freezed
class UpdateProfileState<T> with _$UpdateProfileState {
  const factory UpdateProfileState.initial() = _Initial;
  const factory UpdateProfileState.loading() = Loading;
  const factory UpdateProfileState.success(T data) = Success<T>;
  const factory UpdateProfileState.failure(String error) = Failure;
}
