import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController controller,
    required this.labelText,
    this.textInputType,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String labelText;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      cursorColor: Colors.white,
      cursorHeight: 18.h,
      controller: _controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }
}
