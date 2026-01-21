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
          (index) => _CategoryChip(
            categoryName: category[index],
            isSelected: selectedIndex == index,
            onTap: () => onTap?.call(index),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.categoryName,
    required this.isSelected,
    required this.onTap,
  });

  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
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
                text: categoryName,
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
