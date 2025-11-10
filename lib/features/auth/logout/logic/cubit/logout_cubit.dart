import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/auth/logout/data/repo/logout_repo.dart';
import 'package:hungry_app/features/auth/logout/logic/cubit/logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutRepo logoutRepo;
  LogoutCubit(this.logoutRepo) : super(LogoutState.initial());

  Future<void> logout() async {
    emit(LogoutState.loading());

    try {
      final response = await logoutRepo.logout();
      response.when(
        success: (success) => emit(LogoutState.success(success)),
        failure: (failure) => emit(LogoutState.failure(failure)),
      );
    } catch (e) {
      emit(LogoutState.failure(e.toString()));
    }
  }
}
