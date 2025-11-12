import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_model.dart';
import 'package:hungry_app/features/cart/data/repo/addToCartRepo/add_to_cart_repo.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  final AddToCartRepo addToCartRepo;
  AddToCartCubit(this.addToCartRepo) : super(AddToCartState.initial());

  Future<void> addToCart(CartItems cartData) async {
    emit(AddToCartState.loading());
    try {
      final response = await addToCartRepo.addToCart(cartData);
      response.when(
        success: (success) => emit(AddToCartState.success(success)),
        failure: (failure) => emit(AddToCartState.failure(failure)),
      );
    } catch (e) {
      emit(AddToCartState.failure(e.toString()));
    }
  }
}
