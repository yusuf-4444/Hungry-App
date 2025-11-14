import 'package:flutter/material.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomHomeCategory extends StatefulWidget {
  const CustomHomeCategory({
    super.key,
    required this.category,
    required this.selectedIndex,
    this.onTap,
  });

  final List category;
  final int selectedIndex;
  final void Function(int)? onTap;

  @override
  State<CustomHomeCategory> createState() => _CustomHomeCategoryState();
}

class _CustomHomeCategoryState extends State<CustomHomeCategory> {
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = 0;
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.category.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                selectedIndex = index;
                widget.onTap;
                setState(() {});
              },
              child: Material(
                elevation: selectedIndex == index ? 5 : 0,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColors.primaryColor
                        : Color(0xffF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: CustomText(
                      text: widget.category[index],
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.grey.shade700,
                      fontsize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
