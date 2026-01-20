import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/auth/profile/data/repo/profile_repo.dart';
import 'package:hungry_app/features/auth/profile/logic/cubit/profile_state.dart';
import 'package:hungry_app/features/auth/profile/models/profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(const ProfileState.initial());

  ProfileModel? cachedProfile;
  bool _hasLoadedData = false;

  Future<void> getProfile({bool forceRefresh = false}) async {
    if (_hasLoadedData && !forceRefresh && cachedProfile != null) {
      emit(ProfileState.success(cachedProfile!));
      return;
    }

    emit(const ProfileState.loading());

    try {
      final response = await profileRepo.getProfile();
      response.when(
        success: (success) {
          cachedProfile = success;
          _hasLoadedData = true;
          emit(ProfileState.success(success));
        },
        failure: (failure) => emit(ProfileState.failure(failure)),
      );
    } catch (e) {
      emit(ProfileState.failure(e.toString()));
    }
  }

  void updateCachedProfile(ProfileModel profile) {
    cachedProfile = profile;
    _hasLoadedData = true;
    emit(ProfileState.success(profile));
  }

  Future<void> refreshProfile() async {
    await getProfile(forceRefresh: true);
  }

  void clearCache() {
    cachedProfile = null;
    _hasLoadedData = false;
    emit(const ProfileState.initial());
  }
}
