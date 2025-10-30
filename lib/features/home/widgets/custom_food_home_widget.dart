import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomFoodHomeWidget extends StatelessWidget {
  const CustomFoodHomeWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.ratings,
  });

  final String image;
  final String title;
  final String subtitle;
  final double ratings;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      color: Colors.white,
      child: Column(
        children: [
          Gap(10),
          Image.asset(image, width: 120),
          Gap(10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    color: Color(0xff3C2F2F),
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(text: subtitle, color: Colors.grey.shade900),
                  Gap(10),
                  Row(
                    children: [
                      SvgPicture.asset("assets/homeIcons/star.svg"),
                      Gap(5),
                      CustomText(
                        text: ratings.toString(),
                        color: Color(0xff3C2F2F),
                        fontWeight: FontWeight.w600,
                        fontsize: 16,
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
