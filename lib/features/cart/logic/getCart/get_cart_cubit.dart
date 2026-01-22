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

  final Map<int, int> _localQuantityChanges = {};

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
          cartItemsData = success.data;
          _hasLoadedData = true;
          _localQuantityChanges.clear();

          final calculatedTotalPrice = _calculateTotalPrice(cartItemsData!);
          cartItemsData = cartItemsData!.copyWith(
            totalPrice: calculatedTotalPrice.toString(),
          );

          emit(GetCartState.success(CartModel(data: cartItemsData!)));
        },
        failure: (failure) => emit(GetCartState.failure(failure)),
      );
    } catch (e) {
      emit(GetCartState.failure(e.toString()));
    }
  }

  void incrementQuantity(int itemId) {
    if (cartItemsData == null) return;

    final currentItem = cartItemsData!.items.firstWhere(
      (item) => item.itemId == itemId,
    );
    final currentQuantity =
        _localQuantityChanges[itemId] ?? currentItem.quantity;
    _localQuantityChanges[itemId] = currentQuantity + 1;

    _updateCartUI();
  }

  void decrementQuantity(int itemId) {
    if (cartItemsData == null) return;

    final currentItem = cartItemsData!.items.firstWhere(
      (item) => item.itemId == itemId,
    );
    final currentQuantity =
        _localQuantityChanges[itemId] ?? currentItem.quantity;

    if (currentQuantity > 1) {
      _localQuantityChanges[itemId] = currentQuantity - 1;
      _updateCartUI();
    }
  }

  void _updateCartUI() {
    if (cartItemsData == null) return;

    final updatedItems = cartItemsData!.items.map((item) {
      final newQuantity = _localQuantityChanges[item.itemId] ?? item.quantity;
      return ItemData(
        itemId: item.itemId,
        productId: item.productId,
        name: item.name,
        image: item.image,
        quantity: newQuantity,
        price: item.price,
        spicy: item.spicy,
        toppings: item.toppings,
        sideOptions: item.sideOptions,
      );
    }).toList();

    cartItemsData = cartItemsData!.copyWith(items: updatedItems);

    final calculatedTotalPrice = _calculateTotalPrice(cartItemsData!);
    cartItemsData = cartItemsData!.copyWith(
      totalPrice: calculatedTotalPrice.toString(),
    );

    emit(GetCartState.success(CartModel(data: cartItemsData!)));
  }

  double _calculateTotalPrice(CartItemsData data) {
    double total = 0;
    for (var item in data.items) {
      final price = double.tryParse(item.price) ?? 0;
      final quantity = _localQuantityChanges[item.itemId] ?? item.quantity;
      total += price * quantity;
    }
    return total;
  }

  int getCurrentQuantity(int itemId) {
    final localQuantity = _localQuantityChanges[itemId];
    if (localQuantity != null) {
      return localQuantity;
    }

    final item = cartItemsData?.items.cast<ItemData?>().firstWhere(
      (item) => item?.itemId == itemId,
      orElse: () => null,
    );

    return item?.quantity ?? 1;
  }

  void clearLocalChanges() {
    _localQuantityChanges.clear();
  }

  Map<int, int> getLocalQuantityChanges() {
    return Map.from(_localQuantityChanges);
  }

  Future<void> refreshCart() async {
    await getCart(forceRefresh: true);
  }

  void clearCache() {
    cartItemsData = null;
    _hasLoadedData = false;
    _localQuantityChanges.clear();
    emit(const GetCartState.initial());
  }
}
