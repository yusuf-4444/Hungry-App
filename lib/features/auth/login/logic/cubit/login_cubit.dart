import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/auth/login/data/repo/login_repo.dart';
import 'package:hungry_app/features/auth/login/logic/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super(LoginState.initial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginState.loading());

    try {
      final response = await loginRepo.login(email: email, password: password);
      response.when(
        success: (data) => emit(LoginState.success(data)),
        failure: (error) => emit(LoginState.failure(error)),
      );
    } catch (e) {
      emit(LoginState.failure(e.toString()));
    }
  }
}
