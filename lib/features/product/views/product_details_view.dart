import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_model.dart';
import 'package:hungry_app/features/cart/logic/addToCartCubit/add_to_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_state.dart';
import 'package:hungry_app/features/home/data/models/side_options_model.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_cubit.dart';
import 'package:hungry_app/features/product/logic/cubit/side_options_state.dart'
    as side_options_state;
import 'package:hungry_app/features/product/logic/cubit/toppings_cubit.dart';
import 'package:hungry_app/features/product/logic/cubit/toppings_state.dart'
    as toppings_state;
import 'package:hungry_app/features/product/widgets/custom_header_spicy_details.dart';
import 'package:hungry_app/features/product/widgets/custom_toppings_side_options.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:hungry_app/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    super.key,
    required this.productId,
    required this.price,
  });

  final int productId;
  final String price;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double sliderValue = 0.5;
  List<int> toppings = [];
  List<int> sideOptions = [];

  bool isToppingsLoading = false;
  bool isSideOptionsLoading = false;
  bool isAddingToCart = false;

  ToppingsModel? toppingsData;
  SideOptionsModel? sideOptionsData;

  String? toppingsError;
  String? sideOptionsError;

  @override
  void initState() {
    super.initState();
  }

  bool _isProductInCart() {
    final cartCubit = context.read<GetCartCubit>();
    final cartState = cartCubit.state;

    if (cartState is Success) {
      final items = cartState.data.data.items;
      // نتحقق لو في item بنفس الـ productId
      return items.any((item) => item.productId == widget.productId);
    }
    return false;
  }

  Future<void> _addToCart() async {
    if (_isProductInCart()) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar("This item is already in your cart!", Colors.orange),
      );
      return;
    }

    setState(() {
      isAddingToCart = true;
    });

    try {
      final cartData = _cartData();

      final addToCartCubit = context.read<AddToCartCubit>();
      await addToCartCubit.addToCart(cartData);

      await context.read<GetCartCubit>().refreshCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar("Item Added Successfully", AppColors.primaryColor),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar("Failed to add item: ${e.toString()}", Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
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
            Navigator.popAndPushNamed(context, AppRoutes.root);
          },
          icon: const Icon(Icons.arrow_back, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderSpicyDetails(
                sliderValue: sliderValue,
                onChanged: (v) {
                  setState(() {
                    sliderValue = v;
                  });
                },
              ),
              const Gap(20),
              const CustomText(
                text: "Toppings",
                color: Color(0xff3C2F2F),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              const Gap(15),

              // Toppings Section
              BlocBuilder<ToppingsCubit, toppings_state.ToppingsState>(
                bloc: context.read<ToppingsCubit>(),
                buildWhen: (previous, current) =>
                    current is toppings_state.Loading ||
                    current is toppings_state.Success ||
                    current is toppings_state.Failure,
                builder: (context, state) {
                  if (state is toppings_state.Loading) {
                    return Skeletonizer(
                      enabled: true,
                      child: CustomToppingsSideOptionsWidget(
                        isLoading: true,
                        data: null,
                        selectedItems: const [],
                        onItemSelection: (value) {},
                      ),
                    );
                  } else if (state is toppings_state.Failure) {
                    return Center(
                      child: CustomText(
                        text: "Error: ${state.error}",
                        color: Colors.red,
                      ),
                    );
                  } else if (state is toppings_state.Success) {
                    toppingsData = state.data;
                    isToppingsLoading = false;
                    return CustomToppingsSideOptionsWidget(
                      isLoading: false,
                      data: toppingsData,
                      selectedItems: toppings,
                      onItemSelection: (value) {
                        setState(() {
                          if (toppings.contains(value)) {
                            toppings.remove(value);
                          } else {
                            toppings.add(value);
                          }
                        });
                      },
                    );
                  }
                  return CustomToppingsSideOptionsWidget(
                    isLoading: true,
                    data: null,
                    selectedItems: const [],
                    onItemSelection: (value) {},
                  );
                },
              ),

              const Gap(30),
              const CustomText(
                text: "Side Options",
                color: Color(0xff3C2F2F),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              const Gap(15),

              // Side Options Section
              BlocBuilder<
                SideOptionsCubit,
                side_options_state.SideOptionsState
              >(
                bloc: context.read<SideOptionsCubit>(),
                buildWhen: (previous, current) =>
                    current is side_options_state.Loading ||
                    current is side_options_state.Success ||
                    current is side_options_state.Failure,
                builder: (context, state) {
                  if (state is side_options_state.Loading) {
                    return Skeletonizer(
                      enabled: true,
                      child: CustomToppingsSideOptionsWidget(
                        isLoading: true,
                        data: null,
                        selectedItems: const [],
                        onItemSelection: (value) {},
                      ),
                    );
                  } else if (state is side_options_state.Failure) {
                    return Center(
                      child: CustomText(
                        text: "Error: ${state.error}",
                        color: Colors.red,
                      ),
                    );
                  } else if (state is side_options_state.Success) {
                    sideOptionsData = state.data;
                    isSideOptionsLoading = false;
                    return CustomToppingsSideOptionsWidget(
                      isLoading: false,
                      data: sideOptionsData,
                      selectedItems: sideOptions,
                      onItemSelection: (value) {
                        setState(() {
                          if (sideOptions.contains(value)) {
                            sideOptions.remove(value);
                          } else {
                            sideOptions.add(value);
                          }
                        });
                      },
                    );
                  }
                  return CustomToppingsSideOptionsWidget(
                    isLoading: isSideOptionsLoading,
                    data: sideOptionsData,
                    selectedItems: sideOptions,
                    onItemSelection: (value) {
                      setState(() {
                        if (sideOptions.contains(value)) {
                          sideOptions.remove(value);
                        } else {
                          sideOptions.add(value);
                        }
                      });
                    },
                  );
                },
              ),

              const Gap(120),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
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
                  const Gap(13),
                  const CustomText(
                    text: "Total",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  const Gap(10),
                  CustomText(
                    text: "\$ ${widget.price}",
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
              BlocBuilder<GetCartCubit, GetCartState>(
                builder: (context, cartState) {
                  final isInCartNow = _isProductInCart();

                  return CustomMainButton(
                    text: isInCartNow
                        ? "Already in Cart"
                        : (isAddingToCart ? "Adding..." : "Add To Cart"),
                    fontSize: 16,
                    onPressed: (isAddingToCart || isInCartNow)
                        ? null
                        : _addToCart,
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
