import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/home/data/models/side_options_model.dart';
import 'package:hungry_app/features/product/data/repo/toppings_side_options_repo.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_state.dart';

class SideOptionsCubit extends Cubit<SideOptionsState> {
  final ToppingsSideOptionsRepo toppingsSideOptionsRepo;
  SideOptionsCubit(this.toppingsSideOptionsRepo)
    : super(const SideOptionsState.initial());

  SideOptionsModel? _cachedSideOptions;

  bool _hasLoadedData = false;

  Future<void> getSideOptions({bool forceRefresh = false}) async {
    if (_hasLoadedData && _cachedSideOptions != null && !forceRefresh) {
      emit(SideOptionsState.success(_cachedSideOptions!));
      return;
    }

    emit(const SideOptionsState.loading());

    try {
      final response = await toppingsSideOptionsRepo.getSideOptions();

      response.when(
        success: (success) {
          _cachedSideOptions = success;
          _hasLoadedData = true;

          sideOptionsModel = success;

          emit(SideOptionsState.success(success));
        },
        failure: (error) => emit(SideOptionsState.failure(error)),
      );
    } catch (e) {
      emit(SideOptionsState.failure(e.toString()));
    }
  }

  Future<void> refreshSideOptions() async {
    await getSideOptions(forceRefresh: true);
  }

  void clearCache() {
    _cachedSideOptions = null;
    _hasLoadedData = false;
    emit(const SideOptionsState.initial());
  }
}
