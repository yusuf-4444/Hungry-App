import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_login_state.freezed.dart';

@freezed
class AutoLoginState with _$AutoLoginState {
  const factory AutoLoginState.initial() = _Initial;
  const factory AutoLoginState.loading() = Loading;
  const factory AutoLoginState.authenticated() = Authenticated;
  const factory AutoLoginState.unAuthenticated() = UnAuthenticated;
  const factory AutoLoginState.guest() = Guest;
}
