import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungry_app/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    this.controller,
  });

  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please Fill The ${widget.hintText}";
        }
        return null;
      },
      obscureText: widget.isPassword == true && isObsecure == true
          ? true
          : false,
      cursorColor: AppColors.primaryColor,
      cursorHeight: 18.h,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObsecure = !isObsecure;
                  setState(() {});
                },
                icon: isObsecure == true
                    ? Icon(Icons.visibility_off, size: 22.sp)
                    : Icon(CupertinoIcons.eye, size: 22.sp),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 14.sp),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(10.r),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
