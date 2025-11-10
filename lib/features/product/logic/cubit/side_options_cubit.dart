import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/product/data/repo/toppings_side_options_repo.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_state.dart';

class SideOptionsCubit extends Cubit<SideOptionsState> {
  final ToppingsSideOptionsRepo toppingsSideOptionsRepo;
  SideOptionsCubit(this.toppingsSideOptionsRepo)
    : super(SideOptionsState.initial());

  Future<void> getSideOptions() async {
    emit(SideOptionsState.loading());

    try {
      final response = await toppingsSideOptionsRepo.getSideOptions();
      response.when(
        success: (success) => emit(SideOptionsState.success(success)),
        failure: (error) => emit(SideOptionsState.failure(error)),
      );
    } catch (e) {
      emit(SideOptionsState.failure(e.toString()));
    }
  }
}
