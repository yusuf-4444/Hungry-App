import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  padding: EdgeInsets.only(
                    top: 20.h,
                    bottom: 80.h,
                    left: 8.w,
                    right: 8.w,
                  ),
                  itemBuilder: (context, index) => const CustomCard(
                    image: 'https://via.placeholder.com/200',
                    title: '',
                    subTitle: '',
                    itemId: 0,
                  ),
                  separatorBuilder: (context, index) => Gap(15.h),
                  itemCount: 5,
                ),
              );
            }

            if (state is Failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error, style: TextStyle(fontSize: 14.sp)),
                    Gap(16.h),
                    ElevatedButton(
                      onPressed: _refreshCart,
                      child: Text("Retry", style: TextStyle(fontSize: 14.sp)),
                    ),
                  ],
                ),
              );
            }

            if (state is Success) {
              items = state.data.data.items;
              totalPrice = double.tryParse(state.data.data.totalPrice) ?? 0;

              if (items.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    bottom: 80.h,
                    left: 8.w,
                    right: 8.w,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        Gap(16.h),
                        Text(
                          "Your cart is empty",
                          style: TextStyle(
                            fontSize: 18.sp,
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
                padding: EdgeInsets.only(
                  top: 20.h,
                  bottom: 100.h,
                  left: 8.w,
                  right: 8.w,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: CustomCard(
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
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade800, blurRadius: 8),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(13.h),
                          CustomText(
                            text: "Total",
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                          Gap(10.h),
                          CustomText(
                            text: "\$ ${checkoutPrice.toStringAsFixed(2)}",
                            color: Colors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ],
                      ),
                      CustomMainButton(
                        text: "Checkout",
                        fontSize: 14.sp,
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
