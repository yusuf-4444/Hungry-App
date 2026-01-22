import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
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
    required this.initialNumber,
    this.onQuantityChanged,
  });

  final String image;
  final String title;
  final String subTitle;
  final int initialNumber;

  final void Function()? onPressed;
  final void Function(int newQuantity)? onQuantityChanged;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isRemoving = false;
  late int number;

  @override
  void initState() {
    number = widget.initialNumber;
    super.initState();
  }

  Future<void> _removeItem() async {
    if (widget.onPressed == null) return;

    setState(() {
      _isRemoving = true;
    });

    try {
      widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() {
          _isRemoving = false;
        });
      }
    }
  }

  void onAdd() {
    context.read<GetCartCubit>().incrementQuantity();
  }

  void onMinus() {
    if (number > 1) {
      setState(() {
        number--;
      });
      widget.onQuantityChanged?.call(number);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: onMinus,
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
                    CustomText(
                      text: number.toString(),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    const Gap(20),
                    BlocBuilder<GetCartCubit, GetCartState>(
                      bloc: context.read<GetCartCubit>(),
                      buildWhen: (previous, current) =>
                          current is Increment || current is Decrement,
                      builder: (context, state) {
                        if (state is Increment) {
                          number = state.data;
                          return GestureDetector(
                            onTap: onAdd,
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
                          );
                        }
                        return GestureDetector(
                          onTap: onAdd,
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
                        );
                      },
                    ),
                  ],
                ),
                const Gap(30),
                Container(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
