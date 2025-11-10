import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/cart/data/models/myCart/cart_model.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_state.dart';
import 'package:hungry_app/features/cart/widgets/custom_card.dart';
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
  late List<int> quantities;
  @override
  void initState() {
    context.read<GetCartCubit>().getCart();
    super.initState();
  }

  void onAdd(index) {
    quantities[index]++;
    setState(() {});
  }

  void onMinus(index) {
    if (index > 1) {
      quantities[index]--;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCartCubit, GetCartState>(
      builder: (context, state) {
        List<ItemData> items = [];
        String totalPrice = "0";
        if (state is Success) {
          items = state.data.data.items;
          totalPrice = state.data.data.totalPrice;
        }

        return Skeletonizer(
          enabled: state is Loading,
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
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: CustomCard(
                      onPressed: () {},
                      image: item.image,
                      title: item.name,
                      subTitle: 'Spice ${item.spicy}',
                      initialNumber: item.quantity,
                    ),
                  );
                },
              ),
            ),
            bottomSheet: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
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
                        Gap(13),
                        CustomText(
                          text: "Total",
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontsize: 14,
                        ),
                        Gap(10),
                        CustomText(
                          text: totalPrice,
                          color: Colors.black,
                          fontsize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                    CustomMainButton(
                      text: "Checkout",
                      fontSize: 14,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CheckoutView();
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
        );
      },
    );
  }
}
