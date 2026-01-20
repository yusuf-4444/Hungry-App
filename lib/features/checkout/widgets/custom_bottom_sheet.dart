import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/checkout/data/models/save_order.dart';
import 'package:hungry_app/features/checkout/logic/cubit/save_order_cubit.dart';
import 'package:hungry_app/features/checkout/logic/cubit/save_order_state.dart';
import 'package:hungry_app/root.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    super.key,
    required this.totalPrice,
    required this.saveOrder,
  });

  final double totalPrice;
  final SaveOrder saveOrder;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  fontsize: 14,
                ),
                const Gap(10),
                CustomText(
                  text: "\$ ${widget.totalPrice + 5 + 20.5}",
                  color: Colors.black,
                  fontsize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ],
            ),
            BlocBuilder<SaveOrderCubit, SaveOrderState>(
              builder: (context, state) {
                return CustomMainButton(
                  text: state is Loading ? "Please Wait..." : "Pay Now",
                  fontSize: 16,
                  onPressed: () async {
                    final cubit = context.read<SaveOrderCubit>();
                    await cubit.saveOrder(widget.saveOrder);
                    if (state is Success) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 170,
                            ),
                            backgroundColor: Colors.white,
                            child: Column(
                              children: [
                                const Gap(15),
                                const CircleAvatar(
                                  radius: 33,
                                  backgroundColor: AppColors.primaryColor,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    size: 40,
                                  ),
                                ),
                                const Gap(30),
                                const CustomText(
                                  text: "Success !",
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontsize: 25,
                                ),
                                const Gap(15),
                                const CustomText(
                                  text:
                                      "Your payment was successful\n.A receipt for this purchase has\n been sent to your email.",
                                  color: Color(0xffBCBBBB),
                                  fontWeight: FontWeight.w400,
                                  fontsize: 14,
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(10),
                                const Spacer(),
                                CustomMainButton(
                                  text: "Go Back",
                                  fontSize: 15,
                                  width: 200,
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Root();
                                        },
                                      ),
                                    );
                                  },
                                ),
                                const Gap(20),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
