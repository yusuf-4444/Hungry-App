import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/auth/register/data/repo/register_repo.dart';
import 'package:hungry_app/features/auth/register/logic/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;
  RegisterCubit(this.registerRepo) : super(RegisterState.initial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterState.loading());
    try {
      final response = await registerRepo.register(
        name: name,
        email: email,
        password: password,
      );
      response.when(
        success: (data) => emit(RegisterState.success(data)),
        failure: (failure) => emit(RegisterState.failure(failure)),
      );
    } catch (e) {
      emit(RegisterState.failure(e.toString()));
    }
  }
}
