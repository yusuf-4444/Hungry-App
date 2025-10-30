import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/shared/custom_text.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/logo/Hungry_.svg",
              color: AppColors.primaryColor,
              height: 35,
            ),
            Gap(5),
            CustomText(text: "Hello, $name", color: Colors.grey.shade600),
          ],
        ),
        Spacer(),
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.primaryColor,
          child: Icon(CupertinoIcons.person, color: Colors.white),
        ),
      ],
    );
  }
}
