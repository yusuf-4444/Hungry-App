import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/cart/data/repo/deleteItem/delete_item_repo.dart';
import 'package:hungry_app/features/cart/logic/deleteItem/delete_item_state.dart';

class DeleteItemCubit extends Cubit<DeleteItemState> {
  final DeleteItemRepo deleteItemRepo;

  DeleteItemCubit(this.deleteItemRepo) : super(DeleteItemState.initial());

  Future<void> deleteItem(int id) async {
    emit(DeleteItemState.loading());
    try {
      final response = await deleteItemRepo.deleteItem(id);
      response.when(
        success: (success) => emit(DeleteItemState.success(success)),
        failure: (failure) => emit(DeleteItemState.failure(failure)),
      );
    } catch (e) {
      emit(DeleteItemState.failure(e.toString()));
    }
  }
}
