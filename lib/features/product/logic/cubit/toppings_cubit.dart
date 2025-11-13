import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';
import 'package:hungry_app/features/product/data/repo/toppings_side_options_repo.dart';
import 'package:hungry_app/features/product/logic/cubit/toppings_state.dart';

class ToppingsCubit extends Cubit<ToppingsState> {
  final ToppingsSideOptionsRepo toppingsSideOptionsRepo;
  ToppingsCubit(this.toppingsSideOptionsRepo) : super(ToppingsState.initial());

  bool _hasData = false;
  ToppingsModel? toppingSuccess;

  Future<void> getToppings() async {
    if (_hasData == true && toppingSuccess != null) {
      emit(ToppingsState.success(toppingSuccess!));
      return;
    }
    emit(ToppingsState.loading());
    try {
      final response = await toppingsSideOptionsRepo.getToppings();
      response.when(
        success: (success) {
          emit(ToppingsState.success(success));
          _hasData = true;
          toppingSuccess = success;
        },
        failure: (error) => emit(ToppingsState.failure(error)),
      );
    } catch (e) {
      emit(ToppingsState.failure(e.toString()));
    }
  }
}
