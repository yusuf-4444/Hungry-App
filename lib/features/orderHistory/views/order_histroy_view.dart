import 'package:flutter/material.dart';
import 'package:hungry_app/features/orderHistory/widgets/custom_card_order_history.dart';

class OrderHistroyView extends StatelessWidget {
  const OrderHistroyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, item) {
          return CustomCardOrderHistory(
            image: "assets/test/test.png",
            title: "HumBurger HumBurger",
            quantity: 3,
            price: 20,
          );
        },
      ),
    );
  }
}
