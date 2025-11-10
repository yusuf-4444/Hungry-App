import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/shared/custom_text.dart';

SnackBar CustomSnackBar(message, color) {
  return SnackBar(
    clipBehavior: Clip.none,
    elevation: 15,
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    content: Row(
      children: [
        Icon(
          Icons.info,
          color: color == Colors.white ? Colors.black : Colors.white,
        ),
        Gap(20),
        Center(
          child: CustomText(
            text: message,
            color: color == Colors.white ? Colors.black : Colors.white,
          ),
        ),
      ],
    ),
  );
}
