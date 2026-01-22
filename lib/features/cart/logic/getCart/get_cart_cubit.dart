import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_app/core/network/api_result.dart';
import 'package:hungry_app/features/cart/data/models/myCart/cart_model.dart';
import 'package:hungry_app/features/cart/data/repo/myCart/cart_repo.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_state.dart';

class GetCartCubit extends Cubit<GetCartState> {
  final CartRepo cartRepo;
  GetCartCubit(this.cartRepo) : super(const GetCartState.initial());

  CartItemsData? cartItemsData;
  bool _hasLoadedData = false;
  int quantity = 1;

  Future<void> getCart({bool forceRefresh = false}) async {
    if (_hasLoadedData && !forceRefresh && cartItemsData != null) {
      emit(GetCartState.success(CartModel(data: cartItemsData!)));
      return;
    }

    emit(const GetCartState.loading());
    try {
      final response = await cartRepo.myCart();
      response.when(
        success: (success) {
          String calculatedTotalPrice = _calculateTotalPrice(
            success.data,
          ).toString();
          cartItemsData = success.data.copyWith(
            totalPrice: calculatedTotalPrice,
          );
          _hasLoadedData = true;
          emit(GetCartState.success(CartModel(data: cartItemsData!)));
        },
        failure: (failure) => emit(GetCartState.failure(failure)),
      );
    } catch (e) {
      emit(GetCartState.failure(e.toString()));
    }
  }

  Future<void> refreshCart() async {
    await getCart(forceRefresh: true);
  }

  void clearCache() {
    cartItemsData = null;
    _hasLoadedData = false;
    emit(const GetCartState.initial());
  }

  void incrementQuantity() {
    for (var element in cartItemsData!.items) {
      if (element.itemId == element.itemId) {
        quantity++;
        cartItemsData = cartItemsData?.copyWith(
          items: cartItemsData!.items
              .map(
                (item) => item.itemId == element.itemId
                    ? ItemData(
                        itemId: item.itemId,
                        productId: item.productId,
                        name: item.name,
                        image: item.image,
                        quantity: quantity,
                        price: item.price,
                        spicy: item.spicy,
                        toppings: item.toppings,
                        sideOptions: item.sideOptions,
                      )
                    : item,
              )
              .toList(),
        );
      }
    }
    emit(GetCartState.increment(quantity));
  }
}

double _calculateTotalPrice(CartItemsData cartItemsData) {
  double total = 0;
  for (var item in cartItemsData.items) {
    double price = double.tryParse(item.price) ?? 0;
    total += price * item.quantity;
  }
  return total;
}
