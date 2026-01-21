import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/cart/data/models/addToCart/add_to_cart_model.dart';
import 'package:hungry_app/features/home/data/models/side_options_model.dart';
import 'package:hungry_app/features/home/data/models/toppings_model.dart';
import 'package:hungry_app/features/product/widgets/custom_header_spicy_details.dart';
import 'package:hungry_app/features/product/widgets/custom_toppings_side_options.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:hungry_app/shared/custom_text.dart';

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

  // TODO: Add your state management here
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
    // TODO: Call your data fetching methods here
    // _fetchToppings();
    // _fetchSideOptions();
  }

  Future<void> _fetchToppings() async {
    setState(() {
      isToppingsLoading = true;
      toppingsError = null;
    });

    try {
      // TODO: Fetch toppings data
      // final data = await yourService.getToppings();
      // setState(() {
      //   toppingsData = data;
      //   isToppingsLoading = false;
      // });
    } catch (e) {
      setState(() {
        toppingsError = e.toString();
        isToppingsLoading = false;
      });
    }
  }

  Future<void> _fetchSideOptions() async {
    setState(() {
      isSideOptionsLoading = true;
      sideOptionsError = null;
    });

    try {
      // TODO: Fetch side options data
      // final data = await yourService.getSideOptions();
      // setState(() {
      //   sideOptionsData = data;
      //   isSideOptionsLoading = false;
      // });
    } catch (e) {
      setState(() {
        sideOptionsError = e.toString();
        isSideOptionsLoading = false;
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      isAddingToCart = true;
    });

    try {
      final cartData = _cartData();

      // TODO: Add to cart logic
      // await yourService.addToCart(cartData);
      // await yourService.refreshCart();

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
            Navigator.pop(context);
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
              CustomToppingsSideOptionsWidget(
                isLoading: isToppingsLoading,
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
              CustomToppingsSideOptionsWidget(
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
              CustomMainButton(
                text: isAddingToCart ? "Adding..." : "Add To Cart",
                fontSize: 16,
                onPressed: isAddingToCart ? null : _addToCart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
