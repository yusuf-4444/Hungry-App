import 'package:flutter/material.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/cart/widgets/custom_card.dart';
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
        padding: const EdgeInsets.only(top: 20, bottom: 50, left: 8, right: 8),
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return CustomCard(
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
            );
          },
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Total",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontsize: 15,
                    ),
                    Spacer(),
                    CustomText(
                      text: "\$18.19",
                      color: Colors.black,
                      fontsize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      child: CustomText(
                        text: "CheckOut",
                        color: Colors.white,
                        fontsize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
