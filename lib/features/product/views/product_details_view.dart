import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/checkout/views/checkout_view.dart';
import 'package:hungry_app/features/product/widgets/custom_header_spicy_details.dart';
import 'package:hungry_app/features/product/widgets/custom_toppings_side_options.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double sliderValue = 0.5;

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

              CustomToppingsSideOptionsWidget(),
              Gap(30),
              CustomText(
                text: "Side Options",
                color: Color(0xff3C2F2F),
                fontWeight: FontWeight.w600,
                fontsize: 18,
              ),
              Gap(15),

              CustomToppingsSideOptionsWidget(),

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
              CustomMainButton(
                text: "Add To Cart",
                fontSize: 16,
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
    );
  }
}
