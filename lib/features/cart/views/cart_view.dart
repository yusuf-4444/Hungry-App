import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/cart/data/models/myCart/cart_model.dart';
import 'package:hungry_app/features/cart/logic/deleteItem/delete_item_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_state.dart';
import 'package:hungry_app/features/cart/widgets/custom_card.dart';
import 'package:hungry_app/features/checkout/data/models/save_order.dart';
import 'package:hungry_app/features/checkout/views/checkout_view.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool isRemoving = false;
  int quantity = 1;
  double finalPrice = 0;
  late double checkoutPrice = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetCartCubit>().getCart();
    });
  }

  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCartCubit, GetCartState>(
      builder: (context, state) {
        final isLoading = state is Loading;
        List<ItemData> items = [];

        if (state is Success) {
          items = state.data.data.items;
          totalPrice = double.parse(state.data.data.totalPrice);
        } else if (state is Failure && !isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error.toString()),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GetCartCubit>().getCart();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }
        finalPrice = totalPrice;

        final displayItems = isLoading
            ? List<ItemData>.generate(
                4,
                (index) => ItemData(
                  itemId: 0,
                  productId: 0,
                  name: '',
                  image:
                      'https://sonic-zdi0.onrender.com/storage/products/cheeseburger.jpg',
                  quantity: 0,
                  price: '',
                  spicy: '',
                  toppings: [],
                  sideOptions: [],
                ),
              )
            : items;

        return Skeletonizer(
          enabled: isLoading,
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<GetCartCubit>().refreshCart();
            },
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.white,
                scrolledUnderElevation: 0,
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 80,
                  left: 8,
                  right: 8,
                ),
                child: displayItems.isEmpty && !isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            Gap(16),
                            Text(
                              "Your cart is empty",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: displayItems.length,
                        itemBuilder: (context, index) {
                          final item = displayItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: CustomCard(
                              onQuantityChanged: (newQuantity) {
                                quantity = newQuantity;
                                finalPrice = totalPrice * quantity;
                                checkoutPrice = finalPrice;
                                setState(() {});
                                print(finalPrice);
                              },
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      context
                                          .read<DeleteItemCubit>()
                                          .deleteItem(item.itemId);

                                      context
                                          .read<GetCartCubit>()
                                          .refreshCart();
                                    },
                              image: item.image,
                              title: item.name,
                              subTitle: 'Spice ${item.spicy}',
                              initialNumber: item.quantity,
                            ),
                          );
                        },
                      ),
              ),
              bottomSheet: (items.isEmpty && !isLoading)
                  ? const SizedBox()
                  : Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade800, blurRadius: 8),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(13),
                                const CustomText(
                                  text: "Total",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontsize: 14,
                                ),
                                const Gap(10),
                                CustomText(
                                  text: "\$ $checkoutPrice",
                                  color: Colors.black,
                                  fontsize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ],
                            ),
                            CustomMainButton(
                              text: "Checkout",
                              fontSize: 14,
                              onPressed: isLoading || items.isEmpty
                                  ? null
                                  : () {
                                      List<OrderItems> orderItems = [];
                                      for (var item in items) {
                                        orderItems.add(
                                          OrderItems(
                                            productId: item.productId,
                                            quantity: quantity,
                                            spicy: double.parse(item.spicy),
                                            toppings: item.toppings
                                                .map((t) => t.id)
                                                .toList(),
                                            sideOptions: item.sideOptions
                                                .map((t) => t.id)
                                                .toList(),
                                          ),
                                        );
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return CheckoutView(
                                              price: checkoutPrice,
                                              orderItems: orderItems,
                                            );
                                          },
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
