import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    this.onPressed,
    required this.itemId,
  });

  final String image;
  final String title;
  final String subTitle;
  final int itemId;
  final void Function()? onPressed;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isRemoving = false;

  Future<void> _removeItem() async {
    if (widget.onPressed == null) return;

    setState(() {
      _isRemoving = true;
    });

    try {
      await context.read<DeleteItemCubit>().deleteItem(widget.itemId);
      widget.onPressed!();
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.image,
                  width: 111,
                  height: 102.18,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const Gap(8),
                CustomText(
                  text: widget.title,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                CustomText(
                  text: widget.subTitle,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                // Quantity Controls
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              child: CustomText(
                                fontSize: 20,
                                text: "-",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        // Quantity Display
                        CustomText(
                          text: quantity.toString(),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        const Gap(20),
                        // Plus Button
                        GestureDetector(
                          onTap: () => cubit.incrementQuantity(widget.itemId),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              child: CustomText(
                                fontSize: 20,
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
                const Gap(30),
                // Remove Button
                BlocBuilder<DeleteItemCubit, DeleteItemState>(
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: _isRemoving ? null : _removeItem,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: CustomText(
                            text: _isRemoving ? "Removing..." : "Remove",
                            color: Colors.white,
                            fontSize: 18,
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
