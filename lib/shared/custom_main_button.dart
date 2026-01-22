import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomMainButton extends StatelessWidget {
  const CustomMainButton({
    super.key,
    required this.text,
    this.width,
    required this.fontSize,
    this.onPressed,
  });

  final String text;
  final double? width;
  final double fontSize;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: CustomText(
            text: text,
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
