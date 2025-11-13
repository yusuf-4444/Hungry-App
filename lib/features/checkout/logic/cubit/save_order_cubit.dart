import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/checkout/data/models/save_order.dart';
import 'package:hungry_app/features/checkout/data/repo/save_order_repo.dart';
import 'package:hungry_app/features/checkout/logic/cubit/save_order_state.dart';

class SaveOrderCubit extends Cubit<SaveOrderState> {
  final SaveOrderRepo saveOrderRepo;
  SaveOrderCubit(this.saveOrderRepo) : super(SaveOrderState.initial());

  Future<void> saveOrder(SaveOrder saveOrder) async {
    emit(SaveOrderState.loading());
    try {
      final response = await saveOrderRepo.saveOrder(saveOrder);
      response.when(
        success: (success) => emit(SaveOrderState.success(success)),
        failure: (failure) => emit(SaveOrderState.failure(failure)),
      );
    } catch (e) {
      emit(SaveOrderState.failure(e.toString()));
    }
  }
}
