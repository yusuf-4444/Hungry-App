import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_model.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_state.dart';
import 'package:hungry_app/features/home/views/home_view.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_cubit.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_state.dart'
    as SideState;
import 'package:hungry_app/features/product/logic/cubit/toppings_cubit.dart';
import 'package:hungry_app/features/product/logic/cubit/toppings_state.dart'
    as ToppingState;
import 'package:hungry_app/features/product/widgets/custom_header_spicy_details.dart';
import 'package:hungry_app/features/product/widgets/custom_toppings_side_options.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:hungry_app/shared/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double sliderValue = 0.5;
  List<int> toppings = [];
  List<int> sideOptions = [];

  @override
  void initState() {
    context.read<ToppingsCubit>().getToppings();
    context.read<SideOptionsCubit>().getSideOptions();
    super.initState();
  }

  CartItems _cartData() {
    return CartItems(
      items: [
        Item(
          productId: widget.productId,
          quantity: 1,
          spicy: sliderValue,
          toppings: toppings,
          sideOptions: sideOptions,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderSpicyDetails(sliderValue: sliderValue),
              Gap(20),
              CustomText(
                text: "Toppings",
                color: Color(0xff3C2F2F),
                fontWeight: FontWeight.w600,
                fontsize: 18,
              ),
              Gap(15),

              BlocBuilder<ToppingsCubit, ToppingState.ToppingsState>(
                builder: (context, state) {
                  return CustomToppingsSideOptionsWidget(
                    isLoading: state is ToppingState.Loading,
                    data: state is ToppingState.Success ? state.data : null,
                    selectedItems: toppings,
                    onItemSelection: (value) {
                      if (toppings.contains(value)) {
                        toppings.remove(value);
                      } else {
                        toppings.add(value);
                      }
                    },
                  );
                },
              ),

              Gap(30),
              CustomText(
                text: "Side Options",
                color: Color(0xff3C2F2F),
                fontWeight: FontWeight.w600,
                fontsize: 18,
              ),
              Gap(15),

              BlocBuilder<SideOptionsCubit, SideState.SideOptionsState>(
                builder: (context, state) {
                  return CustomToppingsSideOptionsWidget(
                    isLoading: state is SideState.Loading,
                    data: state is SideState.Success ? state.data : null,
                    selectedItems: sideOptions,
                    onItemSelection: (value) {
                      if (sideOptions.contains(value)) {
                        sideOptions.remove(value);
                      } else {
                        sideOptions.add(value);
                      }
                    },
                  );
                },
              ),

              Gap(120),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade800, blurRadius: 8)],
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
                    text: "\$18.19",
                    color: Colors.black,
                    fontsize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
              BlocConsumer<AddToCartCubit, AddToCartState>(
                listener: (context, state) {
                  state.whenOrNull(
                    success: (data) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(
                          "Item Added Successfully",
                          AppColors.primaryColor,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeView();
                          },
                        ),
                      );
                    },
                  );
                },
                builder: (context, state) {
                  return CustomMainButton(
                    text: state is Loading ? "Adding..." : "Add To Cart",
                    fontSize: 16,
                    onPressed: () {
                      final cartData = _cartData();
                      context.read<AddToCartCubit>().addToCart(cartData);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
