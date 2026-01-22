import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/core/route/app_routes.dart';
import 'package:hungry_app/features/cart/logic/deleteItem/delete_item_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_state.dart'
    as cart_state;
import 'package:hungry_app/features/checkout/data/models/save_order.dart';
import 'package:hungry_app/features/checkout/logic/cubit/save_order_cubit.dart';
import 'package:hungry_app/features/checkout/logic/cubit/save_order_state.dart';
import 'package:hungry_app/shared/custom_main_button.dart';
import 'package:hungry_app/shared/custom_snack_bar.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    super.key,
    required this.totalPrice,
    required this.saveOrder,
    required this.orderItems,
  });

  final double totalPrice;
  final SaveOrder saveOrder;
  final List<OrderItems> orderItems;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool _isProcessing = false;

  Future<void> _handlePayment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await context.read<SaveOrderCubit>().saveOrder(widget.saveOrder);

      final cartCubit = context.read<GetCartCubit>();
      final cartState = cartCubit.state;

      cartState.maybeWhen(
        success: (cartData) async {
          final cartItems = cartData.data.items;

          for (var item in cartItems) {
            await context.read<DeleteItemCubit>().deleteItem(item.itemId);
          }

          await cartCubit.refreshCart();
        },
        orElse: () {},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar('Error processing payment: $e', Colors.red),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 300.h),
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Gap(15.h),
              CircleAvatar(
                radius: 33.r,
                backgroundColor: AppColors.primaryColor,
                child: Icon(Icons.check, color: Colors.white, size: 40.sp),
              ),
              Gap(30.h),
              CustomText(
                text: "Success !",
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 25.sp,
              ),
              Gap(15.h),
              CustomText(
                text:
                    "Your payment was successful\n.A receipt for this purchase has\n been sent to your email.",
                color: const Color(0xffBCBBBB),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                textAlign: TextAlign.center,
              ),
              Gap(30.h),
              CustomMainButton(
                text: "Go Back",
                fontSize: 15.sp,
                width: 200.w,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.root,
                    (_) => false,
                  );
                },
              ),
              Gap(20.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveOrderCubit, SaveOrderState>(
      listener: (context, state) {
        if (state is Success) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
            context.read<GetCartCubit>().clearCache();
            _showSuccessDialog(context);
          }
        } else if (state is Failure) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar('Payment failed: ${state.error}', Colors.red),
            );
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is Loading || _isProcessing;

        return Container(
          height: 135.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.shade800, blurRadius: 8)],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(13.h),
                    CustomText(
                      text: "Total",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    Gap(10.h),
                    CustomText(
                      text:
                          "\$ ${(widget.totalPrice + 5 + 20.5).toStringAsFixed(2)}",
                      color: Colors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
                CustomMainButton(
                  text: isLoading ? "Processing..." : "Pay Now",
                  fontSize: 16.sp,
                  onPressed: isLoading ? null : _handlePayment,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
