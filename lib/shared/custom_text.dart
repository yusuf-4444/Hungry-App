import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.color,
    this.fontWeight,
    this.fontsize,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final Color color;
  final FontWeight? fontWeight;
  final double? fontsize;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontsize,
        fontWeight: fontWeight,
      ),
    );
  }
}
