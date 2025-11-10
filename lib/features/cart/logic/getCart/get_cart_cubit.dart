import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/cart/data/models/myCart/cart_model.dart';
import 'package:hungry_app/features/cart/data/repo/myCart/cart_repo.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_state.dart';

class GetCartCubit extends Cubit<GetCartState> {
  final CartRepo cartRepo;
  GetCartCubit(this.cartRepo) : super(GetCartState.initial());

  CartItemsData? cartItemsData;

  Future<void> getCart() async {
    emit(GetCartState.loading());
    try {
      final response = await cartRepo.myCart();
      response.when(
        success: (success) {
          cartItemsData = success.data;
          emit(GetCartState.success(success));
        },
        failure: (failure) => emit(GetCartState.failure(failure)),
      );
    } catch (e) {
      emit(GetCartState.failure(e.toString()));
    }
  }
}
