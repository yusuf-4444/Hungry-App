import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/features/cart/widgets/custom_card.dart';
import 'package:hungry_app/features/checkout/views/checkout_view.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int itemCount = 20;
  late List<int> quantities;
  @override
  void initState() {
    quantities = List.generate(itemCount, (index) => 1);
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 80, left: 8, right: 8),
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: CustomCard(
                onPressed: () {},
                image: "assets/test/test.png",
                title: "Hamburger",
                subTitle: 'Veggie Burger',
                number: quantities[index],
                onAdd: () {
                  onAdd(index);
                },
                onMinus: () {
                  onMinus(index);
                },
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
    );
  }
}
