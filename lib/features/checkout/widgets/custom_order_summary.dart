import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomOrderSummary extends StatelessWidget {
  const CustomOrderSummary({
    super.key,
    required this.order,
    required this.taxes,
    required this.deliveryFees,
    required this.total,
  });

  final double order;
  final double taxes;
  final double deliveryFees;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const Gap(15),
          customCheckout("Order", "\$ $order", false, false),
          const Gap(10),
          customCheckout("Taxes", "\$ $taxes", false, false),
          const Gap(10),
          customCheckout("Delivery Fees", "\$ $deliveryFees", false, false),
          const Gap(10),
          const Divider(),
          const Gap(15),
          customCheckout("Total: ", "\$ $total", true, false),
          const Gap(20),
          customCheckout(
            "Estimated delivery time: ",
            "15 - 30 mins",
            true,
            true,
          ),
        ],
      ),
    );
  }
}

Widget customCheckout(text, price, isBold, isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: text,
        color: isBold ? Colors.black : const Color(0xff7d7d7d),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        fontSize: isSmall ? 11 : 15,
      ),
      CustomText(
        text: price.toString(),
        color: isBold ? Colors.black : const Color(0xff7d7d7d),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        fontSize: isSmall ? 11 : 15,
      ),
    ],
  );
}
