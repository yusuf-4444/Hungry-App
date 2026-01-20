import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomCardOrderHistory extends StatelessWidget {
  const CustomCardOrderHistory({
    super.key,
    required this.image,
    required this.title,
    required this.quantity,
    required this.price,
  });

  final String image;
  final String title;
  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset("assets/test/test.png", width: 111, height: 102.18),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "HumBurger HumBurger",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontsize: 16,
                    ),
                    CustomText(text: "Qty: x3", color: Colors.black),
                    CustomText(text: "Price: \$20", color: Colors.black),
                  ],
                ),
              ],
            ),
            const Gap(10),
            CustomMainButton(
              text: "Order Again",
              fontSize: 15,
              width: double.infinity,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
