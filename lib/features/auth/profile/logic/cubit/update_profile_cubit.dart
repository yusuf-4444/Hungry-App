import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/auth/profile/data/repo/update_profile_repo.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepo updateProfileRepo;
  UpdateProfileCubit(this.updateProfileRepo)
    : super(UpdateProfileState.initial());

  Future<void> updateProfile({
    required String name,
    required String email,
    required String delivaryAddress,
    required String visa,
    File? image,
  }) async {
    emit(UpdateProfileState.loading());

    try {
      final response = await updateProfileRepo.updateProfile(
        name: name,
        email: email,
        delivaryAddress: delivaryAddress,
        visa: visa,
        image: image,
      );
      response.when(
        success: (success) => emit(UpdateProfileState.success(success)),
        failure: (failure) => emit(UpdateProfileState.failure(failure)),
      );
    } catch (e) {
      emit(UpdateProfileState.failure(e.toString()));
    }
  }
}
