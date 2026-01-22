import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/features/cart/logic/deleteItem/delete_item_cubit.dart';
import 'package:hungry_app/features/cart/logic/deleteItem/delete_item_state.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_cubit.dart';
import 'package:hungry_app/features/cart/logic/getCart/get_cart_state.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.itemId,
  });

  final String image;
  final String title;
  final String subTitle;
  final int itemId;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isRemoving = false;

  Future<void> _removeItem() async {
    setState(() {
      _isRemoving = true;
    });

    try {
      await context.read<DeleteItemCubit>().deleteItem(widget.itemId);
      context.read<GetCartCubit>().refreshCart();
    } finally {
      if (mounted) {
        setState(() {
          _isRemoving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GetCartCubit>();

    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.image,
                  width: 95.w,
                  height: 95.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, size: 40.sp),
                ),
                Gap(8.h),
                CustomText(
                  text: widget.title,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
                CustomText(
                  text: widget.subTitle,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                BlocBuilder<GetCartCubit, GetCartState>(
                  builder: (context, state) {
                    final quantity = cubit.getCurrentQuantity(widget.itemId);

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => cubit.decrementQuantity(widget.itemId),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 5.h,
                              ),
                              child: CustomText(
                                fontSize: 20.sp,
                                text: "-",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Gap(20.w),
                        CustomText(
                          text: quantity.toString(),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        Gap(20.w),
                        GestureDetector(
                          onTap: () => cubit.incrementQuantity(widget.itemId),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 5.h,
                              ),
                              child: CustomText(
                                fontSize: 20.sp,
                                text: "+",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Gap(30.h),
                BlocBuilder<DeleteItemCubit, DeleteItemState>(
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TextButton(
                        onPressed: _removeItem,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          child: CustomText(
                            text: _isRemoving ? "Removing..." : "Remove",
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
