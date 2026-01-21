import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/core/network/pref_helper.dart';
import 'package:hungry_app/features/auth/login/data/repo/login_repo.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/auto_login_state.dart';

class AutoLoginCubit extends Cubit<AutoLoginState> {
  final LoginRepo loginRepo;
  AutoLoginCubit(this.loginRepo) : super(const AutoLoginState.initial());

  Future<void> checkAuthStatus() async {
    emit(const AutoLoginState.loading());
    final result = await loginRepo.checkAutoLogin();
    result.when(
      success: (isLoggedIn) {
        if (isLoggedIn) {
          emit(const AutoLoginState.authenticated());
        } else {
          emit(const AutoLoginState.unAuthenticated());
        }
      },
      failure: (failure) => emit(const AutoLoginState.unAuthenticated()),
    );
  }

  Future<void> enterAsGuest() async {
    if (isClosed) return;
    emit(const AutoLoginState.loading());

    await PrefHelper.setGuestMode(true);
    await PrefHelper.setLoggedIn(false);
    await PrefHelper.removeToken();

    if (!isClosed) {
      emit(const AutoLoginState.guest());
    }
  }

  Future<void> logout() async {
    await PrefHelper.removeToken();
    emit(const AutoLoginState.unAuthenticated());
  }
}
