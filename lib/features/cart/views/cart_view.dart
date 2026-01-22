import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/cart/data/models/myCart/cart_model.dart';
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
  List<ItemData> items = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    context.read<GetCartCubit>().getCart();
  }

  Future<void> _refreshCart() async {
    await context.read<GetCartCubit>().refreshCart();
  }

  Future<void> _deleteItem(int itemId) async {
    setState(() {
      isRemoving = true;
    });

    // Delete logic here

    setState(() {
      isRemoving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshCart,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: BlocBuilder<GetCartCubit, GetCartState>(
          builder: (context, state) {
            if (state is Loading) {
              return Skeletonizer(
                child: ListView.separated(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 80,
                    left: 8,
                    right: 8,
                  ),
                  itemBuilder: (context, index) => const CustomCard(
                    image: 'https://via.placeholder.com/200',
                    title: '',
                    subTitle: '',
                    itemId: 0,
                  ),
                  separatorBuilder: (context, index) => const Gap(15),
                  itemCount: 5,
                ),
              );
            }

            if (state is Failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: _refreshCart,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state is Success) {
              items = state.data.data.items;
              totalPrice = double.tryParse(state.data.data.totalPrice) ?? 0;

              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 80,
                    left: 8,
                    right: 8,
                  ),
                  child: Center(
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
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 100,
                  left: 8,
                  right: 8,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: CustomCard(
                      onPressed: () => _deleteItem(item.itemId),
                      image: item.image,
                      title: item.name,
                      subTitle: 'Spice ${item.spicy}',
                      itemId: item.itemId,
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        bottomSheet: BlocBuilder<GetCartCubit, GetCartState>(
          builder: (context, state) {
            if (state is Success && items.isNotEmpty) {
              final checkoutPrice =
                  double.tryParse(state.data.data.totalPrice) ?? 0;

              return Container(
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
                            fontSize: 14,
                          ),
                          const Gap(10),
                          CustomText(
                            text: "\$ ${checkoutPrice.toStringAsFixed(2)}",
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ],
                      ),
                      CustomMainButton(
                        text: "Checkout",
                        fontSize: 14,
                        onPressed: items.isEmpty
                            ? null
                            : () {
                                final cubit = context.read<GetCartCubit>();
                                List<OrderItems> orderItems = [];

                                for (var item in items) {
                                  final quantity = cubit.getCurrentQuantity(
                                    item.itemId,
                                  );

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
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
