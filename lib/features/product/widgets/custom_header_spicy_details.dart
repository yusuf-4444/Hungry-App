import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomHeaderSpicyDetails extends StatefulWidget {
  const CustomHeaderSpicyDetails({
    super.key,
    required this.sliderValue,
    this.onChanged,
  });

  final double sliderValue;
  final void Function(double)? onChanged;

  @override
  State<CustomHeaderSpicyDetails> createState() =>
      _CustomHeaderSpicyDetailsState();
}

class _CustomHeaderSpicyDetailsState extends State<CustomHeaderSpicyDetails> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset("assets/details/sandwitch_detail.png", height: 220.h),
        const Spacer(),
        Column(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Customize",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.sp,
                    ),
                  ),
                  TextSpan(
                    text:
                        " Your Burger\n to Your Tastes.\n Ultimate Experience",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Gap(15.h),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: "Spicy",
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            Slider(
              activeColor: AppColors.primaryColor,
              min: 0,
              max: 1,
              value: widget.sliderValue,
              onChanged: widget.onChanged,
            ),
            Row(
              children: [
                Text("🥶", style: TextStyle(fontSize: 20.sp)),
                Gap(115.w),
                Text("🌶️", style: TextStyle(fontSize: 20.sp)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
