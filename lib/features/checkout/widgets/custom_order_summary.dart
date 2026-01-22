import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          Gap(15.h),
          customCheckout("Order", "\$ $order", false, false),
          Gap(10.h),
          customCheckout("Taxes", "\$ $taxes", false, false),
          Gap(10.h),
          customCheckout("Delivery Fees", "\$ $deliveryFees", false, false),
          Gap(10.h),
          const Divider(),
          Gap(15.h),
          customCheckout("Total: ", "\$ $total", true, false),
          Gap(20.h),
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
        fontSize: isSmall ? 11.sp : 15.sp,
      ),
      CustomText(
        text: price.toString(),
        color: isBold ? Colors.black : const Color(0xff7d7d7d),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        fontSize: isSmall ? 11.sp : 15.sp,
      ),
    ],
  );
}
