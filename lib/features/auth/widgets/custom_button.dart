import 'package:flutter/material.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    required this.isBackgroudnGreen,
  });

  final void Function()? onPressed;
  final String text;
  final Color? color;
  final bool isBackgroudnGreen;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
        ),
        child: CustomText(
          text: text,
          color: isBackgroudnGreen ? Colors.white : AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
