import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/home/data/models/side_options_model.dart';
import 'package:hungry_app/features/product/data/repo/toppings_side_options_repo.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_state.dart';

class SideOptionsCubit extends Cubit<SideOptionsState> {
  final ToppingsSideOptionsRepo toppingsSideOptionsRepo;
  SideOptionsCubit(this.toppingsSideOptionsRepo)
    : super(SideOptionsState.initial());

  bool _hasLoadedData = false;
  SideOptionsModel? successModel;

  Future<void> getSideOptions() async {
    if (_hasLoadedData && successModel != null) {
      emit(SideOptionsState.success(successModel!));
      return;
    }
    emit(SideOptionsState.loading());

    try {
      final response = await toppingsSideOptionsRepo.getSideOptions();
      response.when(
        success: (success) {
          _hasLoadedData = true;
          successModel = success;
          emit(SideOptionsState.success(success));
        },
        failure: (error) => emit(SideOptionsState.failure(error)),
      );
    } catch (e) {
      emit(SideOptionsState.failure(e.toString()));
    }
  }
}
