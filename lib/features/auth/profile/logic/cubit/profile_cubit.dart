import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/auth/profile/data/repo/profile_repo.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileState.initial());

  Future<void> getProfile() async {
    emit(ProfileState.loading());

    try {
      final response = await profileRepo.getProfile();
      response.when(
        success: (success) {
          emit(ProfileState.success(success));
        },
        failure: (failure) => emit(ProfileState.failure(failure)),
      );
    } catch (e) {
      emit(ProfileState.failure(e.toString()));
    }
  }
}
