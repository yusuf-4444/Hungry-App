import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:hungry_app/features/auth/login/data/repo/login_repo.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/auto_login_state.dart';

class AutoLoginCubit extends Cubit<AutoLoginState> {
  final LoginRepo loginRepo;
  AutoLoginCubit(this.loginRepo) : super(AutoLoginState.initial());

  Future<void> checkAuthStatus() async {
    emit(AutoLoginState.loading());
    final result = await loginRepo.checkAutoLogin();
    result.when(
      success: (isLoggedIn) {
        if (isLoggedIn) {
          emit(AutoLoginState.authenticated());
        } else {
          emit(AutoLoginState.unAuthenticated());
        }
      },
      failure: (failure) => emit(AutoLoginState.unAuthenticated()),
    );
  }

  Future<void> enterAsGuest() async {
    emit(AutoLoginState.loading());

    await PrefHelper.setGuestMode(true);
    await PrefHelper.setLoggedIn(false);
    await PrefHelper.removeToken();

    emit(AutoLoginState.guest());
  }

  Future<void> logout() async {
    await PrefHelper.removeToken();
    emit(AutoLoginState.unAuthenticated());
  }
}
