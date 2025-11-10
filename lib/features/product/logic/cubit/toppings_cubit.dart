import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/product/data/repo/toppings_side_options_repo.dart';
import 'package:hungry_app/features/product/logic/cubit/toppings_state.dart';

class ToppingsCubit extends Cubit<ToppingsState> {
  final ToppingsSideOptionsRepo toppingsSideOptionsRepo;
  ToppingsCubit(this.toppingsSideOptionsRepo) : super(ToppingsState.initial());

  Future<void> getToppings() async {
    emit(ToppingsState.loading());
    try {
      final response = await toppingsSideOptionsRepo.getToppings();
      response.when(
        success: (success) => emit(ToppingsState.success(success)),
        failure: (error) => emit(ToppingsState.failure(error)),
      );
    } catch (e) {
      emit(ToppingsState.failure(e.toString()));
    }
  }
}
