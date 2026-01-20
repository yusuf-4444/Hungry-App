import 'package:flutter/material.dart';
import 'package:hungry_app/core/constants/app_colors.dart';
import 'package:hungry_app/shared/custom_text.dart';

class CustomHomeCategory extends StatelessWidget {
  const CustomHomeCategory({
    super.key,
    required this.category,
    required this.selectedIndex,
    this.onTap,
  });

  final List<String> category;
  final int selectedIndex;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          category.length,
          (index) => _buildCategoryChip(index),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(int index) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => onTap?.call(index),
        child: Material(
          elevation: isSelected ? 5 : 0,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor
                  : const Color(0xffF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: CustomText(
                text: category[index],
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontsize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
