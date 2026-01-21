import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة مع الظل
          Stack(
            children: [
              Positioned(
                bottom: -5.h,
                right: 0,
                left: 0,
                child: Image.asset(
                  "assets/homeIcons/shadow.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                width: double.infinity,
                height: 120.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),

          // العنوان والوصف
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  maxLines: 1,
                  text: title,
                  color: const Color(0xff3C2F2F),
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w600,
                ),
                Gap(5.h),
                CustomText(
                  text: subtitle,
                  color: Colors.grey.shade900,
                  maxLines: 2,
                  fontSize: 12.sp,
                ),
              ],
            ),
          ),

          // مساحة فارغة لدفع الـ Row إلى الأسفل
          const Spacer(),

          // الـ Row الموجود في نهاية الـ Card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/homeIcons/star.svg",
                  width: 18.w,
                  height: 18.h,
                ),
                Gap(5.w),
                CustomText(
                  text: ratings.toStringAsFixed(1),
                  color: const Color(0xff3C2F2F),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
                const Spacer(),
                Icon(
                  Icons.favorite,
                  color: AppColors.primaryColor,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
